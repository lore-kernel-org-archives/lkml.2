Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757897Ab0JZTVs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 15:21:48 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:34361 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755976Ab0JZTVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 15:21:47 -0400
Subject: Re: Clocksource tsc unstable (delta = -8589361717 ns) in current
 git
From: john stultz <johnstul@us.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
        Borislav Petkov <bp@amd64.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>,
        Ingo Molnar <mingo@elte.hu>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
In-Reply-To: <alpine.LFD.2.00.1010261747250.3115@localhost6.localdomain6>
References: <20101026112052.GA1672@arch.trippelsdorf.de>
	 <20101026131843.GC17852@aftab> <20101026135808.GB1672@arch.trippelsdorf.de>
	 <alpine.LFD.2.00.1010261747250.3115@localhost6.localdomain6>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Tue, 26 Oct 2010 12:18:56 -0700
Message-ID: <1288120736.2645.9.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-26 at 17:48 +0200, Thomas Gleixner wrote:
> On Tue, 26 Oct 2010, Markus Trippelsdorf wrote:
> > On Tue, Oct 26, 2010 at 03:18:43PM +0200, Borislav Petkov wrote:
> > > otherwise, I don't see anything strange in your dmesg. Unless tglx has a
> > > better idea, I'd ask you to bisect it. 5618 changesets shouldn't be that
> > > much but I don't know, if the issue appears every several hours it could
> > > still be tedious.
> > 
> > That would be a several week long process, as the issue appears ~ every
> > 2 days here on this machine running 24/7.
> 
> There is only a single commit in that area post 2.6.36:
> 
>       8af3c153baf95374eff20a37f00c59a295b52756 
> 
> But I have a hard time how this should make this happen. John ?

Yea, that one doesn't look connected to me.

There have been a few cases that I've seen where we can get false
positives for bad TSCs due to the watchdog clocksource having problems
(or the clocksource watchdog thread getting delayed for such a long time
the watchdog clocksource wraps and we then can't validly compare the two
- although this would be hard to trigger with non-rt kernels).

>From your dmesg, I'd guess the hpet is the watchdog clocksource, so I'd
be on the lookout for hpet related changes. 

Maybe does reverting 995bd3bb5c78f3ff71339803c0b8337ed36d64fb hide the
issue?

thanks
-john



