Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758313Ab0DPMGu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 08:06:50 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:42758 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756225Ab0DPMGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 08:06:49 -0400
X-Spam-Flag: NO
X-Spam-Score: -14.389
Message-ID: <4BC852CD.40406@tremplin-utc.net>
Date: Fri, 16 Apr 2010 14:06:37 +0200
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100331 Mandriva/3.0.4-1mdv2010.1 (2010.1) Thunderbird/3.0.4
MIME-Version: 1.0
To: Marcin Derlukiewicz <marcin@derlukiewicz.pl>
CC: Jiri Kosina <jkosina@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       Samu Onkalo <samu.p.onkalo@nokia.com>, Pavel Machek <pavel@ucw.cz>,
       lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lis3lv02d: provide means to disable polled input interface
References: <alpine.LNX.2.00.1004091453530.8345@pobox.suse.cz> <4BBF2BD1.5050107@tremplin-utc.net> <alpine.LNX.2.00.1004091532150.8345@pobox.suse.cz> <op.va86rulwgp7y00@linux-r26l.site>
In-Reply-To: <op.va86rulwgp7y00@linux-r26l.site>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/04/10 13:41, Marcin Derlukiewicz wrote:
:
> sorry for the delay, had a crunch time
> 
> here is the link for this lsof:
> https://bugzilla.novell.com/attachment.cgi?id=354953
So apparently, it's opened by mplayer. Indeed, by default mplayer always
opens the first joystick device, because some people like to  control a
movie with a joystick.

I don't think much can be done from the kernel point of view. Maybe
there are even people who enjoy controlling their movies by moving their
laptop! Here, my ~/.mplayer/config looks like:
[default]
input=js-dev=/dev/input/js8

You could also put a udev rule to change the name of this joystick to
something like js1.

All I could think of in the kernel side to improve this situation would
be to give more information about joystick devices, and define a subtype
"accelerometer", which mplayer could avoid selecting by default. I don't
know enough the input interface to know if this already exists...

See you,
Eric

