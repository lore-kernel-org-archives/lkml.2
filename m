Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757877Ab2C1NWG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 09:22:06 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:40510 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755340Ab2C1NWE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 09:22:04 -0400
MIME-Version: 1.0
In-Reply-To: <1332939924_127442@CP5-2952>
References: <1332939117-6513-1-git-send-email-djkurtz@chromium.org>
 <1332939117-6513-15-git-send-email-djkurtz@chromium.org> <1332939924_127442@CP5-2952>
From: Daniel Kurtz <djkurtz@chromium.org>
Date: Wed, 28 Mar 2012 21:21:42 +0800
X-Google-Sender-Auth: 9FNqdAf-58hyZqmpztl0PC-lBbY
Message-ID: <CAGS+omAJaEaGUNY6V=sGNOWHxhb3YRv2mPcuUwQV99ksvsNP4Q@mail.gmail.com>
Subject: Re: [PATCH 14/14 v5] drm/i915/intel_i2c: remove POSTING_READ() from
 gmbus transfers
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Daniel Vetter <daniel@ffwll.ch>, Keith Packard <keithp@keithp.com>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Benson Leung <bleung@chromium.org>,
        Yufeng Shen <miletus@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 28, 2012 at 9:05 PM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> On Wed, 28 Mar 2012 20:51:57 +0800, Daniel Kurtz <djkurtz@chromium.org> wrote:
>> The POSTING_READ() calls were originally added to make sure the writes
>> were flushed before any timing delays and across loops.
>> However, the normal I915_READ() and I915_WRITE() macros already call
>> readl() / writel(), which already have an explicit mb().
>>
>> Now that the code has settled a bit, let's remove them.
>>
>> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
>> ---
>>  drivers/gpu/drm/i915/intel_i2c.c |    5 -----
>>  1 files changed, 0 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/i915/intel_i2c.c b/drivers/gpu/drm/i915/intel_i2c.c
>> index 2865313..be2852e 100644
>> --- a/drivers/gpu/drm/i915/intel_i2c.c
>> +++ b/drivers/gpu/drm/i915/intel_i2c.c
>> @@ -131,7 +131,6 @@ static void set_clock(void *data, int state_high)
>>                       GPIO_CLOCK_VAL_MASK;
>>
>>       I915_WRITE_NOTRACE(bus->gpio_reg, reserved | clock_bits);
>> -     POSTING_READ(bus->gpio_reg);
> We do need the write flush here (and set_data) as the next action is a
> udelay loop which is not per-se a mb.

Now I am confused.  I915_WRITE_NOTRACE() calls writel(), which has an
explicit mb();  Why do you need another mb?

> -Chris
>
> --
> Chris Wilson, Intel Open Source Technology Centre
