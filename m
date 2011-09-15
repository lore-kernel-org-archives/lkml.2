Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933303Ab1IOLOA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 07:14:00 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:59814 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933264Ab1IOLN7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 07:13:59 -0400
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <20110915095427.GB7988@opensource.wolfsonmicro.com>
References: <1316055154.3496.6.camel@phoenix> <20110915095427.GB7988@opensource.wolfsonmicro.com>
From: Axel Lin <axel.lin@gmail.com>
Date: Thu, 15 Sep 2011 19:13:38 +0800
Message-ID: <CAF+7xW=OdZYq4ufz=r_Bp0OUL2SnGNmEDDiGkRaUvXL2Jrx+tw@mail.gmail.com>
Subject: Re: ASoC: uninitialized variable i used in wait_for_dc_servo
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        Liam Girdwood <lrg@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/9/15 Mark Brown <broonie@opensource.wolfsonmicro.com>:
> On Thu, Sep 15, 2011 at 10:52:34AM +0800, Axel Lin wrote:
>> @@ -722,7 +723,7 @@ static void wait_for_dc_servo(struct snd_soc_codec *codec, u16 mask)
>>
>>               } else {
>>                       msleep(1);
>> -                     if (--i) {
>> +                     if (--i == 0) {
>
> You should avoid making random stylistic changes that aren't needed when
> doing things like this.
>
Ah. I didn't mean to change the coding style.
It's to reverse the logic of the if condition.

BTW, your fix looks good to me.

Regards,
Axel
