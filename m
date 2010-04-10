Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751596Ab0DJIwz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Apr 2010 04:52:55 -0400
Received: from legolas.restena.lu ([158.64.1.34]:55368 "EHLO
	legolas.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181Ab0DJIwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Apr 2010 04:52:51 -0400
Date: Sat, 10 Apr 2010 10:52:41 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
       Harald Welte <laforge@gnumonks.org>, JosephChan@via.com.tw,
       ScottFang@viatech.com.cn, Deepak Saxena <dsaxena@laptop.org>,
       linux-fbdev-devel@lists.sourceforge.net
Subject: Re: [RFC] Initial OLPC Viafb merge
Message-ID: <20100410105241.5df22845@neptune.home>
In-Reply-To: <4BBFCE24.2070207@gmx.de>
References: <1270746946-12467-1-git-send-email-corbet@lwn.net>
	<4BBEBE87.4000809@gmx.de>
	<20100409124626.0b150104@bike.lwn.net>
	<4BBFB914.1020600@gmx.de>
	<20100409182722.3080bb2d@bike.lwn.net>
	<4BBFCE24.2070207@gmx.de>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 April 2010 Florian Tobias Schandinat <FlorianSchandinat@gmx.de> wrote:
> Jonathan Corbet schrieb:
> > On Sat, 10 Apr 2010 01:32:36 +0200
> > Florian Tobias Schandinat <FlorianSchandinat@gmx.de> wrote:
> > 
> >> Please correct me if I am wrong but the remaining 6 patches concerning 
> >> suspend&resume look like a real big FIXME. So at the end it is expected 
> >> to work only on VX855 and needs something called OFW?
> > 
> > OFW = OpenFirmware.  You could say BIOS instead.  It's pretty normal to
> > expect the BIOS to put things into a semi-rational state at resume time.
> 
> So its more or less the same I always do for testing the module.
> 
> > Well, if we want to keep s/r out of tree, we can do that.  It will
> > complicate the merge of the other stuff, since it's got hooks into the
> > GPIO and camera code too.  But, like everything else I've posted so
> > far, it's not the work that I personally set out to do.  I can push
> > that work on others :)
> > 
> > That said, the suspend/resume support in this patch set makes suspend
> > work on one chipset, and probably comes pretty close on the others
> > without breaking anything there.  I don't see the harm in merging it;
> > it makes the code better than it is now.  I would rather not have to
> > separate it out from the rest.  But I'll not fight over this one; if
> > there's real opposition then we can force OLPC to continue to carry it
> > out of tree.
> 
> At least I'd like some more time (multiple weeks) to have a look at this 
> issue & patches and try to come up with improvements that make it likely 
> work on other IGPs and eventually not needing any BIOS/OFW. I agree its 
> already an improvement but certainly one of the kind I like less as VIA 
> could come up with such "improvements" too. IMHO it's a bad thing to 
> push one chipset first if the target is to support all equally well (as 
> long as the hardware permits).
> So I'd be glad if you could go on with the patches that are less painful 
> and get them ready for the merge window (as I really don't have a clue 
> how long it will take me to get the suspend/resume stuff to a state I 
> consider acceptable). Perhaps we should make suspend and resume a 
> configure option and mark it as experimental?

In my case (Commell LE 365) the BIOS offers an option to restore graphics
to text mode on resume so the manual call of 'fbset -a $MODE' works
pretty well, only the acceleration has issues.
I don't remember if accel can get revived with vanilla 2.6.34-rc2 if it
was disabled before suspend.

When I get time to, I will give these patches a try. A central GIT tree
where all viafb patches get collected would definitely be nice (even with
multiple semi-throw-away "topic" branches).

Thanks,
Bruno
