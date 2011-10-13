Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756639Ab1JMSFk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 14:05:40 -0400
Received: from mx3.schottelius.org ([77.109.138.221]:41703 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753417Ab1JMSFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 14:05:38 -0400
X-Greylist: delayed 527 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Oct 2011 14:05:38 EDT
Date: Thu, 13 Oct 2011 19:56:49 +0200
From: Nico Schottelius <nico-linux-20111013@schottelius.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Henrik Rydberg <rydberg@euromail.se>, Nicolas Boichat <nicolas@boichat.ch>,
        Jesper Juhl <jesper.juhl@gmail.com>, Robert Love <rml@novell.com>,
        Nico Schottelius <nico-linux-20111013@schottelius.org>
Subject: AppleSMC: Support inotify on light sensor to adjust keyboard
 backlight
Message-ID: <20111013175649.GB4563@schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-linux-20111013@schottelius.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Henrik Rydberg <rydberg@euromail.se>,
	Nicolas Boichat <nicolas@boichat.ch>,
	Jesper Juhl <jesper.juhl@gmail.com>, Robert Love <rml@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Netzseite: http://www.nico.schottelius.org/
X-System-Info: brief (Linux 3.1.0-rc9-ARCH-00064-g65112dc x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello LKML,

I've written a small utility to adjust the keyboard backlight
on the Mac Book Air 4,2 depending on the information on the light
sensor [0].

Now is my problem that
  /sys/bus/platform/drivers/applesmc/applesmc.768/light
seems not to emit inotify events, if the content changes.
This feature would be great, so I do not need to do a
"while true; sleep X; done"-loop.

As I've no clue about inotify support in kernel, I'd be happy
if someone of you would implement this or else give me a pointer
on how to do so.

Secondly, having this feature for 
  /sys/bus/platform/drivers/applesmc/applesmc.768/leds/smc::kbd_backlight/brightness
as well, might be useful for other tools monitoring the keyboard
backlight brightness.

Cheers,

Nico

[0] http://git.schottelius.org/?p=kbsd;a=summary
    git://git.schottelius.org/kbsd

-- 
PGP key: 7ED9 F7D3 6B10 81D7 0EC5  5C09 D7DC C8E4 3187 7DF0
