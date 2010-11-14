Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410Ab0KNMRq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 07:17:46 -0500
Received: from mail.skyhub.de ([78.46.96.112]:57500 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755207Ab0KNMRn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 07:17:43 -0500
Date: Sun, 14 Nov 2010 13:17:38 +0100
From: Borislav Petkov <bp@alien8.de>
To: Jody Bruchon <jody@nctritech.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: ACPI+Inspiron 1545 = crash at xrstor_state()
Message-ID: <20101114121738.GA29522@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Jody Bruchon <jody@nctritech.com>, linux-kernel@vger.kernel.org
References: <4CDDD68D.4050506@nctritech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4CDDD68D.4050506@nctritech.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 12, 2010 at 07:06:37PM -0500, Jody Bruchon wrote:
> I previously reported a boot hang on an Inspiron 1545 laptop which
> is cured by disabling CONFIG_ACPI.  I didn't know about the
> "earlyprintk" boot option, and upon using it, I was able to see the
> actual crash.  Hopefully the following information will help.  Note
> that I have turned off SMP and APIC/LAPIC support, but the bug
> persists even with these disabled (I noticed a lot of APIC/IO-APIC
> code that is eliminated in early boot if they're disabled.)
> 
> The crash was in function xsave_init with EIP at
> xstate_enable_boot_cpu (the last normal message output before this
> was "Initializing CPU#0").  To narrow this down further, I edited
> xsave.c to be full of printk() messages for each called function.
> The last printk message indicates that the function in xsave.c which
> crashes out is:
> 
> xrstor_state(init_xstate_buf, -1);
> 
> The result is a general protection fault.  xrstor_state is just a
> tiny piece of asm code, and at this point I've reached the extent of
> my current capabilities, so I don't know where to go from here.  I
> can manually type out chunks of the crash info on request.  I'm
> clueless as to how the inclusion of ACPI causes this.
> 
> Please CC my email if you respond since I don't subscribe to LKML.
> Thanks in advance.

Ok, first of all, which kernel are you using? Second, send us your
.config. Then, please try booting the latest kernel (2.6.36) without
your printk's in it and with earlyprintk enabled on the kernel cmd line
and when the oops appears on the screen try to photograph it with a
digicam or similar and upload the pic somewhere. Before that, make sure
the pic is readable.

Thanks.

-- 
Regards/Gruss,
    Boris.
