Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932490Ab2CBTCs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 14:02:48 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:37322 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216Ab2CBTCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 14:02:47 -0500
Date: Fri, 2 Mar 2012 22:01:28 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Matt Fleming <matt.fleming@intel.com>,
        Maarten Lankhorst <m.b.lankhorst@gmail.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] x86, efi: fix pointer math issue in handle_ramdisks()
Message-ID: <20120302190128.GC3951@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090208.4F511910.006A,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"filename" is a efi_char16_t string so this check for reaching the end
of the array doesn't work.  We need to cast it to char pointer before
doing the math.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index fec216f..cf4cdb7 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -559,7 +559,7 @@ static efi_status_t handle_ramdisks(efi_loaded_image_t *image,
 			str++;
 
 		while (*str && *str != ' ' && *str != '\n') {
-			if (p >= filename + sizeof(filename))
+			if ((char *)p >= (char *)filename + sizeof(filename))
 				break;
 
 			*p++ = *str++;
