Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759115Ab1FWJO4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 05:14:56 -0400
Received: from webbox687.server-home.net ([195.149.74.151]:46577 "EHLO
	webbox687.server-home.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758923Ab1FWJOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 05:14:54 -0400
From: Alexander Stein <alexander.stein@systec-electronic.com>
To: guenter.roeck@ericsson.com
Subject: Re: [PATCH] hwmon: LM95245 driver
Date: Thu, 23 Jun 2011 11:14:52 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.38-gentoo-r6; KDE/4.6.3; x86_64; ; )
Cc: Jean Delvare <khali@linux-fr.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1308649953-2774-1-git-send-email-alexander.stein@systec-electronic.com> <1308770149.8271.600.camel@groeck-laptop>
In-Reply-To: <1308770149.8271.600.camel@groeck-laptop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201106231114.52841.alexander.stein@systec-electronic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 22 June 2011 21:15:49 Guenter Roeck wrote:
> On Tue, 2011-06-21 at 05:52 -0400, Alexander Stein wrote:
> > An hwmon driver for the National Semiconductor LM95245 dual temperature
> > sensors chip.
> > 
> > Signed-off-by: Alexander Stein <alexander.stein@systec-electronic.com>
> 
> Overall pretty well written, only I am a bit at loss why you try to deal
> with the unsigned temperature registers. That adds a bit of complexity
> to the driver. Given that the signed temperature value range is up to
> 127 degrees C, and that the chip is only rated up to 125 degrees C, the
> added complexity doesn't seem to be worth it.
> 
> Can you elaborate ?

Well, AFAIK the 125 degrees C limit is for the chip itself. I didn't found 
anything about a remote diode limit. Also the remote TCRIT and OS limit range 
up to 255 degrees C.
Another point is the optional offset register (not implemented, see below). I 
could not found much about it, but I guess this is immediately added to the 
remote temperature register.

> Other comments:
> 
> For the interval attribute, idea would be to write the value into the
> conversion rate register. Your code does not match the interval with the
> rate programmed into the chip (which is the idea), nor does it update
> the rate if the interval is changed.

Well, I noticed that. But I went the way lm95241 does. I'm also unsure which 
interval to choose, if user specify a unsupported interval. Choose the next 
small or the next greater one? Maybe you can give me a hint here.

> Chip address 0x29 is missing.

Nice catch.

> It would be nice if the driver would support limit, hysteresis, alarm,
> and fault attributes.

Let's see if I find time for that.
Thanks for the review though.

Regards,
Alexander
