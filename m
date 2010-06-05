Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933705Ab0FEQjK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 12:39:10 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46851 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933641Ab0FEQjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 12:39:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=N+28lVpf3mJqMbSxbzjp4gzc6mYN5NdPTZNy4qzk1ucLMi6AmEAKc/NsbbIOZDJeC5
         P12juKXepba7znSEP3A0ejt7hhEA8jOse+4l8M6pHViC8Q4jQg56wtClSkDDmM1aIlin
         HeSSYnYBhLUtlJeGqHwuTNgH4q2CWvsbzdhPI=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1006050734370.8175@i5.linux-foundation.org>
References: <20100603074548.GA12104@flint.arm.linux.org.uk>
	<alpine.LFD.2.00.1006030725420.8175@i5.linux-foundation.org>
	<20100603181010.GA25779@flint.arm.linux.org.uk>
	<alpine.LFD.2.00.1006031116360.8175@i5.linux-foundation.org>
	<20100603185333.GD25779@flint.arm.linux.org.uk>
	<alpine.LFD.2.00.1006031153420.8175@i5.linux-foundation.org>
	<1275593742.23384.48.camel@c-dwalke-linux.qualcomm.com>
	<20100603194559.GF25779@flint.arm.linux.org.uk>
	<alpine.LFD.2.00.1006031305310.8175@i5.linux-foundation.org>
	<alpine.LFD.2.00.1006031317410.8175@i5.linux-foundation.org>
	<20100603211707.GA6499@atomide.com>
	<AANLkTilSBWeYTV6YlLK4XdoBsSFSVvtJIRmJxAdNu92U@mail.gmail.com>
	<alpine.LFD.2.00.1006050734370.8175@i5.linux-foundation.org>
Date: Sat, 5 Jun 2010 19:39:07 +0300
Message-ID: <AANLkTinl_D5ZRaSru6B-Hq4ciAi4CTXhDtDG33AdWWW6@mail.gmail.com>
Subject: Re: ARM defconfig files
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tony Lindgren <tony@atomide.com>, Russell King <rmk@arm.linux.org.uk>,
       Daniel Walker <dwalker@codeaurora.org>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-arm-msm@vger.kernel.org, Vegard Nossum <vegard.nossum@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 5, 2010 at 5:39 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Sat, 5 Jun 2010, Felipe Contreras wrote:
>>
>> How about instead of using full defconfigs, we use minimal ones and
>> let the rest be determined with defaults.
>
> I wouldn't mind that either, but there needs to be some way to check that
> they _are_ minimal. Which is more complicated than even SAT, afaik.

I don't think so. The SAT should be able to come up with a minimal
config for 'CONFIG_MACH_OMAP3_BEAGLE=y', and then a minimal config for
whatever is in omap3_beagle_defconfig. The diff is either unnecessary,
or the Kconfig files are missing some 'default y if whatever'. You fix
the Kconfig files, and then use the resulting minimal config.

> So the reason I don't like the "minimal defconfig" notion is that a
> "regular defconfig" will work equally well, and lazy people will thus not
> bother to make it minimal (because it's work) and instead just pick the
> full config output.
>
> And we're all lazy. So gearing the process towards something that makes it
> easy for lazy cases to do the wrong thing is a bad thing.

Yes, that's why I lean toward the solution that creates an ideal
config with the minimal effort: SAT with a single
CONFIG_MACH_OMAP3_BEAGLE=y. Then you don't need defconfigs at all.

> We also don't have any way to "source" these config files from each other,
> so there's no way from within such a config file to say "use the basic
> omap3 defaults an then just add this on top". You can do it by
> concatenating several such files manually from the Makefile or whatever
> script, of course, but then you end up with the files themselves not
> actually describing what they do.

I don't really see the big need for hierarchical configs. When you do
'make ARCH=arm' you are already including all the arm stuff, so
there's no need for an ARM base config. Then you would need some
platform stuff like OMAP3, but if you do CONFIG_ARCH_OMAP3=y, and
there are proper 'default y if ARCH_OMAP3' in the Kconfigs, you don't
need any base config either. The rest of the stuff is truly specific
to the boards.

If there's a need to include other configs, I'm sure we can come with
markups to include them and have a parser script that generates the
.config.

> That's why I suggested the Kconfig format instead. It's the exact same
> idea, but it's a "before pre-processing" format that already supports
> including other files.

Yes, although I don't like the format (it looks clearly designed for
something else), it's another possibility. However, I don't think
"allnoconfig" makes sense because that would ignore the default hints
already present in Kconfig files.

-- 
Felipe Contreras
