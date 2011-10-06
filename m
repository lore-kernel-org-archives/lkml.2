Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935839Ab1JFLdw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 07:33:52 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:39851 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935288Ab1JFLdv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 07:33:51 -0400
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <4E8D90E9.5060208@cam.ac.uk>
References: <1317881417.13399.1.camel@phoenix> <1317881863.13399.10.camel@phoenix>
 <4E8D90E9.5060208@cam.ac.uk>
From: Axel Lin <axel.lin@gmail.com>
Date: Thu, 6 Oct 2011 19:33:29 +0800
Message-ID: <CAF+7xWnWaPB8JKepUoGmvpVw6W6pJPVNkXAdy9GTD2rf9QDUNQ@mail.gmail.com>
Subject: Re: [PATCH 06/10] ASoC: wm8940: Convert to snd_soc_cache_sync
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Ian Lartey <ian@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> +static int wm8940_volatile_register(struct snd_soc_codec *codec,
>> +                                 unsigned int reg)
>> +{
>> +     switch (reg) {
>> +     case WM8940_SOFTRESET:
>> +             return 1;
>> +     default:
>> +             return 0;
>> +     }
>> +}
> I guess this makes sense from point of view of keeping things inline with
> more complex drivers.  Otherwise I'd expect to see something like:
> {
>        return !!(reg == WM894_SOFTRESET);
> }

Either is ok to me.
But current syntax makes it easier to add more registers to be volatile
if necessary.

So I'll let Mark decide if I need to send a v2 for changing this.

Regards,
Axel
