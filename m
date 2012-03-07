Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756883Ab2CGMoh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 07:44:37 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:37223 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034Ab2CGMog convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 07:44:36 -0500
MIME-Version: 1.0
In-Reply-To: <f80fcd$3o8hke@fmsmga001.fm.intel.com>
References: <1331121050-17857-1-git-send-email-djkurtz@chromium.org>
 <1331121050-17857-5-git-send-email-djkurtz@chromium.org> <f80fcd$3o8hke@fmsmga001.fm.intel.com>
From: Daniel Kurtz <djkurtz@chromium.org>
Date: Wed, 7 Mar 2012 20:44:15 +0800
X-Google-Sender-Auth: 09ytX5TMXbuiH9IQf4iTKmZzZqs
Message-ID: <CAGS+omC3pa_0ncavtG=GdAC1NJtP=epPSrcURmH+is6hhs2z9w@mail.gmail.com>
Subject: Re: [PATCH 4/9] drm/i915/intel_i2c: cleanup gmbus/gpio pin assignments
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Keith Packard <keithp@keithp.com>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Sameer Nanda <snanda@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 7, 2012 at 8:17 PM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> On Wed,  7 Mar 2012 19:50:45 +0800, Daniel Kurtz <djkurtz@chromium.org> wrote:
>> There is no "disabled" port 0.  So, don't even try to initialize/scan
>> it, etc.  This saves a bit of time when initializing the driver, since
>> the we can avoid a 50ms timeout waiting for a device to respond on
>> a port that doesn't even exist.
>>
>> Similarly, don't initialize the reserved port, either.
>
>> @@ -150,32 +164,23 @@ static void set_data(void *data, int state_high)
>>  static struct i2c_adapter *
>>  intel_gpio_create(struct drm_i915_private *dev_priv, u32 pin)
>>  {
>> -     static const int map_pin_to_reg[] = {
>> -             0,
>> -             GPIOB,
>> -             GPIOA,
>> -             GPIOC,
>> -             GPIOD,
>> -             GPIOE,
>> -             GPIOF,
>> -             0,
>> -     };
>>       struct intel_gpio *gpio;
>>
>> -     if (pin >= ARRAY_SIZE(map_pin_to_reg) || !map_pin_to_reg[pin])
>
> And that doesn't do what your changelog proposes? Why?

This changelog proposes to optimize initialization of the gmbus ports,
not the gpio-bit-bang ports.

> -Chris
>
> --
> Chris Wilson, Intel Open Source Technology Centre
