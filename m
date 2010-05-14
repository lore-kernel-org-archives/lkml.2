Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757919Ab0ENHfF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 03:35:05 -0400
Received: from mail-yx0-f191.google.com ([209.85.210.191]:36514 "EHLO
	mail-yx0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757516Ab0ENHfB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 03:35:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=NkzcUnM3rHXi2I/3QlT1U4Cos5Xo5sac8wK/Z46wfQDnGQXFp89tq74niH9+TyeQpm
         gk5DPf9Aq/RggjKkLI5v3NGqOjQx489VDIk2IiR9sWWpa5VNa9Mo9NdTJzmCuaHRq8sA
         SFNQBMeviQGNskAPQ0fSSIWhr16JMdhsdFaf4=
MIME-Version: 1.0
In-Reply-To: <89k83a$882me0@azsmga001.ch.intel.com>
References: <AANLkTikfzHWeVjto4Q8bWDie_5BjRz3V0fc3LW7k4uob@mail.gmail.com>
	 <89k83a$882me0@azsmga001.ch.intel.com>
Date: Fri, 14 May 2010 13:05:00 +0530
Message-ID: <AANLkTinJ3Bgf9kYsGQPv5BVC7tAfRpwBaEPY8-tgAiem@mail.gmail.com>
Subject: Re: render error detected, EIR: 0x00000010
From: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: dri-devel@lists.freedesktop.org, Dave Airlie <airlied@linux.ie>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Chris,

On Fri, May 14, 2010 at 4:16 AM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> On Fri, 14 May 2010 03:59:08 +0530, Jaswinder Singh Rajput <jaswinderlinux@gmail.com> wrote:
>> Hello Chris,
>>
>> I am also getting display error on another PC :
>>
>> [   34.198957] render error detected, EIR: 0x00000010
>> [   34.198972] [drm:i915_handle_error] *ERROR* EIR stuck: 0x00000010, masking
>> [   34.198998] render error detected, EIR: 0x00000010
>
> Wow. Things are really amiss there. MI_SET_CONTEXT (the first instruction
> in the batch) was removed in
>
>  commit 45f45c73469f1bd46a1b6fb206f2e9e5e4fd66b3
>  Author: Eric Anholt <eric@anholt.net>
>  Date:   Mon Dec 29 11:26:11 2008 -0800
>
>      Remove logical context setup.
>
> which explains why the destination bo is not on the active list, you
> have a pre-GEM UMS xf86-video-intel (so the batchbuffer is using absolute
> addressing rather than relocs and the kernel memory manager). The hardware
> is reporting a PTE error (in the overlay plane!) and the single active
> command is to clear the absolute buffer. As it is not being tracked by the
> kernel, I can't tell you what's wrong with the buffer, but most probably
> either the size or its stride is illegal in the context of that command.
> Or maybe even the GTT hasn't been fully initialised for the buffer, it is
> impossible to tell.
>
> In short, you can trade this bug against the risk of GTT incoherency that
> is endemic on i8xx by updating your driver.
>

I am getting XWindows on this old machine so this is not so serious
issue, I can ignore the error message ;-)

I am more worried about Acer machine where I am not getting XWindows.

Thanks,
--
Jaswinder Singh.
