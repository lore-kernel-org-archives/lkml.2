Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758311Ab1EBPfK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 11:35:10 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48787 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756713Ab1EBPfH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 11:35:07 -0400
MIME-Version: 1.0
In-Reply-To: <20110502151542.GG2092@atomide.com>
References: <20110429070135.12522.35745.stgit@ponder> <20110429071548.12522.56929.stgit@ponder>
 <20110502151542.GG2092@atomide.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 2 May 2011 09:34:47 -0600
X-Google-Sender-Auth: TifbguwdJsxzdtUqV1aMfLVKsPg
Message-ID: <BANLkTikue6jMUcQMv9GD4cZ=o5EEW7QDqQ@mail.gmail.com>
Subject: Re: [PATCH v5 4/8] arm/dt: probe for platforms via the device tree
To: Tony Lindgren <tony@atomide.com>
Cc: devicetree-discuss@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 2, 2011 at 9:15 AM, Tony Lindgren <tony@atomide.com> wrote:
> * Grant Likely <grant.likely@secretlab.ca> [110429 00:13]:
>> +
>> +/**
>> + * setup_machine_fdt - Machine setup when an dtb was passed to the kernel
>> + * @dt_phys: physical address of dt blob
>> + *
>> + * If a dtb was passed to the kernel in r2, then use it to choose the
>> + * correct machine_desc and to setup the system.
>> + */
>> +struct machine_desc * __init setup_machine_fdt(unsigned int dt_phys)
>> +{
> ...
>
>> +
>> +     /* Retrieve various information from the /chosen node */
>> +     of_scan_flat_dt(early_init_dt_scan_chosen, boot_command_line);
>
> Just to make sure we're considering properly what this change means..
>
> Does this patch require using CONFIG_CMDLINE_FORCE for older bootloaders
> with the device tree append patch?

With the current patch?  Yes, but there is a follow-on patch that was
posted a while ago[1] that will copy ATAG data into the device tree in
the bootloader.  I've not been pushing to include that change since it
adds a lot of code to the wrapper and I'm not sure how deeply we want
to support that use case.  Basically I want to have a better idea what
the supported use cases are before pushing something like that.

Adding a default command line to the .dts file instead of using
CONFIG_CMDLINE_FORCE also works.

[1] http://lists.ozlabs.org/pipermail/devicetree-discuss/2011-March/004652.html

> Or should we still somehow get ATAG_CMDLINE let's say in the uncompress
> code and use that if nothing else is found?
>
> Otherwise booting old boards with the same kernel will be painful as
> it requires a kernel recompile to set the cmdline..
>
> Also, not counting the separate DT append issues, I got things booting
> with these patches (and the dts files) on omaps. So for patches 1 - 5,
> and patch 8:
>
> Tested-by: Tony Lindgren <tony@atomide.com>
>
> I don't have versatile or tegra, so can't test those :)

Awesome, thanks.

g.

>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
