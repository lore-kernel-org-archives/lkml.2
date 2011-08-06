Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964773Ab1HFAMJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 20:12:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39674 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932419Ab1HFAMA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 20:12:00 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug  5 17:04:12 2011
Message-Id: <20110806000412.360509490@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 05 Aug 2011 17:03:26 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Luca Tettamanti <kronos.it@gmail.com>,
        Jean Delvare <khali@linux-fr.org>
Subject: [08/50] hwmon: (asus_atk0110) Fix memory leak
In-Reply-To: <20110806000419.GA28392@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

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
@@ -654,6 +654,7 @@ static int atk_debugfs_gitm_get(void *p,
 	else
 		err = -EIO;
 
+	ACPI_FREE(ret);
 	return err;
 }
 


