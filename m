Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738Ab2GMWir (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 18:38:47 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:42437 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752272Ab2GMWip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 18:38:45 -0400
MIME-Version: 1.0
In-Reply-To: <500096B6.2090208@canonical.com>
References: <1342193911-16157-1-git-send-email-rob.clark@linaro.org>
	<50005dfd.25f2440a.6e6b.ffffbcd9SMTPIN_ADDED@mx.google.com>
	<CAF6AEGvP1+7BKo7+oCj4XBBw32NPjrH5EAZuodu2zb8oiyVP_Q@mail.gmail.com>
	<500096B6.2090208@canonical.com>
Date: Fri, 13 Jul 2012 17:38:44 -0500
X-Google-Sender-Auth: Qcl8t24nZq1zaLggO8A9xLbywZs
Message-ID: <CAF6AEGt=eXWy93Z_x7XynmKi+zFGESSuTMSyPrRZ2P-wKOXMWg@mail.gmail.com>
Subject: Re: [RFC] dma-fence: dma-buf synchronization (v2)
From: Rob Clark <rob.clark@linaro.org>
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: Tom Cooksey <tom.cooksey@arm.com>, dri-devel@lists.freedesktop.org,
        linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
        patches@linaro.org, daniel.vetter@ffwll.ch,
        linux-kernel@vger.kernel.org, sumit.semwal@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2012 at 4:44 PM, Maarten Lankhorst
<maarten.lankhorst@canonical.com> wrote:
> Hey,
>
> Op 13-07-12 20:52, Rob Clark schreef:
>> On Fri, Jul 13, 2012 at 12:35 PM, Tom Cooksey <tom.cooksey@arm.com> wrote:
>>> My other thought is around atomicity. Could this be extended to
>>> (safely) allow for hardware devices which might want to access
>>> multiple buffers simultaneously? I think it probably can with
>>> some tweaks to the interface? An atomic function which does
>>> something like "give me all the fences for all these buffers
>>> and add this fence to each instead/as-well-as"?
>> fwiw, what I'm leaning towards right now is combining dma-fence w/
>> Maarten's idea of dma-buf-mgr (not sure if you saw his patches?).  And
>> let dmabufmgr handle the multi-buffer reservation stuff.  And possibly
>> the read vs write access, although this I'm not 100% sure on... the
>> other option being the concept of read vs write (or
>> exclusive/non-exclusive) fences.
> Agreed, dmabufmgr is meant for reserving multiple buffers without deadlocks.
> The underlying mechanism for synchronization can be dma-fences, it wouldn't
> really change dmabufmgr much.
>> In the current state, the fence is quite simple, and doesn't care
>> *what* it is fencing, which seems advantageous when you get into
>> trying to deal with combinations of devices sharing buffers, some of
>> whom can do hw sync, and some who can't.  So having a bit of
>> partitioning from the code dealing w/ sequencing who can access the
>> buffers when and for what purpose seems like it might not be a bad
>> idea.  Although I'm still working through the different alternatives.
>>
> Yeah, I managed to get nouveau hooked up with generating irqs on
> completion today using an invalid command. It's also no longer a
> performance regression, so software syncing is no longer a problem
> for nouveau. i915 already generates irqs and r600 presumably too.
>
> Monday I'll take a better look at your patch, end of day now. :)

let me send you a slightly updated version.. I fixed locally some
locking fail in attach_fence() and get_fence() that I managed to
introduce when converting from global spinlock to using the
waitqueue's spinlock.

BR,
-R

> ~Maarten
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
