Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753621Ab1DNVet (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 17:34:49 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:57015 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752722Ab1DNVeq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 17:34:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Byquhq8zomYSC5hwaOvasydJpiN0gkAZCZIdU6r8c3A40g03f1MwcNqP9DY+lkz5uD
         U5lEEEeY0FDJAfFY0i9AtymP564LWVkqSYjVWIOirG4fAprLCUrJO4agcPibR5S0ix/0
         FfXxEVUO8AT0d6bzs+ZCuvP5p5ZGmS+QFpCLw=
MIME-Version: 1.0
In-Reply-To: <20110414210932.GG18463@8bytes.org>
References: <BANLkTimNvX=U6qy2FgvDpWE6HY7cehWvyQ@mail.gmail.com>
	<20110412090207.GE19819@8bytes.org>
	<BANLkTimSgAmT5a1s0ciBr2jsE-Nu7n4buQ@mail.gmail.com>
	<20110412184433.GF19819@8bytes.org>
	<20110413064609.GA18777@elte.hu>
	<20110413172147.GI19819@8bytes.org>
	<4DA5F62F.3030504@kernel.org>
	<4DA654D6.2060103@zytor.com>
	<20110414085624.GC18463@8bytes.org>
	<BANLkTintewt4kadNLEZ-RAew0Gx6=gUOfQ@mail.gmail.com>
	<20110414210932.GG18463@8bytes.org>
Date: Thu, 14 Apr 2011 17:34:46 -0400
Message-ID: <BANLkTimRrx-QLPWwJx37qWhtwhdC8RTpsQ@mail.gmail.com>
Subject: Re: Linux 2.6.39-rc3
From: Alex Deucher <alexdeucher@gmail.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, Thomas Gleixner <tglx@linutronix.de>,
        Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 14, 2011 at 5:09 PM, Joerg Roedel <joro@8bytes.org> wrote:
> On Thu, Apr 14, 2011 at 10:28:43AM -0400, Alex Deucher wrote:
>> On Thu, Apr 14, 2011 at 4:56 AM, Joerg Roedel <joro@8bytes.org> wrote:
>> > And this makes a difference, with this change on-top of -rc3 the box boots
>> > fine. So there seems to be some dependency between the GART base and the GTT
>> > base even when they are in different address spaces.
>> >
>> > Alex, can you comment on this?
>>
>> As Dave said, they are completely different addresses spaces.  You
>> could put the GPU aperture at 0 if you wanted (in fact we do on some
>> chips).  Perhaps there's some strange interaction with the nb gart
>> since the nb gart on that chipset was designed to be used for graphics
>> and the rs780/880 can be configured to use an agp aperture.
>> Unfortunately, I'm not that familiar with the nb gart.
>
> Actually, the nb gart is part of the cpu. It is part of the cpu north
> bridge and can translate io and cpu accesses. In fact, it is a remapper
> of physical memory addresses.

I know what it's for.  In the IGP graphics chip is also part of the
north bridge, but it may not be related at all.

>
> The problem seems to be related to specific gpu chips. On another
> notebook with an hd3000 card gtt and the nb gart aperture are both on
> 0xa0000000 too but the box works fine. I havn't tested with an hd5000
> yet. The failing notebook has an hd4200 mobility.

What exact model is the hd3000?   Is it IGP GPU or a discrete GPU?  It
it's an IGP, it's identical to the hd4200 programming-wise.

>
> Btw. what happens if the gpu accesses an unmapped address in the gtt
> range?

It's redirected to a dummy page.

Alex
