Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754694Ab2HKUuj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2012 16:50:39 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:37238 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121Ab2HKUuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2012 16:50:37 -0400
MIME-Version: 1.0
In-Reply-To: <20120811192247.GB5132@phenom.ffwll.local>
References: <20120810145728.5490.44707.stgit@patser.local>
	<20120810145750.5490.5639.stgit@patser.local>
	<20120810202916.GI5738@phenom.ffwll.local>
	<CAF6AEGvzaJmVmnZmEp0QBfja8Vzb0mpLa_2J6bdUZj=fgDAHVg@mail.gmail.com>
	<20120811192247.GB5132@phenom.ffwll.local>
Date: Sat, 11 Aug 2012 15:50:36 -0500
X-Google-Sender-Auth: VAfZZThh3tLsrDTgAa4aYp9GBeQ
Message-ID: <CAF6AEGsgDSzk6_PqwRON+-LaYpA4aBTg1dM4BZvT10Y6uwQwvw@mail.gmail.com>
Subject: Re: [Linaro-mm-sig] [PATCH 2/4] dma-fence: dma-buf synchronization
 (v8 )
From: Rob Clark <rob.clark@linaro.org>
To: Rob Clark <rob.clark@linaro.org>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        sumit.semwal@linaro.org, linaro-mm-sig@lists.linaro.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 11, 2012 at 2:22 PM, Daniel Vetter <daniel@ffwll.ch> wrote:
>> >> +
>> >> +/**
>> >> + * dma_fence_wait - wait for a fence to be signaled
>> >> + *
>> >> + * @fence:   [in]    The fence to wait on
>> >> + * @intr:    [in]    if true, do an interruptible wait
>> >> + * @timeout: [in]    absolute time for timeout, in jiffies.
>> >
>> > I don't quite like this, I think we should keep the styl of all other
>> > wait_*_timeout functions and pass the arg as timeout in jiffies (and also
>> > the same return semantics). Otherwise well have funny code that needs to
>> > handle return values differently depending upon whether it waits upon a
>> > dma_fence or a native object (where it would us the wait_*_timeout
>> > functions directly).
>>
>> We did start out this way, but there was an ugly jiffies roll-over
>> problem that was difficult to deal with properly.  Using an absolute
>> time avoided the problem.
>
> Well, as-is the api works differently than all the other _timeout apis
> I've seen in the kernel, which makes it confusing. Also, I don't quite see
> what jiffies wraparound issue there is?

iirc, the problem was in dmabufmgr, in
dmabufmgr_wait_completed_cpu().. with an absolute timeout, it could
loop over all the fences without having to adjust the timeout for the
elapsed time.  Otherwise it had to adjust the timeout and keep track
of when the timeout elapsed without confusing itself via rollover.

BR,
-R
