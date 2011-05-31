Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755991Ab1EaN4u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 09:56:50 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59826 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752285Ab1EaN4r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 09:56:47 -0400
Date: Tue, 31 May 2011 15:56:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Woodhouse <dwmw2@infradead.org>
Cc: "Ted Ts'o" <tytso@mit.edu>, x86@kernel.org, linux-kernel@vger.kernel.org,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH] Fix corruption of CONFIG_X86_32 in 'make oldconfig'
Message-ID: <20110531135627.GB15598@elte.hu>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306849477.2029.570.camel@i7.infradead.org>
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


* David Woodhouse <dwmw2@infradead.org> wrote:

> On Tue, 2011-05-31 at 14:45 +0200, Ingo Molnar wrote:
> > * David Woodhouse <dwmw2@infradead.org> wrote:
> > 
> > > > Also, i prefer to type out the architecture due to:
> > > >  |                                              ...So if i get an ARM
> > > >  |  bugreport that gives me the appearance of a core kernel bug i will
> > > >  |  often start by converting that to an x86 .config via 'make
> > > >  |  ARCH=x86_64 oldconfig'. ]
> > > 
> > > So first you point out that it's automatic, and then you still specify
> > > it manually?
> > 
> > Currently it's not automatic so i prefer to type it out.
> 
> No, you were right the first time. It *is* automatic.

The architecture *inside* the .config is not inherited automatically 
but overriden by the host architecture, so due to this assymetry i 
prefer to use explicit ARCH=xxx lines whenever i deal with configs.

> >     "I believe that this 'filtered randconfig' behaviour is now fairly much
> >      the *only* use for the old 'ARCH=i386' and 'ARCH=x86_64'."
> > 
> > You are wrong again - it isnt, as me and others pointed it out.
> 
> Not *so* wrong that all those other use cases couldn't be addressed 
> in the same, simple patch to allow CONFIG_FOO on the 'make' command 
> line.

So "partially wrong" is not wrong? Indeed, if defined that way then i 
agree that you must almost never be wrong ;-)

Really, i have little interest in continuing the 'who was wrong' 
angle of this discussion - i think people can read and i think people 
have made it rather clear what they are using and why, and what 
they'd like to see continue work, which requirements i'll try to 
apply to related patches you send. The last version of your patch 
looked good at first sight, except the changelog.

Thanks,

	Ingo
