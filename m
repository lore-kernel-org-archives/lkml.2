Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754400Ab2LEVMv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 16:12:51 -0500
Received: from mail.skyhub.de ([78.46.96.112]:43987 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753133Ab2LEVMt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 16:12:49 -0500
Date: Wed, 5 Dec 2012 22:12:45 +0100
From: Borislav Petkov <bp@alien8.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andreas Mohr <andi@lisas.de>, linux-kernel@vger.kernel.org,
        Li Shaohua <shaohua.li@intel.com>, linux-acpi@vger.kernel.org
Subject: Re: Look Ma, da kernel is b0rken
Message-ID: <20121205211244.GA6239@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Mohr <andi@lisas.de>, linux-kernel@vger.kernel.org,
	Li Shaohua <shaohua.li@intel.com>, linux-acpi@vger.kernel.org
References: <20121205070901.GA12123@rhlx01.hs-esslingen.de>
 <20121205142935.GA12119@liondog.tnic>
 <20121205152756.5afec12c@pyramind.ukuu.org.uk>
 <20121205153121.GA28556@liondog.tnic>
 <20121205154749.2af4ef36@pyramind.ukuu.org.uk>
 <20121206075721.18c0c05aa767b330f47d77eb@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20121206075721.18c0c05aa767b330f47d77eb@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 06, 2012 at 07:57:21AM +1100, Stephen Rothwell wrote:
> On Wed, 5 Dec 2012 15:47:49 +0000 Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > And yes btw we should turn this option on in -next, and get these sort of
> > things out of the tree for good. More importantly it'll mean anyone
> > adding another one gets a whine on the spot.
> 
> While I appreciate your confidence, I don't notice quite a few new
> warnings (because there are so many of them already :-().  Is there some
> reason to not turn this on in our "normal" builds?  Does it produce many
> false positives?

Yes, it produces a huge number of warnings which need weeding out (some
of them are false positives and some of them are simply unfixable due to
design decisions in the kernel, etc, etc):

$ make W=123 drivers/pnp/pnpacpi/core.o 2> w.log
make[1]: Nothing to be done for `all'.
  CHK     include/generated/uapi/linux/version.h
  CHK     include/generated/utsrelease.h
make[1]: Nothing to be done for `relocs'.
  CALL    scripts/checksyscalls.sh
  CC      drivers/pnp/pnpacpi/core.o
$ wc w.log
  2305  11202 168011 w.log

This is 2305 lines only for one compilation unit.

So if one enables all additional warning levels (this is what "W=123"
does) your build logs will be huge.

> What compiler version is required?

Works on all compilers by checking for supported -W options - see
scripts/Makefile.build.

> I also currently don't carry patches that only ever appear in
> linux-next (well, not intentionally anyway). I assume it would require
> a patch to the Makefile(s) to turn this on.

See above.

So ideally it would be if someone would build with "W=123" and track all
new warnings appearing with each new patch in linux-next and nag the
patch author to fix it before it hits mainline. This would require a
moderate level of scripting and experimenting though. The advantage is
that with something like that we'll be able to use all -W code checking
methods implemented gcc on our code and let the compiler possibly catch
more stuff.

We simply need someone not lazy enough to write that tracking and
nagging bit :).

Thanks.

-- 
Regards/Gruss,
    Boris.
