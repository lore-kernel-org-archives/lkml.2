Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756404Ab0FATRv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 15:17:51 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58572 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753467Ab0FATRr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 15:17:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=iS/emYhsst5+Bjiwsawcq1SJd6trgBxNqgSFMGHb4iVyV+M5F7HFUWyY7DZnsLCpKk
         CYzB/ugIc8Y96NUoazf9OzyC5uCBqg3uWWEFM2vRxKlpn8pr4AEFvd6/OIlHpVEmcRET
         WOUKB0TrPa7q3BC9hWnIYwVq3waxBp0KYRa2U=
MIME-Version: 1.0
In-Reply-To: <4C047CF9.9000804@tmr.com>
References: <AANLkTimEFy6VM3InWlqhVooQjKGSD3yBxlgeRbQC2r1L@mail.gmail.com>
	<20100531165528.35a323fb.rdunlap@xenotime.net>
	<4C047CF9.9000804@tmr.com>
Date: Tue, 1 Jun 2010 21:17:40 +0200
Message-ID: <AANLkTilLq-hn59CBcLnOsnT37ZizQR6MrZX6btKPhfpb@mail.gmail.com>
Subject: Re: Possible bug in 2.6.34 slub
From: Giangiacomo Mariotti <gg.mariotti@gmail.com>
To: Bill Davidsen <davidsen@tmr.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 1, 2010 at 5:22 AM, Bill Davidsen <davidsen@tmr.com> wrote:
> Randy Dunlap wrote:
>>
>> On Tue, 1 Jun 2010 01:39:43 +0200 Giangiacomo Mariotti wrote:
>>
>>> Hi, I've recently noticed this line on the dmesg output(kernel 2.6.34):
>>> [    0.000000] SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0,
>>> CPUs=16, Nodes=1
>>>
>>> My cpu is an I7 920, so it has 4 cores and there's hyperthreading
>>> enabled, so there are 8 logical cpus. Is this a bug?
>>
>>
>> No, it's just some boot/init time information.
>>
> I would consider it a bug to claim CPUs=xx when xx is something other than
> the number of cores or the number of SMT threads supported by the processor.
> Of course if /proc/cpuinfo shows four siblings per core or something
> exciting, then it's right and you have a CPU you can sell to gizmodo and
> tell them a drunk left on the bar.
>
So....is it a bug or not?

The point is, I guess(didn't actually look at the code), if that's
just the count of MAX number of cpus supported, which is a config time
 define and then the actual count gets refined afterwards by slub
too(because I know that the rest of the kernel knows I've got 4
cores/8 logical cpus) or not. Is that it? If this is not the case(that
is, it's not a static define used as a MAX value), then I can't see
what kind of boot/init time info it is. If it's a boot-time info, it
just means it's a _wrong_ boot-time info.

-- 
Giangiacomo
