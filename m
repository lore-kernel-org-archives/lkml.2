Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354Ab1KILzh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 06:55:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2069 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751421Ab1KILzf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 06:55:35 -0500
Date: Wed, 9 Nov 2011 09:55:02 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Theodore Tso <tytso@mit.edu>,
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
Message-ID: <20111109115502.GA18207@ghostprotocols.net>
References: <4EB85969.2010108@codemonkey.ws> <12F471C8-2CF3-4CD7-B417-C8CC898669E6@mit.edu> <20111108093225.GB32533@elte.hu> <EDBAFB6F-4E3B-42B0-93E6-DF162B9859A6@mit.edu> <20111108125609.GA14272@ghostprotocols.net> <4EB9315A.10806@redhat.com> <20111108143228.GC14272@ghostprotocols.net> <4EB94D08.3010207@redhat.com> <20111109085120.GD11473@elte.hu> <4EBA5881.7080409@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EBA5881.7080409@redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Nov 09, 2011 at 11:40:01AM +0100, Gerd Hoffmann escreveu:
>   Hi,
> 
> > What we want to have is to have a set of distinctive colors - just 
> > two (background, foreground) colors are not enough - we also need 
> > colors to highlight certain information - we need 5-6 colors for the 
> > output to be maximally expressive. Is there a canonical way to handle 
> > that while still adapting to user preferences automatically by taking 
> > background/foreground color scheme of the xterm into account?
> 
> > I suspect to fix the worst of the fallout we could add some logic to 
> > detect low contrast combinations (too low color distance) and fall 
> > back to the foreground/background colors in that case.
> 
> As far I know it is pretty much impossible to figure the
> foreground/background colors of the terminal you are running on.  You

Glad to hear that, I thought I hadn't researched that much (I did). Hope
somebody appears and tell us how it is done :-)

> can try some guesswork based on $TERM (linux console usually has black
> background, xterm is white by default), but there will always be cases
> where it fails.
> 
> You can run without colors.  You can use bold to highlight things and
> reverse for the cursor.  Surely a bit limited and not as pretty as
> colored, but works for sure everywhere.
> 
> You can go for a linux-console style black background.  Pretty much any
> color is readable here, so you should have no problems at all to find
> the 5-6 colors you want.
> 
> You can go for a xterm-like light background, for example the lightgray
> used by older perf versions.  I like that background color, problem is
> with most colors the contrast is pretty low.  IMHO only red, blue and
> violet are readable on lightgray.  And black of course.
> 
> > Plus allowing full .perfconfig configurability of all the relevant 
> > colors, for those with special taste.
> 
> Sure.  Maybe also allow multiple color sections and pick them by $TERM
> or --colors switch, i.e. [colors "xterm"].

Its fully configurable as of now, what we need is a set of .perfconfigs
that show how people think its better, we try it, set it as the default,
leave the others in tools/perf/Documentation/perfconfig/color.examples.

- Arnaldo
