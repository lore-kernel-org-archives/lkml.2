Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240Ab1KIIxE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 03:53:04 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59662 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751422Ab1KIIxB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 03:53:01 -0500
Date: Wed, 9 Nov 2011 09:51:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, Theodore Tso <tytso@mit.edu>,
        Anthony Liguori <anthony@codemonkey.ws>,
        Pekka Enberg <penberg@kernel.org>, Vince Weaver <vince@deater.net>,
        Avi Kivity <avi@redhat.com>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        qemu-devel Developers <qemu-devel@nongnu.org>,
        Alexander Graf <agraf@suse.de>, Blue Swirl <blauwirbel@gmail.com>,
        =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [F.A.Q.] the advantages of a shared tool/kernel Git
	repository, tools/perf/ and tools/kvm/
Message-ID: <20111109085120.GD11473@elte.hu>
References: <20111107203255.GF24234@thunk.org>
 <CAOJsxLEKx5M5L_N42pQpo2hcNhseQKhUo6CXAyQHesJRWFASKQ@mail.gmail.com>
 <4EB85969.2010108@codemonkey.ws>
 <12F471C8-2CF3-4CD7-B417-C8CC898669E6@mit.edu>
 <20111108093225.GB32533@elte.hu>
 <EDBAFB6F-4E3B-42B0-93E6-DF162B9859A6@mit.edu>
 <20111108125609.GA14272@ghostprotocols.net>
 <4EB9315A.10806@redhat.com>
 <20111108143228.GC14272@ghostprotocols.net>
 <4EB94D08.3010207@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EB94D08.3010207@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
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


* Gerd Hoffmann <kraxel@redhat.com> wrote:

> > For reference, the default set of colors now is (from
> > tools/perf/util/ui/browser.c):
> > 
> > static struct ui_browser__colorset {
> >         const char *name, *fg, *bg;
> >         int colorset;
> > } ui_browser__colorsets[] = {
> >         {
> >                 .colorset = HE_COLORSET_TOP,
> >                 .name     = "top",
> >                 .fg       = "red",
> >                 .bg       = "default",
> 
> Bad idea IMO.  Setting only one of foreground+background gives 
> pretty much unpredictable results.  My xterms have different 
> background colors, the ones with a root shell happen to have a 
> (dark) red background. Which results in red-on-dark-red text.  Not 
> good.
> 
> I'd strongly suggest to either set both background and foreground 
> to default or to set both to a specific color.  When doing the 
> latter make sure the colors have enougth contrast so they are 
> readable.

Indeed.

What we want to have is to have a set of distinctive colors - just 
two (background, foreground) colors are not enough - we also need 
colors to highlight certain information - we need 5-6 colors for the 
output to be maximally expressive. Is there a canonical way to handle 
that while still adapting to user preferences automatically by taking 
background/foreground color scheme of the xterm into account?

I suspect to fix the worst of the fallout we could add some logic to 
detect low contrast combinations (too low color distance) and fall 
back to the foreground/background colors in that case.

Plus allowing full .perfconfig configurability of all the relevant 
colors, for those with special taste.

Thanks,

	Ingo
