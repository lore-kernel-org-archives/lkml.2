Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753770Ab0D1JDV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 05:03:21 -0400
Received: from mx5.sophos.com ([213.31.172.35]:60017 "EHLO mx5.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751286Ab0D1JDT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 05:03:19 -0400
X-Greylist: delayed 368 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Apr 2010 05:03:18 EDT
From: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Organization: Sophos Plc
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 7/7] ondemand: Solve the big performance issue with ondemand during disk IO
Date: Wed, 28 Apr 2010 09:57:07 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33.2; KDE/4.3.5; x86_64; ; )
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "peterz@infradead.org" <peterz@infradead.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "davej@redhat.com" <davej@redhat.com>,
       "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>
References: <20100418115949.7b743898@infradead.org> <201004201010.50725.tvrtko.ursulin@sophos.com> <20100420040207.1be74046@infradead.org>
In-Reply-To: <20100420040207.1be74046@infradead.org>
MIME-Version: 1.0
Message-ID: <201004280957.07455.tvrtko.ursulin@sophos.com>
X-MIMETrack: Itemize by SMTP Server on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 28/04/2010 09:57:07,
	Serialize by Router on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 28/04/2010 09:57:08,
	Serialize complete at 28/04/2010 09:57:08
X-TNEFEvaluated: 1
Content-Transfer-Encoding: 7BIT
Content-Type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 Apr 2010 12:02:07 Arjan van de Ven wrote:
> On Tue, 20 Apr 2010 10:10:49 +0100
>
> Tvrtko Ursulin <tvrtko.ursulin@sophos.com> wrote:
> > > it's better then to stay high longer... at least on modern machines
> > > the inbetween states are pretty much either useless or actually
> > > energy hurting compared to the higher state.
> >
> > Why do you think it is not good for latency to stay at higher
> > frequency for longer?
>
> oh it will be.

Well you said that "it's not even good for that ;-(" when I said that it may
be good for latency...

> > governor it was much much better. That is why I proposed to have a
> > gradual lowering as an option in on-demand. You said it already does
> > that - I ask are you sure? And also now you are saying it would not
> > be good for latency
> > - above is an example when it clearly does help (a lot).
>
> but the *gradual* lowering just does not make sense.
> might as well just stay at the highest frequency for the duration for
> which you do the gradual lowering, it's more efficient for power on most
> modern machines.
>
> The problem is if you do this gradual thing for long enough to help
> you on desktop loads, or the stay-high thing, on server workloads the
> power efficiency will completely and utterly tank. Been there tried
> that ;-)

Maybe it does not make sense for energy efficiency but it does for latency, I
think we have now agreed on that so it would be a nice knob to have. If I had
some time I would implement it if for nothing then to spice up this thread. :)

I also like Mike Chan's idea of minimum_full_io_speed_frequency parameter, in
addition to my gradual lowering.

> frankly, you're starting to touch at the more fundamental issues with
> ondemand. I'm not trying to solve that in this small patch, they really
> can only be solved in a complete redesign. While I'm doing such a
> redesign, I was asked to at least fix this particular gap urgently.
> Solving all of ondemand's issues needs a complete rethink of the core
> assumptions it makes (which are not correct anymore nowadays).

I understand that, although you gave no detail on how you designed this new
ondemand. Problem I have is that to me this workaround is quite ugly. If you
have to do it please add minimum_full_io_speed_frequency knob and also make it
default to current behaviour (no increase on iowait).

Tvrtko


Sophos Plc, The Pentagon, Abingdon Science Park, Abingdon, OX14 3YP, United Kingdom.
Company Reg No 2096520. VAT Reg No GB 348 3873 20.
