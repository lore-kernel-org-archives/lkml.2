Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564Ab1INJPR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 05:15:17 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:61324 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754450Ab1INJPQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 05:15:16 -0400
MIME-Version: 1.0
In-Reply-To: <s5hk49btrvk.wl%tiwai@suse.de>
References: <20110908144519.GB3069@zhy>
	<4E69253F.3090705@ladisch.de>
	<20110909013143.GB18249@zhy>
	<4E6CCF6C.2020301@ladisch.de>
	<s5hvcsy6nr2.wl%tiwai@suse.de>
	<4E6E061E.2010000@ladisch.de>
	<4E6E6A34.8060104@ladisch.de>
	<s5hvcswvrty.wl%tiwai@suse.de>
	<4E6F1194.80106@ladisch.de>
	<4E6F2159.6060606@ladisch.de>
	<20110914084957.GB23710@zhy>
	<s5hk49btrvk.wl%tiwai@suse.de>
Date: Wed, 14 Sep 2011 17:15:14 +0800
Message-ID: <CAM2zO=BJkSTe1p+cGh++4T14G1ZUMJJnRbUDysoWaDUb_QF4UA@mail.gmail.com>
Subject: Re: [RFC] [PATCH 02/62] mpu401:snd_mpu401_uart_new(): split semantic
 of irq_flags
From: Yong Zhang <yong.zhang0@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Clemens Ladisch <clemens@ladisch.de>, linux-kernel@vger.kernel.org,
        Jaroslav Kysela <perex@perex.cz>, alsa-devel@alsa-project.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 14, 2011 at 5:06 PM, Takashi Iwai <tiwai@suse.de> wrote:
> At Wed, 14 Sep 2011 16:49:57 +0800,
> Yong Zhang wrote:
>>
>> On Tue, Sep 13, 2011 at 11:24:41AM +0200, Clemens Ladisch wrote:
>> [snip]
>> >
>> > completely untested:
>> >
>> > --8<---------------------------------------------------------------->8--
>> > ALSA: mpu401: clean up interrupt specification
>> >
>> > The semantics of snd_mpu401_uart_new()'s interrupt parameters are
>> > somewhat counterintuitive:  To prevent the function from allocating its
>> > own interrupt, either the irq number must be invalid, or the irq_flags
>> > parameter must be zero.  At the same time, the irq parameter being
>> > invalid specifies that the mpu401 code has to work without an interrupt
>> > allocated by the caller.  This implies that, if there is an interrupt
>> > and it is allocated by the caller, the irq parameter must be set to
>> > a valid-looking number which then isn't actually used.
>> >
>> > With the removal of IRQF_DISABLED, zero becomes a valid irq_flags value,
>> > which forces us to handle the parameters differently.
>> >
>> > This patch introduces a new flag MPU401_INFO_IRQ_HOOK for when the
>> > device interrupt is handled by the caller, and makes the allocation of
>> > the interrupt to depend only on the irq parameter.  As suggested by
>> > Takashi, the irq_flags parameter was dropped because, when used, it had
>> > the constant value IRQF_DISABLED.
>>
>> Thanks Clemens. Your patch will eventually save much lines from mine ,
>> actually I only need to touch request_irq() in snd_mpu401_uart_new().
>>
>> But do you have any idea by which tree this patch will go to mainline?
>> Thus I could make a new patch based on it :)
>
> I applied Clemens' patch now to sound git tree.
> The temporary location is:
>        git://github.com/tiwai/sound.git
>
> In general, such cross-tree patches should be based on linux-next,
> which should contain the latest subsystem tree.  But as kernel.org is
> down now, you can check each subsystem tree.

Thanks for your guide, Takashi !

Will refresh my patch based on that.

Thanks,
Yong
