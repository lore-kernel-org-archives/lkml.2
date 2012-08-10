Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756335Ab2HJKLG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 06:11:06 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:55610 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236Ab2HJKLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 06:11:01 -0400
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <5021F00B.7000503@ionic.de>
References: <5021F00B.7000503@ionic.de>
Date: Fri, 10 Aug 2012 12:10:59 +0200
Message-ID: <CAKMK7uFutq0Hn3FL==53Vvt-M00ReWaeXKq3uo8C_kzUfX+1ew@mail.gmail.com>
Subject: Re: null pointer dereference while loading i915
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Mihai Moldovan <ionic@ionic.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 8, 2012 at 6:50 AM, Mihai Moldovan <ionic@ionic.de> wrote:
> Hi Daniel, hi list
>
> ever since version 3.2.0 (maybe even earlier, but 3.0.2 is still working fine),
> my box is crashing when loading the i915 driver (mode-setting enabled.)
>
> The current version I'm testing with is 3.5.0.
>
> I was able to get the BUG output (please forgive any errors/flips in the output,
> I have had to transcribe the messages from the screen/images), however, I'm not
> able to find out what's wrong.
>
> If I see it correctly, there's a null pointer dereference in a printk called
> from inside gmbus_xfer. The only printk calls I can see in
> drivers/gpu/drm/i915/intel_i2c.c gmbus_xfer() however are issued by the
> DRM_DEBUG_KMS() and DRM_INFO() macros.
> Neither call looks wrong to me, I even tried to swap adapter->name with
> bus->adapter.name and make *sure* i < num is true, but haven't had any success.
>
> I'd really like to see this bug fixed, as it's preventing me from updating the
> kernel for over a year now.
>
> Also, while 3.0.2 works, it *does* spew error/warning messages related to gmbus
> and I've had corrupted VTs in the past (albeit after a long uptime with multiple
> X restarting and DVI cable unplugging/reattaching events), so maybe there's a
> lot more broken than "expected".

Hm, this is rather strange. gmbus should not be enable on 3.2 nor 3.0,
since exactly this issue might happen. We've re-enabled gmbus again on
3.5 after having fixed this bug. Are you sure that this is plain 3.2
you're running?

Yours, Daniel
-- 
Daniel Vetter
daniel.vetter@ffwll.ch - +41 (0) 79 365 57 48 - http://blog.ffwll.ch
