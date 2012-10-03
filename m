Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756728Ab2JCWd6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 18:33:58 -0400
Received: from awesome.dsw2k3.info ([195.71.86.230]:36738 "EHLO
	awesome.dsw2k3.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756633Ab2JCWd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 18:33:57 -0400
X-Greylist: delayed 610 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Oct 2012 18:33:57 EDT
Date: Thu, 4 Oct 2012 00:23:41 +0200
From: Matthias Schniedermeyer <ms@citd.de>
To: Kees Cook <kees@outflux.net>
Cc: Nick Bowler <nbowler@elliptictech.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.6
Message-ID: <20121003222341.GA20263@citd.de>
References: <CA+55aFw1Y5_HtfXh+-OEQ2KGpW0N18kA4O3R7=cv29_CaF+3UQ@mail.gmail.com>
 <20121003194614.GA2893@elliptictech.com>
 <20121003200515.GZ9092@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121003200515.GZ9092@outflux.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03.10.2012 13:05, Kees Cook wrote:
> Hi Nick,
> 
> 3.6 introduced link restrictions:
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commitdiff;h=800179c9b8a1e796e441674776d11cd4c05d61d7
> 
> It sounds like you've got symlinks in a world-writable directory, and
> you're following those symlinks across mis-matched uids. You can either
> have the symlinks be owned by the directory owner, or you can turn off
> symlink restrictions in sysctl:
> 
> # echo 0 > /proc/sys/fs/protected_symlinks

According to documentation world writable isn't the problem.
It's world writable inside/or below a directory with sticky bit.
(Documentation/sysctl/fs.txt -> protected_symlinks)

So /scratch_space must have the sticky bit set.
Question is: Why?


Personally i would have been bitten by this change, because for years i 
have used a symlink in /tmp (which has the sticky bit) to a directory 
somewhere else for historical reasons. But as i was aware of this change 
i fixed my system before booting the new kernel.


> On Wed, Oct 03, 2012 at 03:46:14PM -0400, Nick Bowler wrote:
> > On 2012-09-30 17:38 -0700, Linus Torvalds wrote:
> > > So here it is, 3.6 final. Sure, I'd have been happier with even fewer
> > > changes, but that just never happens. And holding off the release
> > > until people get too bored to send me the small stuff just makes the
> > > next merge window more painful.
> > 
> > Just upgraded to 3.6 from 3.5, and now some of my kernel build scripts
> > are throwing "permission denied" errors.  Apparently symlinks are
> > broken somehow?
> > 
> >   # id
> >   uid=0(root) gid=0(root) groups=0(root),1(bin),2(daemon),3(sys),4(adm),6(disk),10(wheel),11(floppy),20(dialout),26(tape),27(video)
> > 
> >   # ls -l /scratch_space/linux
> >   drwxr-xr-x 24 nbowler eng 4096 2012-10-03 13:41 /scratch_space/linux
> > 
> >   # readlink /scratch_space/linux-2.6
> >   linux
> > 
> >   # cd /scratch_space/linux
> >   # pwd
> >   /scratch_space/linux
> > 
> >   # cd /scratch_space/linux-2.6
> >   cd: permission denied: /scratch_space/linux-2.6
> > 
> > WTF?  3.5 is fine.  I will try to bisect this later, but I figured I'd
> > throw this out there now in case anyone has any ideas...






Bis denn

-- 
Real Programmers consider "what you see is what you get" to be just as 
bad a concept in Text Editors as it is in women. No, the Real Programmer
wants a "you asked for it, you got it" text editor -- complicated, 
cryptic, powerful, unforgiving, dangerous.

