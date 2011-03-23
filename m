Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932506Ab1CWOj5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 10:39:57 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60824 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932185Ab1CWOjz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 10:39:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=qoDfF8gsUVs8HyxEEY2dk9Y0MQFX62YivIhR/5oLrUeqdUJQGbLYlluu8Y3pJqI7jv
         6Wzm6aehFewXdK81Mbd3GIzoXCA7rplG7FTQ/ey2iz+uH0SYkPgo+wBeOyd0tlFbrRLM
         H+WBD6IQCevKPOyV9Re+xEWladHi0EVDuKAc8=
MIME-Version: 1.0
In-Reply-To: <4D89E5E1.3070402@earthlink.net>
References: <alpine.DEB.2.00.1103170403160.3429@skynet.skynet.ie>
	<AANLkTinoTs89ThBnZ17+fPE+t1V=GycKq2EJG-LadFZQ@mail.gmail.com>
	<4D89E5E1.3070402@earthlink.net>
Date: Wed, 23 Mar 2011 10:39:54 -0400
Message-ID: <AANLkTikK_88tBW+1RPLGTD51WwCOmr2j=8xBRPF=ZiPK@mail.gmail.com>
Subject: Re: [git pull] drm next tree
From: Jerome Glisse <j.glisse@gmail.com>
To: sclark46@earthlink.net
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Airlie <airlied@linux.ie>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Keith Packard <keithp@keithp.com>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 23, 2011 at 8:21 AM, Stephen Clark <sclark46@earthlink.net> wrote:
> On 03/22/2011 10:19 PM, Linus Torvalds wrote:
>>
>> So I had  hoped - yes, very naïve of me, I know - that this merge
>> window would be different.
>>
>> But it's not.
>>
>> On Wed, Mar 16, 2011 at 9:09 PM, Dave Airlie<airlied@linux.ie>  wrote:
>>
>>>
>>> i915: big 855 fix, lots of output setup refactoring, lots of misc fixes.
>>>
>>
>> .. and apparently a lot of breakage too. My crappy laptop that I abuse
>> for travel is - once more - broken by the updates. I cannot suspend
>> and resume, because every resume seems to fail.
>>
>> One of the more useful failures was:
>>
>> [   61.656055] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer
>> elapsed... GPU hung
>> [   61.656079] [drm] capturing error event; look for more information
>> in /debug/dri/0/i915_error_state
>> [   61.664387] [drm:i915_wait_request] *ERROR* i915_wait_request
>> returns -11 (awaiting 2 at 0, next 3)
>>
>> and I'm attaching the error_state file from that particular case here.
>> In other cases it seems to just hang entirely.
>>
>> Keith/Jesse/Chris - I don't know that it's i915, and it will take
>> forever to bisect (I'll try). But it does seem pretty likely.
>>
>>                              Linus
>>
>
> Why can't the gpu be reset/restarted when this happens? When a nic card gets
> hung it is reinitialized
> and restarted why not the gpu?
>
> --

GPU are so complex, i know case where reseting a GPU would lead to
bring down the PCI and the CPU with it (basicly the reset clear some
of the GPU memory controller bit but not the GPU PCI request queue, so
after/while reseting the GPU trigger a several request to bogus
address on the bus, then trigger a double fault and eventually a CPU
shutdown) . Of course here we can blame the hw designer for not having
a proper reset.

All this vary from one GPU to another, it seems that reset have become
more reliable on newer hw.

Cheers,
Jerome
