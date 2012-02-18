Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753751Ab2BRXea (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Feb 2012 18:34:30 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:55757 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753065Ab2BRXeX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Feb 2012 18:34:23 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of jorgyano@gmail.com designates 10.52.173.232 as permitted sender) smtp.mail=jorgyano@gmail.com; dkim=pass header.i=jorgyano@gmail.com
MIME-Version: 1.0
In-Reply-To: <1329606877.1753.37.camel@joe2Laptop>
References: <1329603020-5302-1-git-send-email-jorgyano@gmail.com>
	<1329604310.1753.30.camel@joe2Laptop>
	<CABRD5hKU0a-z8qd+xQEcHzH3y3eFy+sxUUtg1NXi+fqmbw4h4A@mail.gmail.com>
	<1329606877.1753.37.camel@joe2Laptop>
Date: Sat, 18 Feb 2012 21:34:21 -0200
Message-ID: <CABRD5hK5+aRg5eYJ4bQhUPfiSJcqc6_bc97z3y5r2nEogn-H3Q@mail.gmail.com>
Subject: Re: [PATCH 3/3 v2] Staging: crystalhd: Replace the BCMLOG_ERR macro
 with pr_err
From: Jorgyano vieira <jorgyano@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: gregkh@linuxfoundation.org, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, nsankar@broadcom.com, jarod@wilsonet.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 18, 2012 at 9:14 PM, Joe Perches <joe@perches.com> wrote:
> On Sat, 2012-02-18 at 21:08 -0200, Jorgyano vieira wrote:
>> > o pr_fmt needs to be #defined before any #include that might
>> >  directly or indirectly #include kernel.h/printk.h
>> >  use 'strings <path>/built-in.o | grep "^<.>"' to verify.
>> yes, I take care of this:--- a/drivers/staging/crystalhd/crystalhd_misc.h
>> +++ b/drivers/staging/crystalhd/crystalhd_misc.h
>> @@ -28,6 +28,8 @@
>>  #ifndef _CRYSTALHD_MISC_H_
>>  #define _CRYSTALHD_MISC_H_
>>
>> +#define pr_fmt(fmt)    KBUILD_MODNAME ": " fmt
>> +
>
> Maybe.
>
> $ grep -rP --include=*.[ch] -m1 "^[ \t]*#[ \t]*include" drivers/staging/crystalhd/
> drivers/staging/crystalhd/crystalhd_cmds.h:#include "crystalhd_misc.h"
> drivers/staging/crystalhd/crystalhd_lnx.c:#include <linux/mutex.h>
> drivers/staging/crystalhd/crystalhd_cmds.c:#include "crystalhd_cmds.h"
> drivers/staging/crystalhd/bc_dts_types.h:#include <stdint.h>
> drivers/staging/crystalhd/bc_dts_glob_lnx.h:#include <stdio.h>
> drivers/staging/crystalhd/crystalhd_misc.c:#include <linux/slab.h>
> drivers/staging/crystalhd/crystalhd_misc.h:#include <linux/module.h>
> drivers/staging/crystalhd/crystalhd_lnx.h:#include <linux/module.h>
> drivers/staging/crystalhd/crystalhd_hw.h:#include "crystalhd_misc.h"
> drivers/staging/crystalhd/crystalhd_hw.c:#include <linux/pci.h>
>
> so lnx, cmds, misc, and hw.c are/were suspect.
>

this is the output after the patch:

$ grep -rP --include=*.[ch] -m1 "^[ \t]*#[ \t]*include"
drivers/staging/crystalhd/
drivers/staging/crystalhd/crystalhd_misc.c:#include "crystalhd_misc.h"
drivers/staging/crystalhd/crystalhd_cmds.c:#include "crystalhd_cmds.h"
drivers/staging/crystalhd/crystalhd_lnx.c:#include "crystalhd_lnx.h"
drivers/staging/crystalhd/crystalhd_hw.h:#include "crystalhd_misc.h"
drivers/staging/crystalhd/bc_dts_glob_lnx.h:#include <stdio.h>
drivers/staging/crystalhd/crystalhd_cmds.h:#include "crystalhd_misc.h"
drivers/staging/crystalhd/crystalhd_misc.h:#include <linux/module.h>
drivers/staging/crystalhd/bc_dts_types.h:#include <stdint.h>
drivers/staging/crystalhd/crystalhd_hw.c:#include "crystalhd_hw.h"
drivers/staging/crystalhd/crystalhd_lnx.h:#include "crystalhd_cmds.h"
