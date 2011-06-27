Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735Ab1F0Ol0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 10:41:26 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:24379 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211Ab1F0OlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 10:41:19 -0400
Date: Mon, 27 Jun 2011 16:41:08 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Alexander Stein <alexander.stein@systec-electronic.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>,
        Guenter Roeck <guenter.roeck@ericsson.com>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
Subject: Re: coretemp: Support for Intel Atom E6XX CPU (TunnelCreek)?
Message-ID: <20110627164108.777c2e28@endymion.delvare>
In-Reply-To: <201106271220.51953.alexander.stein@systec-electronic.com>
References: <201106271220.51953.alexander.stein@systec-electronic.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexander,

On Mon, 27 Jun 2011 12:20:51 +0200, Alexander Stein wrote:
> I have a patch (for v2.6.39) which adds support for Intel Atom E6XX 
> (TunnelCreek) to coretemp. It's merely only adding x86_model 0x26.

You have a patch, great for you. What do you expect if you don't share
it with us?

I'm not quite sure what your patch would be doing anyway. Since kernel
2.6.35, supported CPU models are detected using the DTS feature flag
rather than the family and model numbers, so your Atom E6XX should be
detected just fine.

Note that there was a bug in kernels 2.6.35 to 2.6.39 with regards to
TjMax guessing, which was fixed by Gunter Roeck with:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=4f5f71a7abe329bdad81ee6a8e4545054a7cc30a
You'll have to update to kernel version 2.6.39.2 to get this fix.

Do you happen to know what CPUs model number 0x26 covers? Do you know
if this model supports MSR_IA32_TEMPERATURE_TARGET or not? The original
Atom (model 0x1c) did not.

> But there are models (e.g. E660 and E660T) with different TjMax, namely 90 
> degrees C and 110 degrees C. But these different model can't be detected by 
> reading from hardware.

I would appreciate a patch to Documentation/hwmon/coretemp adding the
known TjMax for these new Atom models.

BTW, is it really impossible to identify these models with a different
TjMax? Don't the strings "E660" and "E660T" appear in the respective
"model name" entries in /proc/cpuinfo?

> IMO there should be some support to adjust the temperature from userspace. 
> Reading Documentation/hwmon/sysfs-interface only temp1_offset seems to be 
> useable. But I think it is somewhat misleading (especially on multicores), 
> because there must only be one offset.

No, tempN_offset isn't suitable for this case, as it would only shift the
current temperature and not the limits.

Instead, we could detect the specific CPUs using the model name string
and adjust TjMax accordingly. And/or we could let the user override
TjMax through a module parameter (I doubt anyone runs a system with
CPUs with different TjMax values.)

-- 
Jean Delvare
