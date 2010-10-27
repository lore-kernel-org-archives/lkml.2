Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758944Ab0J0O0b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 10:26:31 -0400
Received: from smtp-out-231.synserver.de ([212.40.180.231]:1143 "HELO
	smtp-out-228.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1755177Ab0J0O03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 10:26:29 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: markus@trippelsdorf.de
X-SynServer-PPID: 1103
Date: Wed, 27 Oct 2010 16:26:22 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: john stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@amd64.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>,
        Ingo Molnar <mingo@elte.hu>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: Clocksource tsc unstable (delta = -8589361717 ns) in current
 git
Message-ID: <20101027142622.GA1555@arch.trippelsdorf.de>
References: <20101026112052.GA1672@arch.trippelsdorf.de>
 <20101026131843.GC17852@aftab>
 <20101026135808.GB1672@arch.trippelsdorf.de>
 <alpine.LFD.2.00.1010261747250.3115@localhost6.localdomain6>
 <1288120736.2645.9.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288120736.2645.9.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 26, 2010 at 12:18:56PM -0700, john stultz wrote:
> On Tue, 2010-10-26 at 17:48 +0200, Thomas Gleixner wrote:
> > On Tue, 26 Oct 2010, Markus Trippelsdorf wrote:
> > > On Tue, Oct 26, 2010 at 03:18:43PM +0200, Borislav Petkov wrote:
> > > > otherwise, I don't see anything strange in your dmesg. Unless tglx has a
> > > > better idea, I'd ask you to bisect it. 5618 changesets shouldn't be that
> > > > much but I don't know, if the issue appears every several hours it could
> > > > still be tedious.
> > > 
> > > That would be a several week long process, as the issue appears ~ every
> > > 2 days here on this machine running 24/7.
> > 
> > There is only a single commit in that area post 2.6.36:
> > 
> >       8af3c153baf95374eff20a37f00c59a295b52756 
> > 
> > But I have a hard time how this should make this happen. John ?
> 
> Yea, that one doesn't look connected to me.
> 
> There have been a few cases that I've seen where we can get false
> positives for bad TSCs due to the watchdog clocksource having problems
> (or the clocksource watchdog thread getting delayed for such a long time
> the watchdog clocksource wraps and we then can't validly compare the two
> - although this would be hard to trigger with non-rt kernels).

I think the remark above points in the right direction, because the
mysterious slowness happened again today (and this time on a vanilla git
kernel). But this time no "Clocksource tsc unstable" message appeared in
the kernel log. My system recovered by itself and after 2 minutes of
slowness it was usable again. (The symptoms were the same as desribed in
my first mail: Second long delays when typing and switching from X to
the console took many seconds.)

Is there anything I can do to pinpoint the cause of this slowdown should
it happen again? (Maybe a perf timechart?)

-- 
Markus
