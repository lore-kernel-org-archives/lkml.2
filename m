Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836Ab0DMDDl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 23:03:41 -0400
Received: from mail.gmx.net ([213.165.64.20]:48568 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754696Ab0DMDDk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 23:03:40 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1+rVNldpu6reBp5vn0oAdIOYdvVqXY27D8O7Fk+9t
	G5mX9IGCGMz8GV
Message-ID: <4BC3DF05.9060400@gmx.de>
Date: Tue, 13 Apr 2010 05:03:33 +0200
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100328)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>
CC: Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
       Harald Welte <laforge@gnumonks.org>, JosephChan@via.com.tw,
       ScottFang@viatech.com.cn, Deepak Saxena <dsaxena@laptop.org>,
       linux-fbdev-devel@lists.sourceforge.net
Subject: Re: [RFC] Initial OLPC Viafb merge
References: <1270746946-12467-1-git-send-email-corbet@lwn.net>	<4BBEBE87.4000809@gmx.de>	<20100409124626.0b150104@bike.lwn.net>	<4BBFB914.1020600@gmx.de>	<20100409182722.3080bb2d@bike.lwn.net>	<4BBFCE24.2070207@gmx.de> <20100410105241.5df22845@neptune.home>
In-Reply-To: <20100410105241.5df22845@neptune.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.53000000000000003
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bruno Prémont schrieb:
> On Sat, 10 April 2010 Florian Tobias Schandinat <FlorianSchandinat@gmx.de> wrote:
>> Jonathan Corbet schrieb:
>>> Well, if we want to keep s/r out of tree, we can do that.  It will
>>> complicate the merge of the other stuff, since it's got hooks into the
>>> GPIO and camera code too.  But, like everything else I've posted so
>>> far, it's not the work that I personally set out to do.  I can push
>>> that work on others :)

Good news! After some hours of hacking, damaging a filesystem and nearly 
smashing my SD card I've found a promising way to implement suspend and 
resume in viafb based on the first patch of this series. I think this is 
something that can be done for the next merge window. I'll start a clean 
implementation after Jon sent an updated patch series (including the 
initial s&r implementation)

>> At least I'd like some more time (multiple weeks) to have a look at this 
>> issue & patches and try to come up with improvements that make it likely 
>> work on other IGPs and eventually not needing any BIOS/OFW. I agree its 
>> already an improvement but certainly one of the kind I like less as VIA 
>> could come up with such "improvements" too. IMHO it's a bad thing to 
>> push one chipset first if the target is to support all equally well (as 
>> long as the hardware permits).

Goal basically reached:
- likely to work on all IGPs as nothing directly IGP dependent is there
- works without OFW/BIOS

However:
- suspending is very slow, looks like it takes double the time compared 
to before s&r support was added to viafb (this is also with only the 
original patch)
- output device setting is messed up (example: before suspend the output 
was on DVI, after resume on CRT)
- does not restore some values in the mmio but reinitializes it instead. 
Do you need any special values restored, Jon?

> In my case (Commell LE 365) the BIOS offers an option to restore graphics
> to text mode on resume so the manual call of 'fbset -a $MODE' works
> pretty well, only the acceleration has issues.
> I don't remember if accel can get revived with vanilla 2.6.34-rc2 if it
> was disabled before suspend.

Acceleration doesn't work in 2.6.34-rc2 or later after resume (limited 
only to the cursor, the rest works for me). It will work after the 
patches I am going to do are applied.

> When I get time to, I will give these patches a try. A central GIT tree
> where all viafb patches get collected would definitely be nice (even with
> multiple semi-throw-away "topic" branches).

Yes, I guess that would be a good idea at least now where 2 people are 
actively working on viafb. I have also a few minor patches ready I'll 
send in a few days (after having repaired my development environment).


Best regards,

Florian Tobias Schandinat
