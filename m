Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753068Ab1EYSYd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 14:24:33 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54853 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750757Ab1EYSYb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 14:24:31 -0400
Date: Wed, 25 May 2011 20:24:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@linux.intel.com>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH 1/3] x86, intel: Output microcode revision
Message-ID: <20110525182405.GA17864@elte.hu>
References: <1306278210-18285-1-git-send-email-andi@firstfloor.org>
 <20110525070604.GE429@elte.hu>
 <20110525160656.GB25225@khazad-dum.debian.net>
 <20110525165803.GB14958@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110525165803.GB14958@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <ak@linux.intel.com> wrote:

> > > This can happen if for example the BIOS somehow does not apply the right 
> > > microcode to all CPUs. It can also happen if physically different microcode 
> > > version CPUs are mixed. In theory people can mix steppings as well.
> > 
> > In PRACTICE people WILL mix steppings as well.
> 
> Yes exactly. I used to have a system with one P3 supporting FXSAVE
> and other not :-) I had to fix the kernel back then to support this.
> The system worked perfectly fine after the kernel was fixed.

I'm not concerned about the cases where it works fine - i'm concerned 
about cases where it's not fine.

Many years ago i had an old P3 system where i mixed steppings and it 
was not stable, it would crash after i have put some load on the 
system.

> So the check proposed is a bad idea. It would trigger on real boxes 
> which don't have any obvious problems.

You are quite naive about mixed stepping i have to say - mixing 
steppings was always a risk and can come with various problems:

   http://mysite.verizon.net/pchardwarelinks/mixed.htm

 Mixing processor steppings (revisions) in a dual environment doesn't 
 always work as well as it should. As a rule of thumb, one stepping 
 difference between two CPUs is generally acceptable. Two steppings is 
 pushing it. Note that some revisions of some operating systems may be 
 more forgiving than others (like WinNT) concerning mixed steppings. 
 The motherboard manufacturer can also give you information about 
 which mixed steppings (if any) are compatible with the motherboard. 
 It's always best to buy matched pairs or to find another chip with 
 the same S-Spec number. Although in many cases, finding an identical 
 chip is quite difficult.

   http://www.intel.com/support/motherboards/server/sb/cs-022150.htm

 Mixed steppings of processors are only supported with the following 
 paired combinations of A1 and A2 steppings of the Intel® Itanium® 2 
 Processor with up to 9 MB L3 cache, identified by the package S-Spec 
 numbers (see the Intel® Itanium® 2 Processor Identification and 
 Package Information table for details):

    * SL7SD and SL8CY
    * SL7ED and SL8CX
    * SL7EC and SL8CW
    * SL7EB and SL8CV
    * SL87H and SL8CU
    * SL7EF and SL8CZ 

 Intel® Server Platform SR870BH2 and Intel® Server Platform SR870BN4 
 fully supports mixing A1 and A2 stepping processors

   http://h20000.www2.hp.com/bizsupport/TechSupport/Document.jsp?lang=en&cc=us&objectID=c01209579&jumpid=reg_R1002_USEN

 While HP ProLiant servers support mixed AMD Opteron processor 
 steppings within the same letter step, HP is recommending that the 
 processor with the lowest stepping be installed in the Boot Strap 
 Processor (BSP) slot and that the System ROM be updated to the latest 
 available version. For example, an AMD Opteron 800 with Stepping C0 
 can be mixed with an AMD Opteron 800 with Stepping CG .

So displaying a non-fatal 'info' message about it would in fact be 
rather wise. Nothing scary, but we'd like to be informed.

Thanks,

	Ingo
