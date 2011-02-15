Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900Ab1BOOQS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 09:16:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37791 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751089Ab1BOOQQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 09:16:16 -0500
Date: Tue, 15 Feb 2011 16:13:26 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Henrik Kretzschmar <henne@nachtwindheim.de>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@zytor.com, x86@kernel.org, tj@kernel.org,
        yinghai@kernel.org, ak@linux.intel.com, robert.richter@amd.com,
        weidong.han@intel.com
Subject: Re: [PATCH 2/6] x86: ifdef enable_IR_x2apic() out
Message-ID: <20110215141326.GZ14984@redhat.com>
References: <1297677612-12405-1-git-send-email-henne@nachtwindheim.de>
 <1297677612-12405-2-git-send-email-henne@nachtwindheim.de>
 <20110214110340.GC7140@elte.hu>
 <4D5A8406.3030703@nachtwindheim.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D5A8406.3030703@nachtwindheim.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 15, 2011 at 02:47:50PM +0100, Henrik Kretzschmar wrote:
> Am 14.02.2011 12:03, schrieb Ingo Molnar:
> > 
> > 
> > * Henrik Kretzschmar <henne@nachtwindheim.de> wrote:
> > 
> >> +#ifdef CONFIG_X86_64
> >>  extern void enable_IR_x2apic(void);
> >> +#endif
> > 
> > Cannot we use the CONFIG_X86_X2APIC Kconfig switch here, instead of CONFIG_X86_64?
> > 
> > enable_IR_x2apic() is not a 64-bit CPU feature.
> > 
> > Thanks,
> > 
> > 	Ingo
> > 
> > 
> 
> Thats what I had liked also.
> 
> At the time you moved the apic code from x86/kernel it was exactly that way.
> But after that, in commit 937582382c71b75b29fbb92615629494e1a05ac0, it was explicitely moved out of
> CONFIG_X86_X2APIC, which made that function also compile on 32bit machines, even if its not used there.
> 
> Also commit ce69a784504222c3ab6f1b3c357d09ec5772127a enabled the x2apic without interrupt remapping,
> which means that CONFIG_X86_X2APIC depends on CONFIG_INTR_REMAP has been bypassed and so Kconfig is
> broken/not representing what happens to the code.
> 
Intel asked to leave Kconfig dependency in place.

> So since I dont have an x2apic and therefore cannot test changes,
> I decided for CONFIG_X86_64 without touching code which seems to work.
> 
> I wish I could offer something better here.
> 
> Greets,
> Henrik Kretzschmar
> 
> 
> 

--
			Gleb.
