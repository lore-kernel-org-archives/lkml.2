Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753926Ab0DFKor (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 06:44:47 -0400
Received: from mail-fx0-f223.google.com ([209.85.220.223]:35946 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752778Ab0DFKoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 06:44:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=r6iTZU5XMOrpXKnr3beRQ/LJx7BusY63jFLgv6MRR3VteT1/3eG2mTDXI5v8O8PrGk
         tDI3mgaJkLRRkVhbEggk6CNv6e6Ec8PnJzqjnnTSzkVkoxWExrWgBQFQ86EIfuOUtrjw
         bsd20njVbtHdepqlRMzKNv1f6n/yCW66o9kZg=
Date: Tue, 6 Apr 2010 13:44:29 +0300
From: Dan Carpenter <error27@gmail.com>
To: Corentin Chary <corentincj@iksaif.net>
Cc: Matthew Garrett <mjg@redhat.com>, Len Brown <len.brown@intel.com>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       acpi4asus-user@lists.sourceforge.net,
       platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [patch] asus: don't modify bluetooth/wlan on boot
Message-ID: <20100406104429.GB21229@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Corentin Chary <corentincj@iksaif.net>,
	Matthew Garrett <mjg@redhat.com>, Len Brown <len.brown@intel.com>,
	Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
	acpi4asus-user@lists.sourceforge.net,
	platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We were storing -1 as an unsigned int and as a result the effect of 
passing -1 was the same as using 1.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/platform/x86/asus-laptop.c b/drivers/platform/x86/asus-laptop.c
index 475ab50..f532336 100644
--- a/drivers/platform/x86/asus-laptop.c
+++ b/drivers/platform/x86/asus-laptop.c
@@ -78,15 +78,15 @@ static uint wapf = 1;
 module_param(wapf, uint, 0644);
 MODULE_PARM_DESC(wapf, "WAPF value");
 
-static uint wlan_status = 1;
-static uint bluetooth_status = 1;
+static int wlan_status = 1;
+static int bluetooth_status = 1;
 
-module_param(wlan_status, uint, 0644);
+module_param(wlan_status, int, 0644);
 MODULE_PARM_DESC(wlan_status, "Set the wireless status on boot "
 		 "(0 = disabled, 1 = enabled, -1 = don't do anything). "
 		 "default is 1");
 
-module_param(bluetooth_status, uint, 0644);
+module_param(bluetooth_status, int, 0644);
 MODULE_PARM_DESC(bluetooth_status, "Set the wireless status on boot "
 		 "(0 = disabled, 1 = enabled, -1 = don't do anything). "
 		 "default is 1");
