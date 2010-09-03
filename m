Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200Ab0ICNOU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 09:14:20 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:50525 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752597Ab0ICNOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 09:14:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=kvk51ykQdKzhzXWc3uuvCe9ZGCBl6hAkR29i7yz/JKafcRmOvPpC/r8qYYjqN7lovX
         38KdO3WrjEamOLc8P5vmkgY3b1yu29BxP2x9+Zdj//mNarosIsPUgWIac5AEkogtFrpr
         lNk+1PAr92SpOHfvp3CXRmbA5aXkBXy2EfxmU=
Date: Fri, 3 Sep 2010 14:41:06 +0200
From: Dan Carpenter <error27@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: mark gross <markgross@thegnar.org>,
        James Bottomley <James.Bottomley@suse.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch] pm_qos_params: cleanup: terminate a string
Message-ID: <20100903124105.GJ5437@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	mark gross <markgross@thegnar.org>,
	James Bottomley <James.Bottomley@suse.de>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is just a picky thing, but we pass an possibly unterminated string
to printk if debugging is turned on.  Also printk level is set to
"debug" by pr_debug() so the "KERN_ERR" isn't used.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/kernel/pm_qos_params.c b/kernel/pm_qos_params.c
index b7e4c36..310a51e 100644
--- a/kernel/pm_qos_params.c
+++ b/kernel/pm_qos_params.c
@@ -389,10 +389,11 @@ static ssize_t pm_qos_power_write(struct file *filp, const char __user *buf,
 	} else if (count == 11) { /* len('0x12345678/0') */
 		if (copy_from_user(ascii_value, buf, 11))
 			return -EFAULT;
+		ascii_value[10] = '\0';
 		x = sscanf(ascii_value, "%x", &value);
 		if (x != 1)
 			return -EINVAL;
-		pr_debug(KERN_ERR "%s, %d, 0x%x\n", ascii_value, x, value);
+		pr_debug("%s, %d, 0x%x\n", ascii_value, x, value);
 	} else
 		return -EINVAL;
 
