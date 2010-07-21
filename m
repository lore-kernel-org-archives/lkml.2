Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932328Ab0GUQaF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 12:30:05 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:37391 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758362Ab0GUQaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 12:30:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=DzL3Ve633fIqv39mIeHBMcp9Jsx6LpOypbgx+G+zy8pYWOZMtGSKyOTprxNb/11Cnq
         xDXZmwONn72B84kvW+3iIYMd2/XO1V7+/kZ7CLWxcjs5XuefmhqrynixVX0bOU2TNUHU
         d9IYe1bJy0qH6J6jGf2zinibf44becOvYV0Sk=
Date: Wed, 21 Jul 2010 20:29:56 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Robert Richter <robert.richter@amd.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/10] x86, xsave: some code cleanups and reworks
Message-ID: <20100721162956.GC8009@lenovo>
References: <1279651857-24639-1-git-send-email-robert.richter@amd.com> <20100720192717.GC6227@lenovo> <20100720194606.GO26154@erda.amd.com> <20100720200729.GD6227@lenovo> <20100720201740.GE6227@lenovo> <20100721161654.GR26154@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100721161654.GR26154@erda.amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 21, 2010 at 06:16:54PM +0200, Robert Richter wrote:
> On 20.07.10 16:17:40, Cyrill Gorcunov wrote:
> 
> > note the snippet
> > 
> > 		if (cpu == boot_cpu_id)
> > 			switch_to_new_gdt(cpu);
> > 
> > but cycle of assignment is done over all possible cpus so
> > smp_processor_id will be = 0 for BP but definitely it's
> > confusing and better to check for BP via explicit cpu == boot_cpu_id
> > I think. Though I might be missing something.
> 
> This in smpboot.c makes it clear:
> 
> void __cpuinit smp_store_cpu_info(int id)
> {
>         struct cpuinfo_x86 *c = &cpu_data(id);
> 
>         copy_cpuinfo_x86(c, &boot_cpu_data);
>         c->cpu_index = id;
>         if (id != 0)
>                 identify_secondary_cpu(c);
> }
> 
> So boot cpu id is always 0.

yeah, thanks!

> 
> Also note, as Hans Peter already pointed out, this for CONFIG_SMP:
> 
>  &cpu_data(0) != &boot_cpu_data
> 
> The data in boot_cpu_data is (partly) already available after
> early_cpu_init(). It is later copied to the &cpu_data() structures. So
> boot_cpu_data should be used for init code.
> 
> Also, to make the test obviously, instead of testing (cpu ==
> boot_cpu_id) I rather tend to use an is_boot_cpu() macro as you
> suggested in your earlier mail.
> 
> -Robert
> 
> -- 
> Advanced Micro Devices, Inc.
> Operating System Research Center
> 

ok, thanks Robert!

	-- Cyrill
