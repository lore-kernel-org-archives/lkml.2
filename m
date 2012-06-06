Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758356Ab2FFUaR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 16:30:17 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:9295 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758278Ab2FFUaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 16:30:14 -0400
Message-ID: <1339014612.2763.98.camel@lorien2>
Subject: Re: [PATCH v2] leds: fix led_brightness_set when soft-blinking
From: Shuah Khan <shuahkhan@gmail.com>
Reply-To: shuahkhan@gmail.com
To: Fabio Baltieri <fabio.baltieri@gmail.com>
Cc: shuahkhan@gmail.com, Bryan Wu <bryan.wu@canonical.com>,
        linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org,
        Richard Purdie <rpurdie@rpsys.net>
Date: Wed, 06 Jun 2012 14:30:12 -0600
In-Reply-To: <20120606191149.GA1376@gmail.com>
References: <20120606070008.GA1494@gmail.com>
	 <1338967142-6249-1-git-send-email-fabio.baltieri@gmail.com>
	 <CAK5ve-+gv=83MLAttiq8NYK0d_242UWRjJZftyKHONqMkxWTxQ@mail.gmail.com>
	 <20120606111007.GA1311@gmail.com>
	 <CAK5ve-LrnZQqAi2tamFfdN1_upjGQ=TYgpU-xLXnL+8xRv=+Xw@mail.gmail.com>
	 <20120606191149.GA1376@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I realize now that my last patch broke ledtrig-timer updates as that
> works by passing delay_{on,off} values by pointer, and moving
> led_stop_software_blink() earlier destroy the other value.

Fabio,

This type of interaction is what I am concerned about, and came up
during the transient trigger discussion as well. In the case of
transient trigger it was an easy decision to use separate namespace, but
that doesn't make sense in this case.

> 
> That's a bit of a pitfall, as the old code was working because values
> were copied when entering led_set_software_blink.
> 
> I see three options here:
> - reverting back my leds: "fix led_brightness_set when soft-blinking"
>   (9b05cd0) to the first version I posted, wich should work as before.
> - modify ledtrig-timer to use two internal variables to store delay_on
>   and delay_off instead of the led_cdev ones.

Don't this this is a viable option without restructuring the leds code.
These two variables are common to led_cdev and used by other drivers as
well. ledtrig-timer will still have to store it as these are used in the
led_timer_function() in led-class.c

> - moving the two led_cdev->blink_delay_xx = 0 only into
>   led_brightness_set, as that's the only place when they are needed.

Sounds reasonable. I would like to pull your patches in and do some
testing, but very likely I won't be able to get to it until this
weekend. This is where use-cases will help as well for us go through
various transitions and see if it all comes together.

-- Shuah

