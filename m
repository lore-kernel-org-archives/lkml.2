Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723Ab1B1PKU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 10:10:20 -0500
Received: from adelie.canonical.com ([91.189.90.139]:50860 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754545Ab1B1PKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 10:10:16 -0500
Date: Mon, 28 Feb 2011 09:10:08 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Burt Triplett <burt@pbjtriplett.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Arjan van de Ven <arjan@infradead.org>,
        Venkatesh Pallipadi <venki@google.com>, Len Brown <lenb@kernel.org>
Subject: Re: Performance/resume issues on Toshiba NB305
Message-ID: <20110228151008.GA29142@thinkpad-t410>
Mail-Followup-To: Burt Triplett <burt@pbjtriplett.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Arjan van de Ven <arjan@infradead.org>,
	Venkatesh Pallipadi <venki@google.com>, Len Brown <lenb@kernel.org>
References: <20110225164239.GA24686@thinkpad-t410>
 <alpine.LFD.2.00.1102252108190.2701@localhost6.localdomain6>
 <20110225212142.GC24686@thinkpad-t410>
 <alpine.LFD.2.00.1102252231200.2701@localhost6.localdomain6>
 <20110225222900.GD24686@thinkpad-t410>
 <alpine.LFD.2.00.1102252330290.2701@localhost6.localdomain6>
 <4D689681.1030301@pbjtriplett.org>
 <20110226150032.GA2053@thinkpad-t410>
 <4D6AB159.7010809@pbjtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D6AB159.7010809@pbjtriplett.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 27, 2011 at 12:17:29PM -0800, Burt Triplett wrote:
> >The new release detects the Atom processor okay, but in bits-327 the
> >system resets during the SMI frequency/latency test, whereas it didn't
> >with bits-316.
> 
> The SMI Frequency and Latency test should be fixed in bits-329.

Yes, it's fixed now, thanks.

> To get more information on how the MSRs differ between CPUs, you can
> turn on verbose mode.  Go to the GRUB command line by hitting 'c',
> and enter "test_options -v 2".  Then hit Esc to go back to the menu,
> and re-run the MSR consistency check.  It will now show you the
> value of the MSR on each CPU.
> 
> MSR 0x1a0 is IA32_MISC_ENABLE, and generally any inconsistency in
> that MSR represents a BIOS bug: it didn't enable features
> identically on all CPUs.  Once you see which bits differ, you can
> look at the Intel Software Developer's Manual (specifically volume
> 3B) to find out what those bits mean and which specific features the
> BIOS inconsistently enabled.

 (MSR 0x1a0 consistent) FAIL (2 different values)
 1 CPUs 0x0000000364950089: 0x0
 1 CPUs 0x0000000364950081: 0x1

 Bit 3: Automatic Thermal Control Circuit Enable

I'm not sure of the impact of this, since there's really only one core
in the CPU. One of the others differs has bit 3 inconsistent as well. On
the third bit 3 is the same but bit 0 (fast-strings enable) is
inconsistent.

The three machines have further differences in this MSR, but all in bits
documented as being reserved.

> MSR 0x199 is IA32_PERF_CTL.  A difference in that MSR usually means
> the BIOS left CPUs in different P-states when booting, which it
> really shouldn't do.  Again, you can decode the result with the
> Intel SDM.

 (MSR 0x199 consistent): FAIL (2 different values)
 1 CPUs 0x0000000000000a1f: 0x0
 1 CPUs 0x0000000000000613: 0x1

So yes, the cores are in different P-states. The results from the other
machines are similar, but the values for CPU1 are slightly different for
each machine. CPU1 has the same value on all three machines.

> Looking into MSR 0x39.

Yeah, this one isn't in the SDM at all. Here are the values I got:

 (MSR 0x39 consistent): FAIL (2 different values)
 1 CPUs 0x0000000000000000: 0x0
 1 CPUs 0x0000000000000001: 0x1

Values are identical for all three machines.

I'm not really getting the idea that any of these is contributing to the
problems I'm seeing with this machine though.

Thanks,
Seth

