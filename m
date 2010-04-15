Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757221Ab0DOVTm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 17:19:42 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:50976 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756800Ab0DOVTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 17:19:41 -0400
X-Spam-Flag: NO
X-Spam-Score: -22.589
Message-ID: <4BC782E5.7070900@tremplin-utc.net>
Date: Thu, 15 Apr 2010 23:19:33 +0200
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <Eric.Piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.21) Gecko/20090319 Mandriva/2.0.0.21-1mdv2009.1 (2009.1) Thunderbird/2.0.0.21 Mnenhy/0.7.6.666
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Jaroslav Kysela <perex@perex.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       alsa-devel@alsa-project.org, Frank Griffin <ftg@roadrunner.com>
Subject: Re: [REGRESSION bisected] Sound goes too fast due to commit 7b3a177b0
References: <4BC4E812.6050602@tremplin-utc.net>	<s5h633u5zx1.wl%tiwai@suse.de>	<4BC5A566.8060106@tremplin-utc.net> <s5hy6gqvx9n.wl%tiwai@suse.de>
In-Reply-To: <s5hy6gqvx9n.wl%tiwai@suse.de>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 14-04-10 18:01, Takashi Iwai schreef:
:
>>
>> I don't fully grasp the meaning of bdl_pos_adj, so I don't know if it's
>> a bug to not play correctly when forcing it to 0. Is it?
> 
> It might be that this was for reducing the load by position
> correction mechanism.  You might see the hd-audio kernel thread in a
> high CPU usage.  This might be fixed also by position_fix=1, though. 
Yes, I had added this option after a regression in the previous kernel
which causes the hd-audio thread to take 50% of a CPU. Eventually, it
was fixed and not needed anymore. So I guess in the case of my laptop,
this is not really a regression, because everything is fine with the
default values.

In the case of Frank, this looks more like a regression, or at least a
bug to solve, because this happens with the default options. However,
this report should be taken with care, because this happens on a
2.6.33.2 kernel made by Mandriva, containing many alsa patches of
2.6.34. Frank, how possible would it be to test a 2.6.34-rc4 kernel from
Linus?

If this bug is confirmed, Takashi, do you know any way to choose
automatically position_fix=1 when needed?

See you,
Eric
