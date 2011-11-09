Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756280Ab1KIIxm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 03:53:42 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61097 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318Ab1KIIxk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 03:53:40 -0500
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <CAF+7xW=uozfkCEfozZFmVzkbC+6S5UX-9n2woF9CCGxj5_tmFA@mail.gmail.com>
References: <1320827885.6708.1.camel@phoenix> <CAF+7xW=uozfkCEfozZFmVzkbC+6S5UX-9n2woF9CCGxj5_tmFA@mail.gmail.com>
From: Axel Lin <axel.lin@gmail.com>
Date: Wed, 9 Nov 2011 16:53:18 +0800
Message-ID: <CAF+7xW=JQBxV5A_3p6HrybetFq-kQAX-XRzQDAF7ebPApA_gnw@mail.gmail.com>
Subject: Re: [PATCH v3] ASoC: wm9081: Use snd_soc_update_bits for read-modify-write
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/11/9 Axel Lin <axel.lin@gmail.com>:
>>                        /* VMID 2*4k; Soft VMID ramp enable */
>> -                       reg = snd_soc_read(codec, WM9081_VMID_CONTROL);
>> -                       reg |= WM9081_VMID_RAMP | 0x6;
>> -                       snd_soc_write(codec, WM9081_VMID_CONTROL, reg);
>> +                       snd_soc_update_bits(codec, WM9081_VMID_CONTROL,
>> +                                           WM9081_VMID_RAMP |
>> +                                           WM9081_VMID_SEL_MASK,
>> +                                           WM9081_VMID_RAMP | 0x6);
>>
>>                        mdelay(100);
>>
>>                        /* Normal bias enable & soft start off */
>> -                       reg &= ~WM9081_VMID_RAMP;

oh.. wait. so original code does not clear WM9081_VMID_SEL_MASK bits here.
My bad. Don't know why I always think WM9081_VMID_SEL_MASK bits are
cleared here.

Will send a new version soon.

>> -                       snd_soc_write(codec, WM9081_VMID_CONTROL, reg);
>> +                       snd_soc_update_bits(codec, WM9081_VMID_CONTROL,
>> +                                           WM9081_VMID_RAMP |
>> +                                           WM9081_VMID_SEL_MASK, 0);
>>
