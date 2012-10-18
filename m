Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752679Ab2JRHep (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 03:34:45 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:43914 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680Ab2JRHen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 03:34:43 -0400
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <20121015151119.GB30606@kroah.com>
References: <1350288682-6236-1-git-send-email-daniel.vetter@ffwll.ch>
	<20121015151119.GB30606@kroah.com>
Date: Thu, 18 Oct 2012 09:34:41 +0200
Message-ID: <CAKMK7uEH=XNcjSzaTwpHPpAmdDHNo7aQmeobvQoRi6N94+08Zw@mail.gmail.com>
Subject: Re: [PATCH] drm/i915: disable cpu relocs on ilk and earlier
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>, Dave Airlie <airlied@gmail.com>,
        Chris Wilson <chris@chris-wilson.co.uk>, stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15, 2012 at 5:11 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Mon, Oct 15, 2012 at 10:11:22AM +0200, Daniel Vetter wrote:
>> Hi Greg&stable-team,
>>
>> The below patch papers over a graphics corruption issue in 3.5/3.6. The
>> regression happened due to pwrite tunings in 3.5, which made cpu relocations
>> much more likely.
>>
>> The issue seems to have disappeared in 3.7-rc1, but it takes a few days to test
>> a patch, so we haven't figured out what exactly fixed things. Now users are
>> taking out their pitchforks already, so instead of wasting more days (maybe
>> weeks?) to fully understand the bug before backporting the fix, we've opted for
>> the below disable patch, which should have minimal impact (at most it undoes the
>> tuning improvements in 3.5).
>>
>> Patch is tested by reporters & acked by all relevant ppl, please apply to
>> 3.5/3.6 series kernels.
>
> No, I'd really like to wait until you figure out what is happening in
> 3.7-rc1 right now before applying the patch.  We have the rule, "it must
> be in Linus's tree first" for a very good reason :)

Ok, the verdict is in (thanks a lot Dave for testing all these
different patches) and it seems like

commit 504c7267a1e84b157cbd7e9c1b805e1bc0c2c846
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Thu Aug 23 13:12:52 2012 +0100

    drm/i915: Use cpu relocations if the object is in the GTT but not mappable

from upstream nicely papers over the issues. Please apply to 3.5/3.6
stable series (earlier kernels don't exhibit the problem).

Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=852210
Tested-by: Dave Airlie <airlied@gmail.com>

Thanks, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
