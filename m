Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120Ab2BRXIe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Feb 2012 18:08:34 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:62299 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753670Ab2BRXIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Feb 2012 18:08:31 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of jorgyano@gmail.com designates 10.52.68.98 as permitted sender) smtp.mail=jorgyano@gmail.com; dkim=pass header.i=jorgyano@gmail.com
MIME-Version: 1.0
In-Reply-To: <1329604310.1753.30.camel@joe2Laptop>
References: <1329603020-5302-1-git-send-email-jorgyano@gmail.com>
	<1329604310.1753.30.camel@joe2Laptop>
Date: Sat, 18 Feb 2012 21:08:30 -0200
Message-ID: <CABRD5hKU0a-z8qd+xQEcHzH3y3eFy+sxUUtg1NXi+fqmbw4h4A@mail.gmail.com>
Subject: Re: [PATCH 3/3 v2] Staging: crystalhd: Replace the BCMLOG_ERR macro
 with pr_err
From: Jorgyano vieira <jorgyano@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: gregkh@linuxfoundation.org, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, nsankar@broadcom.com, jarod@wilsonet.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 18, 2012 at 8:31 PM, Joe Perches <joe@perches.com> wrote:
> On Sat, 2012-02-18 at 20:10 -0200, Jorgyano Vieira wrote:
>> Replace the usage of BCMLOG_ERR with pr_err and remove the macro definition.
>> Also added pr_fmt to identify the driver error messages.
>
> Hi Jorgyano.
Hi Joe,
>
> Couple of generic comments.
>
> o Please look for and fix spelling errors at the same time.
People are blamed for doing more-then-one-thing-per-patch,
so I prefer send only one big patch fixing all spelling errors and
coding style on further work.

> o Coalesce formats, don't worry about 80 columns for that.
> o pr_fmt needs to be #defined before any #include that might
>  directly or indirectly #include kernel.h/printk.h
>  use 'strings <path>/built-in.o | grep "^<.>"' to verify.
yes, I take care of this:--- a/drivers/staging/crystalhd/crystalhd_misc.h
+++ b/drivers/staging/crystalhd/crystalhd_misc.h
@@ -28,6 +28,8 @@
 #ifndef _CRYSTALHD_MISC_H_
 #define _CRYSTALHD_MISC_H_

+#define pr_fmt(fmt)    KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/errno.h>

> o [kv][kzm]alloc failures don't need specific OOM messages
>  as the generic function does a dump_stack
You are right, this code really have some unnecessary messages,
perhaps it could be done on further patch, all at once.
The main idea on this patch is just replace convert the old macro to pr_err.

> o argument alignment could be after the open parenthesis.
yes, it could be done together with the coding style issues.

there is a lot of work to do on this driver.

Many thanks for your comments.

regards,
Jorgyano Vieira
