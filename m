Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759389Ab0GAVhj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 17:37:39 -0400
Received: from kroah.org ([198.145.64.141]:33018 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759220Ab0GAVOo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 17:14:44 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:42:58 2010
Message-Id: <20100701174258.314043063@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:43:51 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Dominik Brodowski <linux@dominikbrodowski.net>
Subject: [141/200] pcmcia: avoid validate_cis failure on CIS override
In-Reply-To: <20100701175201.GA2149@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dominik Brodowski <linux@dominikbrodowski.net>

commit b83156b52dd77979cc93bafc2283929532f6f7d0 upstream.

Commit a8408c17 introduced a new check to pccard_validate_cis(),
which avoids any "late" calls to this function. This broke the
insertion of cards which require a CIS override which changes
the number of card functions. Fix this by asserting that this
is _not_ a late call, but a proper call early during the card
insertion process.

Fixes https://bugzilla.kernel.org/show_bug.cgi?id=16138

Reported-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pcmcia/ds.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/pcmcia/ds.c
+++ b/drivers/pcmcia/ds.c
@@ -682,6 +682,7 @@ static void pcmcia_requery(struct pcmcia
 		if (old_funcs != new_funcs) {
 			/* we need to re-start */
 			pcmcia_card_remove(s, NULL);
+			s->functions = 0;
 			pcmcia_card_add(s);
 		}
 	}


