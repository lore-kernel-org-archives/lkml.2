Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167Ab0DTJTq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 05:19:46 -0400
Received: from mx2.sophos.com ([195.166.81.53]:56357 "EHLO mx2.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754111Ab0DTJTo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 05:19:44 -0400
X-Greylist: delayed 524 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Apr 2010 05:19:43 EDT
From: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Organization: Sophos Plc
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 7/7] ondemand: Solve the big performance issue with ondemand during disk IO
Date: Tue, 20 Apr 2010 10:10:49 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.31.12-0.2-desktop; KDE/4.3.5; x86_64; ; )
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "peterz@infradead.org" <peterz@infradead.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "davej@redhat.com" <davej@redhat.com>,
       "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>
References: <20100418115949.7b743898@infradead.org> <201004191629.39339.tvrtko.ursulin@sophos.com> <20100419174702.635ddad1@infradead.org>
In-Reply-To: <20100419174702.635ddad1@infradead.org>
MIME-Version: 1.0
Message-ID: <201004201010.50725.tvrtko.ursulin@sophos.com>
X-MIMETrack: Itemize by SMTP Server on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 20/04/2010 10:10:50,
	Serialize by Router on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 20/04/2010 10:10:51,
	Serialize complete at 20/04/2010 10:10:51
X-TNEFEvaluated: 1
Content-Transfer-Encoding: 7BIT
Content-Type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 Apr 2010 01:47:02 Arjan van de Ven wrote:
> > > > One idea I had but a) never had time to implement it and b) was
> > > > not sure it would be accepted anyway, was to modify ondemand
> > > > governor to ramp up instantly, but slow down slowly (in a
> > > > configurable way).
> > >
> > > that's what ondemand does already.
> >
> > How and where in the code and how to enable that behaviour? From my
> > experiments frequency goes down to minimum as soon as load goes away.
> > What I was talking about is gradual lowering over a configurable
> > period. It is not power efficient, but it could be good for latency
> > in some workloads.
>
> it's not even good for that ;-(
>
> it's better then to stay high longer... at least on modern machines the
> inbetween states are pretty much either useless or actually energy
> hurting compared to the higher state.

Why do you think it is not good for latency to stay at higher frequency for
longer? I had a machine until recently with a relatively slow Turion64 which
had 800Mhz minimum and 1.8Ghz maximum frequency states. With ondemand governor
when web browsing for example, frequency would drop to 800Mhz as soon as
scrolling or such stopped, and then was pushed back up to max on user
interaction. Overall experience was sluggish, but when switching to
performance governor it was much much better. That is why I proposed to have a
gradual lowering as an option in on-demand. You said it already does that - I
ask are you sure? And also now you are saying it would not be good for latency
- above is an example when it clearly does help (a lot).

Would this idea of gradual lowering help for the "git grep" use case as well?
To me it sounds better than taking IO wait into account.  What happens with
your scheme with a pure IO load? Ok, you say power use is not determined by
frequency, fine, but it sounds slightly wrong to max the frequency on pure IO
wait. If frequency per se really does not waste power then gradual lowering
could both "git grep" and my web browsing latency use case, what do you think?

Tvrtko

Sophos Plc, The Pentagon, Abingdon Science Park, Abingdon, OX14 3YP, United Kingdom.
Company Reg No 2096520. VAT Reg No GB 348 3873 20.
