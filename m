Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809Ab0DIN36 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 09:29:58 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:58190 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271Ab0DIN35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 09:29:57 -0400
X-Spam-Flag: NO
X-Spam-Score: -14.389
Message-ID: <4BBF2BD1.5050107@tremplin-utc.net>
Date: Fri, 09 Apr 2010 15:29:53 +0200
From: =?ISO-8859-1?Q?=C9ric_Piel?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100331 Mandriva/3.0.4-1mdv2010.1 (2010.1) Thunderbird/3.0.4
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Samu Onkalo <samu.p.onkalo@nokia.com>, Pavel Machek <pavel@ucw.cz>,
       lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
       Marcin Derlukiewicz <marcin@derlukiewicz.pl>
Subject: Re: [PATCH] lis3lv02d: provide means to disable polled input interface
References: <alpine.LNX.2.00.1004091453530.8345@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1004091453530.8345@pobox.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/10 14:56, Jiri Kosina wrote:
> lis3lv02d driver creates emulated joystick interface for events reported 
> by the sensor.
> Because of HW, this has to be implemented as polled input device, with
> 20Hz frequency.
> 
> This is reported to create 20% CPU usage increase (and proportionaly higher
> power consumption) just for the ipolldevd kernel thread (which is used
> to read the sensor).
> 
> As most users probably only use the freefall functionality of the driver
> and not the joystick interface, provide means for disabling the registration
> of joystick device altogether via module parameter.
> (I'd rather make it default to 0, but this will break backwards compatibility).
Are you saying there is a 20% CPU usage even when the joystick interface
is not open? This should not happen (and this is not happening on my
laptop). The polling should happen only when a userspace app opens the
joystick interface (like running neverball).

So I'd tend to think it's more due to a misconfiguration of the system
(like xserver using the joystick interface as a pointer device) or it's
a bug in the way we set up the polling. Could you investigate and let me
know?

Cheers,
Eric
