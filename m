Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752982Ab1BHVeo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 16:34:44 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:34484 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752496Ab1BHVen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 16:34:43 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBAJhFUU1Ld/sX/2dsb2JhbAAMhA+cM7IYkEOEZHYEhHuMMw
X-IronPort-AV: E=Sophos;i="4.60,443,1291611600"; 
   d="scan'208";a="90963687"
Message-ID: <4D51B6EF.5000409@teksavvy.com>
Date: Tue, 08 Feb 2011 16:34:39 -0500
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-GB; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>,
        Jarod Wilson <jarod@wilsonet.com>, Greg Kroah-Hartman <greg@kroah.com>
Subject: Re: PATCH: drivers/staging/lirc/lirc_serial.c: use IS_ERR()
References: <4D4F0701.5060602@teksavvy.com>
In-Reply-To: <4D4F0701.5060602@teksavvy.com>
Content-Type: multipart/mixed;
 boundary="------------060908000505050604020002"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060908000505050604020002
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11-02-06 03:39 PM, Mark Lord wrote:
> The lirc_serial.c module has never worked with ordinary homebrew
> serial blaster hardware, and leaks memory when this is attempted.
> 
> Fix it by replacing incorrect usage of PTR_ERR() with IS_ERR().
> (patch is inline and also attached to bypass mailer issues).
> 
> Signed-off-by: Mark Lord <mlord@pobox.com>
> 
> --- linux-2.6.37/drivers/staging/lirc/lirc_serial.c	2011-01-04
> 19:50:19.000000000 -0500
> +++ linux/drivers/staging/lirc/lirc_serial.c	2011-02-06 15:33:49.854453928 -0500
> @@ -966,7 +966,7 @@
>  	if (n % sizeof(int) || count % 2 == 0)
>  		return -EINVAL;
>  	wbuf = memdup_user(buf, n);
> -	if (PTR_ERR(wbuf))
> +	if (IS_ERR(wbuf))
>  		return PTR_ERR(wbuf);
>  	spin_lock_irqsave(&hardware[type].lock, flags);
>  	if (type == LIRC_IRDEO) {


Anyone out there?

Greg?

--------------060908000505050604020002
Content-Type: text/x-patch;
 name="lirc_serial_fix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="lirc_serial_fix.patch"

--- linux-2.6.37/drivers/staging/lirc/lirc_serial.c.orig	2011-01-04 19:50:19.000000000 -0500
+++ linux/drivers/staging/lirc/lirc_serial.c	2011-02-06 15:33:49.854453928 -0500
@@ -966,7 +966,7 @@
 	if (n % sizeof(int) || count % 2 == 0)
 		return -EINVAL;
 	wbuf = memdup_user(buf, n);
-	if (PTR_ERR(wbuf))
+	if (IS_ERR(wbuf))
 		return PTR_ERR(wbuf);
 	spin_lock_irqsave(&hardware[type].lock, flags);
 	if (type == LIRC_IRDEO) {

--------------060908000505050604020002--
