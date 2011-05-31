Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756693Ab1EaOcA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 10:32:00 -0400
Received: from casper.infradead.org ([85.118.1.10]:50058 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755372Ab1EaOb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 10:31:59 -0400
Subject: Re: [PATCH] Fix corruption of CONFIG_X86_32 in 'make oldconfig'
From: David Woodhouse <dwmw2@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Ted Ts'o" <tytso@mit.edu>, x86@kernel.org, linux-kernel@vger.kernel.org,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Randy Dunlap <rdunlap@xenotime.net>
Date: Tue, 31 May 2011 15:31:49 +0100
In-Reply-To: <20110531135627.GB15598@elte.hu>
References: <1A4DB87D-9B32-44C0-B7C9-47A003CABD96@mit.edu>
	 <alpine.LFD.2.02.1105301955210.3164@localhost6.localdomain6>
	 <20110530195545.GG2890@dhcp-172-31-194-241.cam.corp.google.com>
	 <alpine.LFD.2.02.1105302103220.3164@localhost6.localdomain6>
	 <20110531075306.GB20798@elte.hu>
	 <1306832148.2029.484.camel@i7.infradead.org>
	 <20110531104106.GD24172@elte.hu>
	 <1306842211.2029.531.camel@i7.infradead.org>
	 <20110531124537.GA10249@elte.hu>
	 <1306849477.2029.570.camel@i7.infradead.org>
	 <20110531135627.GB15598@elte.hu>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.1 (3.0.1-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1306852312.2029.596.camel@i7.infradead.org>
Mime-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-31 at 15:56 +0200, Ingo Molnar wrote:
> The architecture *inside* the .config is not inherited automatically 
> but overriden by the host architecture, so due to this assymetry i 
> prefer to use explicit ARCH=xxx lines whenever i deal with configs.

Yes. That is why you *don't* need to run 'make ARCH=foo oldconfig' to
convert it to your native architecture; just 'make oldconfig' will work
fine.

I appreciate that you *like* to type it out anyway, and that's fine. Not
entirely sure how it's relevant to the rest of the discussion, except to
make you look a little sillier when you complain about the horrendous
amount of extra typing it is to use the new clean generic 'CONFIG_FOO='
interface instead of using the legacy ARCH values to set CONFIG_64BIT.

> > >     "I believe that this 'filtered randconfig' behaviour is now fairly much
> > >      the *only* use for the old 'ARCH=i386' and 'ARCH=x86_64'."
> > > 
> > > You are wrong again - it isnt, as me and others pointed it out.
> > 
> > Not *so* wrong that all those other use cases couldn't be addressed 
> > in the same, simple patch to allow CONFIG_FOO on the 'make' command 
> > line.
> 
> So "partially wrong" is not wrong? Indeed, if defined that way then i 
> agree that you must almost never be wrong ;-)

I said "this is fairly much the only remaining use", and some more use
cases were pointed out that were almost identical to the ones we'd
already discussed, and that were handled by the same patch.

Gosh, how wrong I was! You should shoot me now!

> Really, i have little interest in continuing the 'who was wrong' 
> angle of this discussion 

Very sensible. Hopefully we can agree that:

 - The only thing that ARCH=i386 and ARCH=x86_64 now do, since the
   merge into arch/x86, is override the setting of CONFIG_64BIT.

 - Until now, that override has also happened even when the user
   *didn't* pass any ARCH= on the command line. Instead of using the
   value of CONFIG_64BIT from the .config, it would automatically get
   changed to match the host!

 - This meant that people were forced to set ARCH= on the command line,
   just to make the build system honour the existing .config file.

 - The patch I submitted will make that override happen *only* when
   ARCH is explicitly specified as i386 or x86_64, which you use.
   It will *stop* it from happening when no ARCH= is specified. Yay!

 - The second patch I submitted will allow you to set *any* visible
   config symbol from the command line, which will be useful in many
   ways in addition to letting you set CONFIG_64BIT.

 - Now that you can set CONFIG_64BIT on the command line, the only
   remaining use of ARCH=i386 and ARCH=x86_64 is redundant.


Note that I've carefully avoided saying 'obsolete'. Only 'redundant',
which I'm sure you won't disagree with.

-- 
dwmw2

