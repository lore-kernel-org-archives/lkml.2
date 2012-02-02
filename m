Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756272Ab2BBUYd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 15:24:33 -0500
Received: from mail.skyhub.de ([78.46.96.112]:47561 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753218Ab2BBUYc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 15:24:32 -0500
Date: Thu, 2 Feb 2012 21:24:28 +0100
From: Borislav Petkov <bp@alien8.de>
To: Nick Bowler <nbowler@elliptictech.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH] MCE, AMD: Select SMP explicitly
Message-ID: <20120202202427.GA2234@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Nick Bowler <nbowler@elliptictech.com>,
	"H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
	Thomas Gleixner <tglx@linutronix.de>,
	LKML <linux-kernel@vger.kernel.org>,
	Randy Dunlap <rdunlap@xenotime.net>
References: <1328209817-18913-1-git-send-email-bp@alien8.de>
 <20120202193702.GA9502@elliptictech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120202193702.GA9502@elliptictech.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 02, 2012 at 02:37:02PM -0500, Nick Bowler wrote:
> Hi,
> 
> On 2012-02-02 20:10 +0100, Borislav Petkov wrote:
> > Randy Dunlap reported that building randconfigs which do not select
> > CONFIG_SMP cause the following link error:
> > 
> > mce_amd.c:(.cpuinit.text+0x4723): undefined reference to `cpu_llc_shared_map'
> > 
> > Fix it.
> > 
> > Acked-by: Randy Dunlap <rdunlap@xenotime.net>
> > Link: http://lkml.kernel.org/r/4F298A6C.6010101@xenotime.net
> > Signed-off-by: Borislav Petkov <bp@alien8.de>
> [...]
> >  config X86_MCE_AMD
> >  	def_bool y
> >  	prompt "AMD MCE features"
> > -	depends on X86_MCE && X86_LOCAL_APIC
> > +	depends on X86_MCE && X86_LOCAL_APIC && SMP
> 
> Is this feature truly irrelevant on UP systems?  I ask because I've
> always enabled this option on my UP AMD systems in the past...

No, you're right. Thanks for the suggestion. Scratch that version, I'll
think of a better fix.

Thanks.

-- 
Regards/Gruss,
Boris.
