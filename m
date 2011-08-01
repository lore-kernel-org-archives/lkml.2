Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051Ab1HAX0r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 19:26:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38670 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754024Ab1HAX0e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 19:26:34 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Aug  1 16:20:55 2011
Message-Id: <20110801232055.542776933@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 01 Aug 2011 16:19:04 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Luca Tettamanti <kronos.it@gmail.com>,
        Jean Delvare <khali@linux-fr.org>
Subject: [49/70] hwmon: (asus_atk0110) Fix memory leak
In-Reply-To: <20110801232124.GA15313@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Luca Tettamanti <kronos.it@gmail.com>

commit 0b8e77f12cb6bfe2e5a67f2cdc8c7af23abc4ccf upstream.

The object returned by atk_gitm is dynamically allocated and must be
freed.

Signed-off-by: Luca Tettamanti <kronos.it@gmail.com>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hwmon/asus_atk0110.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/hwmon/asus_atk0110.c
+++ b/drivers/hwmon/asus_atk0110.c
@@ -673,6 +673,7 @@ static int atk_debugfs_gitm_get(void *p,
 	else
 		err = -EIO;
 
+	ACPI_FREE(ret);
 	return err;
 }
 


