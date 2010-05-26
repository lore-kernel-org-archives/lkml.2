Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795Ab0EZMy6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 08:54:58 -0400
Received: from ist.d-labs.de ([213.239.218.44]:34278 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754805Ab0EZMy4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 08:54:56 -0400
Date: Wed, 26 May 2010 14:54:52 +0200
From: Florian Mickler <florian@mickler.org>
To: felipe.balbi@nokia.com
Cc: Vitaly Wool <vitalywool@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Paul@smtp1.linux-foundation.org" <Paul@smtp1.linux-foundation.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100526145452.685337db@schatten.dmk.lab>
In-Reply-To: <20100526123532.GA2629@nokia.com>
References: <1274863655.5882.4875.camel@twins>
	<AANLkTinN6MKvCEhPkbYQRD2gu-mGXdNW9asRsTuKN3_Y@mail.gmail.com>
	<1274867106.5882.5090.camel@twins>
	<20100526120242.5c9b73ad@schatten.dmk.lab>
	<AANLkTim4021cTnhVZrQpefq1MG-eEPOFLDRO-XDepHb4@mail.gmail.com>
	<20100526133721.602633b2@schatten.dmk.lab>
	<AANLkTikzgaOFdQKess4E-D86OLPOzxP3dWiDkU_UR0ri@mail.gmail.com>
	<20100526142430.327ccbc4@schatten.dmk.lab>
	<20100526122932.GB1990@nokia.com>
	<20100526143323.7c6f8705@schatten.dmk.lab>
	<20100526123532.GA2629@nokia.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 May 2010 15:35:32 +0300
Felipe Balbi <felipe.balbi@nokia.com> wrote:

> Hi,
> 
> On Wed, May 26, 2010 at 02:33:23PM +0200, ext Florian Mickler wrote:
> >But then someone at the user side has to know what he is doing.
> >
> >I fear, if you target mass market without central distribution
> >channels, you can not assume that much.
> 
> and that's enough to push hacks into the kernel ? I don't think so. Do 
> it like apple and prevent multi-tasking for any non-apple applications 
> :-p
> 
:) 

It really comes down to a policy decision by the distribution maker.
And I don't think kernel upstream should be the one to force one way or
the other. So merging this patch set will allow android to continue
their work _on mainline_ while everybody else can continue as before.

All points about the impact on the kernel have already been raised. So
you should be happy there. 

Nonetheless, I really think the kernel needs to allow for the android
way of power saving. It misses out on a big feature and a big user-base
if not.

Also I expect there to be synergies between android development and
mainline kernel development _only_ if android development can use
mainline kernel.

And as for the quality of the "hack": I think you find this ugly, just
because you don't like the concept of degrading user space guaranties on
timers and stuff. 

But look at it this way: Suspend blockers are a way for the kernel
to make user space programs accountable for using the resource "power".
If a user space program needs the "traditional" guaranties for
functioning properly, it needs to take a suspend blocker. But _THEN_ it
better be well behaved. This is a kind of contract between userspace
and kernelspace.

On the other hand, if I don't need these traditional guaranties on
timers and stuff, I don't have to know device specific things about
power consumption. I can just use whatever facilities the programming
language provides without needing to worry about low level details.

This is a _big_ plus for attracting 3rd party programs. (And of course
the thing you don't like). 

Cheers,
Flo




