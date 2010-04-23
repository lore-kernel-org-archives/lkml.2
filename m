Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752382Ab0DWWkq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 18:40:46 -0400
Received: from mail.gmx.net ([213.165.64.20]:40175 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751656Ab0DWWko (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 18:40:44 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1+/Gp48Ufq/IoPvxI+zh4Z+6fFeuJNadeoiExpZ3+
	IsrBEy08+qZcSn
Message-ID: <4BD221E7.7060705@gmx.de>
Date: Sat, 24 Apr 2010 00:40:39 +0200
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100328)
MIME-Version: 1.0
To: Jonathan Corbet <corbet@lwn.net>
CC: linux-kernel@vger.kernel.org, Harald Welte <laforge@gnumonks.org>,
       Deepak Saxena <dsaxena@laptop.org>, linux-fbdev@vger.kernel.org,
       JosephChan@via.com.tw, ScottFang@viatech.com.cn
Subject: Re: [PATCH 10/11] viafb: rework the I2C support in the VIA framebuffer
 driver
References: <1271614873-5952-1-git-send-email-corbet@lwn.net>	<1271614873-5952-11-git-send-email-corbet@lwn.net>	<4BD20D56.7080402@gmx.de> <20100423155725.7d3b2d2d@bike.lwn.net>
In-Reply-To: <20100423155725.7d3b2d2d@bike.lwn.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.64000000000000001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan Corbet schrieb:
> On Fri, 23 Apr 2010 23:12:54 +0200
> Florian Tobias Schandinat <FlorianSchandinat@gmx.de> wrote:
> 
>> 1. while the module loads the screen shows some strange colours. The 
>> colours itself do not worry me but it probably at least means that the 
>> module load time was increased significantly (2-3 seconds, I guess)
>>
>> 2. most annoyingly after this patch I can no longer get a working VGA 
>> console after unbinding the module. Normally I just do:
> 
> Hmm...compiling the driver as a module is not really something that
> makes sense on the OLPC platform, so I've never done it.
> 
> #1 is weird, there should be nothing there that slows initialization
> down.  Putting in some prints and looking at the timing would be most
> helpful here.

Actually that is probably a mistake on my side. I had the impression 
that it was much longer but didn't take into account that the old 
behaviour allowed the VGA console to work until viafb was completly 
loaded and fbcon took over while the new one immediately destroys the 
screen and shows random things until it is completely loaded. However 
the time between hitting enter for the module load command and getting a 
working fbcon really is at least nearly the same.

> As for #2, I can certainly say that I've never unloaded this code, so
> that's an untested path.  I'll have a look and see if I can see
> anything obvious.

Well as for the behaviour change described above I think the problem 
might be in the load path. At least when I faked an exit as when memory 
size detection or ioremapping fails (which is a very common issue that 
really needs a workaround) I get the same unusable VGA console. This 
needs to be fixed.
This whole I2C stuff seems incredibly unstable I even have indicators 
that the current code might be to blame for freezing the machine on some 
configurations with P4M900 IGP. I just try to prevent it to get even 
worse...


Thanks,

Florian Tobias Schandinat
