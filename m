Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932910Ab0G3SFV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 14:05:21 -0400
Received: from kroah.org ([198.145.64.141]:59277 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932840Ab0G3R54 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:57:56 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:51:51 2010
Message-Id: <20100730175151.585749455@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:53:32 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dominik Brodowski <linux@dominikbrodowski.net>
Subject: [195/205] pcmcia: do not initialize the present flag too late.
In-Reply-To: <20100730175238.GA3924@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dominik Brodowski <linux@dominikbrodowski.net>

commit e4f1ac2122413736bf2791d3af6533f36b46fc61 upstream.

The "present" flag was initialized too late -- possibly, a card
was already registered at this time, so re-setting the flag to 0
caused pcmcia_dev_present() to fail.

Reported-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pcmcia/ds.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/pcmcia/ds.c
+++ b/drivers/pcmcia/ds.c
@@ -1366,6 +1366,7 @@ static int __devinit pcmcia_bus_add_sock
 	INIT_LIST_HEAD(&socket->devices_list);
 	memset(&socket->pcmcia_state, 0, sizeof(u8));
 	socket->device_count = 0;
+	atomic_set(&socket->present, 0);
 
 	ret = pccard_register_pcmcia(socket, &pcmcia_bus_callback);
 	if (ret) {
@@ -1374,8 +1375,6 @@ static int __devinit pcmcia_bus_add_sock
 		return ret;
 	}
 
-	atomic_set(&socket->present, 0);
-
 	return 0;
 }
 


