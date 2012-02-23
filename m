Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589Ab2BWRb0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 12:31:26 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:59054 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752068Ab2BWRbZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 12:31:25 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of airlied@gmail.com designates 10.101.4.16 as permitted sender) smtp.mail=airlied@gmail.com; dkim=pass header.i=airlied@gmail.com
MIME-Version: 1.0
In-Reply-To: <CA+55aFwDXZSwDf3xjAofe_R15pu5G0Pg2UnkJTx-KVTXez4ZqA@mail.gmail.com>
References: <4F4669B1.4020306@tu-ilmenau.de>
	<aefc95$3a3h8b@orsmga001.jf.intel.com>
	<CA+55aFwDXZSwDf3xjAofe_R15pu5G0Pg2UnkJTx-KVTXez4ZqA@mail.gmail.com>
Date: Thu, 23 Feb 2012 17:31:24 +0000
Message-ID: <CAPM=9tyQx2Yn1wmm4Kv6EMPVcv8jP4YR55PEff8tHU1ZxyEDog@mail.gmail.com>
Subject: Re: responsiveness: newer kernels causing lagging and blocking
From: Dave Airlie <airlied@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chris Wilson <chris@chris-wilson.co.uk>, stephan.baerwolf@tu-ilmenau.de,
        linux-kernel@vger.kernel.org, Michael Buesch <mb@bu3sch.de>,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 23, 2012 at 5:29 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Thu, Feb 23, 2012 at 9:21 AM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
>>
>> One mystery that has never been resolved is just why wine causes a flood
>> of xrandr/connection probes, and then there is still the underlying issue
>> that probing blocks the device and causes noticeable latency.
>
> Is there any chance that the EDID code would just have a "if I probed
> in the last second or two, let's not do it again and instead just
> return the cached data from last time" thing to just protect against
> some odd interrupt flood (or a user that asks for edid information
> explicitly like xrandr).

X already does that, if you can the randr interfaces it doesn't cause
a probe unless you ask for it.

wine must be doing something silly or just needs to call a different interface.

Dave.
>
>                   Linus
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
