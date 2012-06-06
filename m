Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758041Ab2FFTKQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 15:10:16 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:54334 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756979Ab2FFTKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 15:10:13 -0400
Date: Wed, 6 Jun 2012 21:11:49 +0200
From: Fabio Baltieri <fabio.baltieri@gmail.com>
To: Bryan Wu <bryan.wu@canonical.com>
Cc: linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org,
        Richard Purdie <rpurdie@rpsys.net>
Subject: Re: [PATCH v2] leds: fix led_brightness_set when soft-blinking
Message-ID: <20120606191149.GA1376@gmail.com>
References: <20120606070008.GA1494@gmail.com>
 <1338967142-6249-1-git-send-email-fabio.baltieri@gmail.com>
 <CAK5ve-+gv=83MLAttiq8NYK0d_242UWRjJZftyKHONqMkxWTxQ@mail.gmail.com>
 <20120606111007.GA1311@gmail.com>
 <CAK5ve-LrnZQqAi2tamFfdN1_upjGQ=TYgpU-xLXnL+8xRv=+Xw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK5ve-LrnZQqAi2tamFfdN1_upjGQ=TYgpU-xLXnL+8xRv=+Xw@mail.gmail.com>
X-Operating-System: Linux balto-eee 3.5.0-rc1-balto-eee-00011-gd17d20b
 GNU/Linux
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bryan,

On Wed, Jun 06, 2012 at 10:10:23PM +0800, Bryan Wu wrote:
> Yeah, that's right. Rafal's patch was in my fixes-for-3.5 branch, I
> will send out by this week for Linus. So I have to rebase all the
> for-next patches on top of it. Although I got conflicts, I will fix
> that. I prepared a new branch merged for-next and fixes-for-3.5
> together name devel, please help to test.
> 
> http://git.kernel.org/?p=linux/kernel/git/cooloney/linux-leds.git;a=shortlog;h=refs/heads/devel

I realize now that my last patch broke ledtrig-timer updates as that
works by passing delay_{on,off} values by pointer, and moving
led_stop_software_blink() earlier destroy the other value.

That's a bit of a pitfall, as the old code was working because values
were copied when entering led_set_software_blink.

I see three options here:
- reverting back my leds: "fix led_brightness_set when soft-blinking"
  (9b05cd0) to the first version I posted, wich should work as before.
- modify ledtrig-timer to use two internal variables to store delay_on
  and delay_off instead of the led_cdev ones.
- moving the two led_cdev->blink_delay_xx = 0 only into
  led_brightness_set, as that's the only place when they are needed.

What you think about it?

I think the third option is the best, as it removes the pitfall and
simplify the code a bit.  I'll post that as a v3 "fix led_brightness_set
when soft-blinking", would you consider replacing the last patch you
applied in the new branch with the v3?

Fabio
