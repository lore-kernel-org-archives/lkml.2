Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129Ab0JWCno (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 22:43:44 -0400
Received: from mail.wdtv.com ([66.118.69.84]:39825 "EHLO mail.wdtv.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755293Ab0JWCnn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 22:43:43 -0400
From: Gene Heskett <gene.heskett@gmail.com>
To: Ken Moffat <zarniwhoop@ntlworld.com>
Subject: Re: 2.6.36, make oldconfig broken
Date: Fri, 22 Oct 2010 22:43:37 -0400
User-Agent: KMail/1.13.5 (Linux/2.6.36; KDE/4.5.2; i686; ; )
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>
References: <201010221229.36996.gene.heskett@gmail.com> <201010222054.52066.gene.heskett@gmail.com> <20101023013943.GB20750@deepthought>
In-Reply-To: <20101023013943.GB20750@deepthought>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201010222243.37890.gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, October 22, 2010, Ken Moffat wrote:
>On Fri, Oct 22, 2010 at 08:54:51PM -0400, Gene Heskett wrote:
>> It hasn't been edited since I ran it, so I'll attach it.  Maybe you can
>> see something I missed.
>
>Hi Gene,
>
> I don't see anything that is immediately wrong (but, it's late and
>I'll be going to bed as soon as webkit has finished compiling on my
>desktop, so my concentration might be lacking), but it does seem
>overly complex.  I've long since given up trying to script kernel
>builds, it mostly isn't necessary if you aren't creating a distro.
>
> I appreciate your comment about fingers - mine are mostly ok, but
>prone to operating in the wrong order so that I often generate typos
>such as 'teh'.  What works for me is -
>
Damn, and I thought I had a patent on that. Or at least prior art? ;)

>1. build in ~/ : I often have current and "previous, but still
>usable" systems on the same machine, and I share /home between them.
>Arguably, building as a user may prevent some disastrous actions,
>but backups are always useful - I remember your past comments about
>using amanda so I'm sure you've already got that covered.
>
>2. for each kernel version of interest (typically, current and next
>- over time the old one drops out and a new one rolls in) :
> create a first version (untar, or untar and patch).
> I then rename it to 2.6.xx-stable or 2.6.xx-rc.
>
> For the patches I use
>bzcat /path/to/patch-2.6.whatever.bz2 | patch -p1
>(yes, send me tickets for "useless uses of cat" if you wish ;)

Noted.  ;)  But then I also use another script to drive the make and 
install, with everything in it having an ' && \' at the end of the lines so 
any error bails out right there leaving the message still on-screen

Its a bit longer as I've hacked around to ensure continuity over the years 
of the firmware trees etc.  I can post that too if anyone wants it.

>3. When I want to test a new -rc, or a release has come out, cd into
>the tree and
> head Makefile
>to confirm which (-rc) patch was last applied.
>revert that: bzcat /path/to/that-patch.bz2 | patch -p1 -R
>apply the new one
>
>and then just make oldconfig and continue (or, for the first rc of a
>new version, zcat /proc/config.gz >.config && make oldconfig.
>
> To keep track of errant fingers, you can read the commandline
>before hitting <enter>, you can also run 'make modules_install' as a
>user - it won't work, but it will confirm which version it is trying
>to install.
>
> Sorry if this comes across as trying to teach you things you
>already know, but the process should be simple enough to not need
>scripting!  Of course, my video hardware doesn't need out-of-tree
>firmware nor other drivers.  Perhaps in that situation I might try
>to script it all.  From painful experience, the usual problem with
>scripts is a failure to detect errors or unexpected results.  Keep
>things simple if you can.

I use the scripts, which of course are subject to internal revision if it 
proves I am not doing it right, as a way to get absolute consistency.  For 
the makeit script, it has only one var, $VER, assigned at the top to be the 
2.6.whatever its building.  All I have to do if it runs to completion is 
construct a new entry in /boot/grub/menu.lst. change the default and 
reboot.

Otherwise I'd forget (senor moment ;) some step in the middle and wind up 
needing more naproxin sodium to quell the headache I got from beating it on 
the wall....

>ken

Ken may have a point, next time I reboot, I'll drag out an install cd and 
run the memtest from it for at least 1 full cycle.

Another item I might add is that I have now tried several different number 
formats for the kernel command line option vga=, trying std octal, std 
0xhex, and plain decimal, but it always hangs like I'd entered vga=ask.
The boot continues normally in the selected 1680x1050x32 screen if I enter 
either a 'z' or a '369' at that point.  So something seems to be preventing 
the vga= from working correctly as a command line argument.  Who knows, 
maybe there is a bad address line on one of the 4 sticks again and it hits 
that exact address at each boot.  Murphy again, darn him.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Old soldiers never die.  Young ones do.
