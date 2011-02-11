Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757932Ab1BKSdA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 13:33:00 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:47875 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756209Ab1BKSc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 13:32:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=oAdIY0MoNGFsbFBCmyeZO1y0IBogYGRpBmHVfmB5PJCiwno7UUAqfKuQq0JKdrU16A
         W9kAYQXlG+64qHpM9vcnxhXakfyhWyPsjXpkpIrQmYqRxt2sOmABxCD+XWaARt1GSnb5
         BY0OC3CugJVJOel8dz1gcJ1FGvGfFymHcmOR8=
Date: Fri, 11 Feb 2011 10:32:46 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Terry Lambert <tlambert@chromium.org>
Cc: Henrik Rydberg <rydberg@euromail.se>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: fixed EVIOCGRAB iterative grab/release.
Message-ID: <20110211183246.GA31385@core.coreip.homeip.net>
References: <1297381370-16388-1-git-send-email-tlambert@chromium.org>
 <20110211100439.GA1938@polaris.bitmath.org>
 <AANLkTikM3G5+KYXGe4hBL7LHg1-W0-dgN7jOGA2fbLvZ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikM3G5+KYXGe4hBL7LHg1-W0-dgN7jOGA2fbLvZ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Terry,

On Fri, Feb 11, 2011 at 09:55:53AM -0800, Terry Lambert wrote:
> Hi Henrik,
> 

First of all, please do not top-post.

> I'm in the middle of cutting down my failure case right now, so I
> should be able to provide a stand-alone test case shortly.  This is my
> top priority at work right now.
> 
> And you are correct about the race.  This is about back-to-back
> operations of a tool in a script, on a relatively slow machine with
> obstinate hardware, and a grabby Xorg driver (it's the closed source
> one, so I can't make it non-grabby).  So technically a stress test.
> 
> You noted the evdev->mutex; the idempotence of the call for the two
> pointer clears will be preserved by the mutex, so no one is going to
> get in under it while it's grabbed in the evdev_* layer, and not
> grabbed in the input_*_device layer, and get unhappy.
> 
> So at worst it's a no-op change that scratches my particularly weird itch here.

No, it is either a real problem that can happen with any hardware and
userspace or it is not, and it does not matter if userspace portion is
open or close source, it should work the same.

Before I can apply the patch I need to understand exactly:

1. How the problem is triggered (on the level "CPU1 enters particular
section of the code and then event A happens that causes CPU2 to do
something and then we are in trouble")

2. How the proposed change helps to avoid the sequence of events in 1.

> 
> PS: I supposed this use of the mutex is worthy of a comment in the
> code?  Any guidance?

If it helps people to understand the code - by all means. However you
need to realize that almost every operation within the kernel is
protected by some lock or mutex...

Thanks.

-- 
Dmitry
