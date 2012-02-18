Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157Ab2BRXOm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Feb 2012 18:14:42 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:58929 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753673Ab2BRXOj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Feb 2012 18:14:39 -0500
Message-ID: <1329606877.1753.37.camel@joe2Laptop>
Subject: Re: [PATCH 3/3 v2] Staging: crystalhd: Replace the BCMLOG_ERR macro
 with pr_err
From: Joe Perches <joe@perches.com>
To: Jorgyano vieira <jorgyano@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, nsankar@broadcom.com, jarod@wilsonet.com
Date: Sat, 18 Feb 2012 15:14:37 -0800
In-Reply-To: <CABRD5hKU0a-z8qd+xQEcHzH3y3eFy+sxUUtg1NXi+fqmbw4h4A@mail.gmail.com>
References: <1329603020-5302-1-git-send-email-jorgyano@gmail.com>
	 <1329604310.1753.30.camel@joe2Laptop>
	 <CABRD5hKU0a-z8qd+xQEcHzH3y3eFy+sxUUtg1NXi+fqmbw4h4A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-02-18 at 21:08 -0200, Jorgyano vieira wrote:
> > o pr_fmt needs to be #defined before any #include that might
> >  directly or indirectly #include kernel.h/printk.h
> >  use 'strings <path>/built-in.o | grep "^<.>"' to verify.
> yes, I take care of this:--- a/drivers/staging/crystalhd/crystalhd_misc.h
> +++ b/drivers/staging/crystalhd/crystalhd_misc.h
> @@ -28,6 +28,8 @@
>  #ifndef _CRYSTALHD_MISC_H_
>  #define _CRYSTALHD_MISC_H_
> 
> +#define pr_fmt(fmt)    KBUILD_MODNAME ": " fmt
> +

Maybe.

$ grep -rP --include=*.[ch] -m1 "^[ \t]*#[ \t]*include" drivers/staging/crystalhd/
drivers/staging/crystalhd/crystalhd_cmds.h:#include "crystalhd_misc.h"
drivers/staging/crystalhd/crystalhd_lnx.c:#include <linux/mutex.h>
drivers/staging/crystalhd/crystalhd_cmds.c:#include "crystalhd_cmds.h"
drivers/staging/crystalhd/bc_dts_types.h:#include <stdint.h>
drivers/staging/crystalhd/bc_dts_glob_lnx.h:#include <stdio.h>
drivers/staging/crystalhd/crystalhd_misc.c:#include <linux/slab.h>
drivers/staging/crystalhd/crystalhd_misc.h:#include <linux/module.h>
drivers/staging/crystalhd/crystalhd_lnx.h:#include <linux/module.h>
drivers/staging/crystalhd/crystalhd_hw.h:#include "crystalhd_misc.h"
drivers/staging/crystalhd/crystalhd_hw.c:#include <linux/pci.h>

so lnx, cmds, misc, and hw.c are/were suspect.

cheers, Joe

