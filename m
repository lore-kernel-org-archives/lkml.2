Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270Ab0E1HED (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 03:04:03 -0400
Received: from ist.d-labs.de ([213.239.218.44]:43160 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754827Ab0E1HD5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 03:03:57 -0400
Date: Fri, 28 May 2010 09:03:49 +0200
From: Florian Mickler <florian@mickler.org>
To: Ben Gamari <bgamari.foss@gmail.com>
Cc: Vitaly Wool <vitalywool@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, Paul@smtp1.linux-foundation.org,
       felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100528090349.64112e8a@schatten.dmk.lab>
In-Reply-To: <877hmon5em.fsf@gmail.com>
References: <1274482015-30899-1-git-send-email-arve@android.com>
	<201005242049.18920.rjw@sisk.pl>
	<87wrusvrqe.fsf@deeprootsystems.com>
	<201005250138.16293.rjw@sisk.pl>
	<1274863655.5882.4875.camel@twins>
	<AANLkTinN6MKvCEhPkbYQRD2gu-mGXdNW9asRsTuKN3_Y@mail.gmail.com>
	<1274867106.5882.5090.camel@twins>
	<20100526120242.5c9b73ad@schatten.dmk.lab>
	<AANLkTim4021cTnhVZrQpefq1MG-eEPOFLDRO-XDepHb4@mail.gmail.com>
	<20100526133721.602633b2@schatten.dmk.lab>
	<AANLkTikzgaOFdQKess4E-D86OLPOzxP3dWiDkU_UR0ri@mail.gmail.com>
	<20100526142430.327ccbc4@schatten.dmk.lab>
	<877hmon5em.fsf@gmail.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 May 2010 22:09:37 -0400
Ben Gamari <bgamari.foss@gmail.com> wrote:

> On Wed, 26 May 2010 14:24:30 +0200, Florian Mickler <florian@mickler.org> wrote:
> > Because he is using a robust kernel that provides suspend blockers and
> > is preventing the vampire from sucking power? 
> > 
> Suspend blockers are only a flawed and indirect way to keep the vampire
> from sucking.
> 



> > Most users don't even grasp the simple concept of different "programs".
> > They just have a device and click here and there and are happy. 
> > 
> > Really, what are you getting at? Do you deny that there are programs,
> > that prevent a device from sleeping? (Just think of the bouncing
> > cows app)
> 
> He's getting at the fact that there are much better ways to deal with
> this problem. The issue here is that we seem to be expected to swallow
> whatever Google throws at us, regardless of the quality of the
> solution. It seems like the best argument we have for merging is "we
> couldn't think of anything better and we need it yesterday." This might be
> a good enough reason for shipping, but it certainly doesn't satisfy the
> requirements for merging.

I don't disagree on the quality. But I don't think it is because of the
patches, but because of how the kernel is architectured in that area
(suspend not being an idle state).

Look, probably suspend needs to be integrated into the idle states and
used from there. I could imagine a cost-specification for idle states:

c3
	cost-to-transition-to-this-state: X 
	powersavings-per-time: Y
	expected time we stay in this state: relative short, there is a
	timer sheduled
	suspend-blockers: ignored

suspend 
	cost-to-transition-to-this-state: depends, how much drivers to
	suspend, how much processes to freeze, ...
	powersavings-per-time: Y
	expected time we stay in this state: long, independent of
	sheduled timers
	suspend-blockers: need not be activated

Now, a governor could compute if it is ok, to enter suspend or only
wait for idle-c3. And maybe it would never transition from idle-c3 to
suspend but only from c1. because the cost to enter suspend would mean
it just has to go to c1 anyway.

what do ya think?

> > And if you have two kernels, one with which your device is dead after 1
> > hour and one with which your device is dead after 10 hours. Which would
> > you prefer? I mean really... this is ridiculous. 
> 
> It is absolutely not. If you want to keep power usage down, then
> implement real resource management in the scheduler. Suspend blockers
> are nothing but a clunky and ineffective means of resource allocation.
> As has been pointed out in this thread, there are much better ways of
> dealing with this problem.
> 
> - Ben

I think this has to be independently to the scheduler, because as soon
as the user interacts with the phone, everything needs to be scheduled.
even the stuff that doesn't directly interact with the user.
as soon as _nothing_ interacts with the user, the phone does schedule
_nothing_ anymore.

Cheers,
Flo
