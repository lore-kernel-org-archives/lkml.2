Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751168Ab1KEGrR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Nov 2011 02:47:17 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:47519 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920Ab1KEGrQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Nov 2011 02:47:16 -0400
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <20111104221730.GA16978@opensource.wolfsonmicro.com>
References: <1318993587.7128.7.camel@phoenix> <20111104221730.GA16978@opensource.wolfsonmicro.com>
From: Axel Lin <axel.lin@gmail.com>
Date: Sat, 5 Nov 2011 14:46:55 +0800
Message-ID: <CAF+7xWntQUw6g7FD92iZm+D7ZS8dGG4=Q4SiHZRTkevbVrLCyg@mail.gmail.com>
Subject: Re: [PATCH v2 RESEND] ASoC: wm9081: Use snd_soc_update_bits for read-modify-write
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/11/5 Mark Brown <broonie@opensource.wolfsonmicro.com>:
> On Wed, Oct 19, 2011 at 11:06:27AM +0800, Axel Lin wrote:
>
>>                       /* Normal bias enable & soft start off */
>> -                     reg |= WM9081_BIAS_ENA;
>> -                     reg &= ~WM9081_VMID_RAMP;
>> -                     snd_soc_write(codec, WM9081_VMID_CONTROL, reg);
>> +                     snd_soc_update_bits(codec, WM9081_VMID_CONTROL,
>> +                                         WM9081_VMID_RAMP | WM9081_BIAS_ENA |
>> +                                         WM9081_VMID_SEL_MASK,
>> +                                         WM9081_BIAS_ENA);
>
> This looks (and sounds) wrong - the original code didn't touch
> VMID_SEL_MASK for this update but the new version will clear
> VMID_SEL_MASK.  Even with that fixed there still seems to be some issue
> here, though.
>

Hi Mark,

I just re-check current code, and I think current code (before converting to
snd_soc_update_bits) is broken.
See below 2 patches: ( I'm sending the patch now)
ASoC: wm9081: Fix reading wrong register for setting VMID 2*240k
ASoC: wm9081: Don't write WM9081_BIAS_ENA bit to WM9081_VMID_CONTROL register

Would you mind to test if above 2 patches works.
If it works, I'll send a new patch to use snd_soc_update_bits for
read-modify-write.

Thanks,
Axel
