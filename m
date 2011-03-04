Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750911Ab1CDF2J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 00:28:09 -0500
Received: from mga02.intel.com ([134.134.136.20]:46815 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750703Ab1CDF2H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 00:28:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,262,1297065600"; 
   d="scan'208";a="608950268"
Subject: Re: mmotm 2011-03-02 - ACPI/sysfs WARNING with NVidia graphics card
From: Zhang Rui <rui.zhang@intel.com>
To: "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>
Cc: Greg KH <gregkh@suse.de>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Len Brown <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
In-Reply-To: <8842.1299212930@localhost>
References: <201103030127.p231ReNl012841@imap1.linux-foundation.org>
	 <33350.1299196241@localhost>            <20110304000550.GA2073@suse.de>
	 <8842.1299212930@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Mar 2011 13:25:07 +0800
Message-ID: <1299216307.11723.8.camel@rui>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-03-04 at 12:28 +0800, Valdis.Kletnieks@vt.edu wrote: 
> On Thu, 03 Mar 2011 16:05:50 PST, Greg KH said:
> 
> > > [    0.818236] [Firmware Bug]: Duplicate ACPI video bus devices for the same VGA controller, please try module parameter "video.allow_duplicates=1"if the current driver doesn't work.
> > 
> > Have you tried this option?
> > 
> > There's nothing sysfs can do here, sorry, it really looks like you have
> > a BIOS/firmware problem.
> 
right.
this warning message is printed out because there are two ACPI devices
for the same VGA controller, and Linux has no idea which can actually
change the backlight.

> Well, (a) it's been saying "try it if the current driver doesn't work" - and
> things have worked just fine all along (or more properly, if it's broken in
> behavior, I haven't actually seen the effects...)
> 
> and (b) Something changed very recently to add the WARNING, which wasn't there
> in rc5-next-2011022.
> 
well. c504f8cb has been shipped in 2.6.33-rc5.
can you attach the acpidump output of this machine please?
please attach the dmesg output both with and without this warning.
please attach the output of "grep . /sys/bus/acpi/drivers/video/*/path"
in both kernels.

> And (c) I doubt that's going to fix the WARNING, because looking at drivers/
> acpi/video.c, the variable allow_duplicates is checked in exactly *ONE* place,
> which is *after* the printk:
> 
>         if (status == AE_ALREADY_EXISTS) {
>                 printk(KERN_WARNING FW_BUG
>                         "Duplicate ACPI video bus devices for the"
>                         " same VGA controller, please try module "
>                         "parameter \"video.allow_duplicates=1\""
>                         "if the current driver doesn't work.\n");
>                 if (!allow_duplicates)
>                         return -ENODEV;
>         }
> 
> So since the warning triggers before we see the printk(), setting the variable
> won't make a difference because we warn before we ever get into that if
> statement.
> 
> Now, maybe we need to be checking allow_duplicates earlier and/or in other
> places - but I'll let somebody who actually understands the code to decide taht. ;)



