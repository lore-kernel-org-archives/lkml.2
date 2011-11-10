Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757700Ab1KJPLi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 10:11:38 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53172 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048Ab1KJPLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 10:11:37 -0500
Message-ID: <4EBBE9A1.8020501@gmail.com>
Date: Thu, 10 Nov 2011 16:11:29 +0100
From: Daniel Mack <zonque@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: dri-devel@lists.freedesktop.org
CC: jbarnes@virtuousgeek.org, harald@redhat.com,
        Keith Packard <keithp@keithp.com>, linux-kernel@vger.kernel.org
Subject: Re: Strange effect with i915 backlight controller
References: <4EB3F860.6010408@gmail.com> <4EB87E6A.3060403@gmail.com>
In-Reply-To: <4EB87E6A.3060403@gmail.com>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08/2011 01:57 AM, Daniel Mack wrote:
> Didn't get any response yet, hence copying LKML for a broader audience.

Nobody, really?

This is a rather annoying regression, as touching the brightness keys
appearantly switches off the whole machine. I'm sure this is trivial to
fix, I just don't have the insight of this driver and the chipset.

Any pointer greatly appreciated, and I can test patches.


Thanks,
Daniel



> 
> On 11/04/2011 03:36 PM, Daniel Mack wrote:
>> I'm facing a bug on a Samsung X20 notebook which features an i915
>> chipset (output of 'lspci -v' attached).
>>
>> The effect is that setting the backlight to odd values causes the value
>> to be misinterpreted. Harald Hoyer (cc:) had the same thing on a Netbook
>> (I don't recall which model it was).
>>
>> So this will turn the backlight to full brightness:
>>
>> # cat /sys/class/backlight/intel_backlight/max_brightness
>> 29750
>> # echo 29750 > /sys/class/backlight/intel_backlight/brightness
>>
>> However, writing 29749 will turn the display backlight off, and 29748
>> appears to be the next valid lower value.
>>
>> It seems like the IS_PINEVIEW() branch in
>> drivers/gpu/drm/i915/intel_panel.c:intel_panel_actually_set_backlight()
>> could do the right thing, but this code is written for an entirely
>> different model, right?
>>
>> I can reproduce this on 3.0 and 3.1 vanilla as well as with the current
>> mainline git.
>>
>> Let me know if there is any patch that I can test.
>>
>>
>> Thanks,
>> Daniel
> 

