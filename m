Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966193Ab0GPUha (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 16:37:30 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:41917 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759239Ab0GPUh2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 16:37:28 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1007161629270.10598@xanadu.home>
References: <20100713230352.6781.18644.stgit@angua> <1279296221.17878.66.camel@e102109-lin.cambridge.arm.com> 
	<AANLkTinyFBTKYaryFANYheTuP-biJUws2x01NRNZPb4M@mail.gmail.com> 
	<alpine.LFD.2.00.1007161406120.10598@xanadu.home> <20100716183028.GB26854@n2100.arm.linux.org.uk> 
	<alpine.LFD.2.00.1007161439240.10598@xanadu.home> <AANLkTikqHnyFVJF0Pzwy2xtKeNSXYAPFdPkAkLiXK8Ls@mail.gmail.com> 
	<1279310976.18579.8.camel@e102109-lin.cambridge.arm.com> <AANLkTimKpmZaGRYfYs8HGDz-_VG8ePXN6bZvl2-YcNdR@mail.gmail.com> 
	<alpine.LFD.2.00.1007161629270.10598@xanadu.home>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 16 Jul 2010 14:37:07 -0600
X-Google-Sender-Auth: i-FhfDdUMCAjeNkcL1oAYvRNB7U
Message-ID: <AANLkTinTBh2axb6UKETVoVJvOyAf_HTsTAU84yeAjUTR@mail.gmail.com>
Subject: Re: [RFC PATCH] Kconfig: Enable Kconfig fragments to be used for 
	defconfig
To: Nicolas Pitre <nico@fluxnic.net>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Daniel Walker <dwalker@codeaurora.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kbuild@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        lkml <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 16, 2010 at 2:29 PM, Nicolas Pitre <nico@fluxnic.net> wrote:
> On Fri, 16 Jul 2010, Grant Likely wrote:
>
>> On Fri, Jul 16, 2010 at 2:09 PM, Catalin Marinas
>> <catalin.marinas@arm.com> wrote:
>> > On Fri, 2010-07-16 at 19:46 +0100, Linus Torvalds wrote:
>> >> On Fri, Jul 16, 2010 at 11:40 AM, Nicolas Pitre <nico@fluxnic.net> wrote:
>> >> >
>> >> > DOH.
>> >>
>> >> Well, it's possible that the correct approach is a mixture.
>> >>
>> >> Automatically do the trivial cases (recursive selects, dependencies
>> >> that are simple or of the form "x && y" etc), and warn about the cases
>> >> that aren't trivial (where "not trivial" may not necessarily be about
>> >> fundamentally ambiguous ones, but just "complex enough that I won't
>> >> even try").
>> >
>> > There is still a risk with this approach when the Kconfig isn't entirely
>> > correct. For example, on ARM we have (I pushed a patch already):
>> >
>> > config CPU_32v6K
>> >        depends on CPU_V6
>> >
>> > config CPU_V7
>> >        select CPU_32v6K
>> >
>> > In this simple approach, we end up selecting CPU_V6 when we only need
>> > CPU_V7. There other places like this in the kernel.
>> >
>> > Of course, kbuild could still warn but if people rely on this feature to
>> > select options automatically I suspect they would ignore the warnings.
>>
>> In my first patch, I made Kconfig problems errors instead of warnings.
>>  That would prevent people from ignoring them.
>
> ACK.

It would also flush out any current Kconfig dependency issues.

g.
