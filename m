Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755230Ab0KHVWQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 16:22:16 -0500
Received: from smtp.scorch.co.nz ([27.110.127.199]:48823 "HELO scorch.co.nz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754732Ab0KHVWP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 16:22:15 -0500
X-Virus-Checked: Checked by ClamAV on scorch.co.nz
From: Charles Manning <manningc2@actrix.gen.nz>
To: Chris Snook <chris.snook@gmail.com>
Subject: Re: [PATCH 1/9] Add yaffs Kconfig and Makefile
Date: Tue, 9 Nov 2010 10:22:11 +1300
User-Agent: KMail/1.9.10
Cc: Valdis.Kletnieks@vt.edu, cdhmanning@gmail.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <1288803204-3849-1-git-send-email-cdhmanning@gmail.com> <201011081122.37145.manningc2@actrix.gen.nz> <AANLkTi=m1uq=0dpMxZqMmDnMTMxU09T=Q5eqz+O3uDeC@mail.gmail.com>
In-Reply-To: <AANLkTi=m1uq=0dpMxZqMmDnMTMxU09T=Q5eqz+O3uDeC@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <201011091022.11836.manningc2@actrix.gen.nz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 08 November 2010 23:24:08 Chris Snook wrote:
> On Sun, Nov 7, 2010 at 6:22 PM, Charles Manning <manningc2@actrix.gen.nz> 
wrote:
> > On Monday 08 November 2010 10:45:32 Chris Snook wrote:
> >> On Sun, Nov 7, 2010 at 4:59 PM, Charles Manning
> >> <manningc2@actrix.gen.nz>
> >
> > wrote:
> >> > On Saturday 06 November 2010 14:50:58 Valdis.Kletnieks@vt.edu wrote:
> >> >> On Thu, 04 Nov 2010 05:53:16 +1300, cdhmanning@gmail.com said:
> >> >> > From: Charles Manning <cdhmanning@gmail.com>
> >> >> > +config YAFFS_EMPTY_LOST_AND_FOUND
> >> >> > +   bool "Empty lost and found on boot"
> >> >> > +   depends on YAFFS_FS
> >> >> > +   default n
> >> >> > +   help
> >> >> > +     If this is enabled then the contents of lost and found is
> >> >> > +     automatically dumped at mount.
> >> >>
> >> >> Wow.. Just.. wow.
> >> >
> >> > What does that mean?
> >> >
> >> >> Under what use case is this a good idea for a config
> >> >> option as opposed to a mount option?
> >> >
> >> > It is both.
> >> >
> >> > Providing a config option provides the system integrator with
> >> > flexibility in how they set things up.
> >>
> >> Does the config option override the mount option, or does the mount
> >> option override the config option?
> >
> > Config sets up a default, mount options can override those.
> >
> >> No matter what you do, someone
> >> will be surprised, and that's a bad thing.  I'm having difficulty
> >> imagining a circumstance when you couldn't simply do this in userspace
> >> immediately after mount, but if for whatever reason you need
> >> mount+dump to be an atomic operation,
> >
> > Sure it could be done in user space, but it is easier to handle this in
> > the mount.
>
> We generally try to do things in userspace unless there's a clear
> advantage to doing them in the kernel.  This behavior creates an
> unnecessary special case for file deletion.

This feature was actually requested by one of the major phone players.
Doing this at mount is more efficient and simpler than doing it in start up 
scripts.

>
> >> it *really* should not be
> >> polluting the kernel configuration.
> >
> > Perhaps just make it a mount option.
> >
> >> There are a whole bunch of options in here that appear to be intended
> >> to support various different stages of development.  Is there some
> >> reason why you can't call that mess of permutations YAFFS1, and merge
> >> a clean YAFFS2 patch that doesn't depend on it?
> >
> > You seem to misunderstand what YAFFS1 and YAFFS2 are.
> >
> > Your point is well taken though. Many of these options are "tweaks" that
> > could be dropped form Kconfig and only offered as mount options.
>
> Thanks.  I know we've allowed a lot of stupid Kconfig options in the
> past, but Kconfig bloat is getting to be a real problem.

I'm trying to understand where you see that problem coming from.

I agree fully that there were pollution issues when file systems stored their 
configs in fs/kconfig, making this file a mess.

Is it really a problem to have many configs? Consider:
* All the configs are in fs/yaffs2/Kconfig. They don't clutter a common file.
* If you're not using yaffs2 then the .config only has  "CONFIG_YAFFS_FS is 
not set". Hardly an overhead to non-yaffs users.

I do agree that there are some configs that should be cleaned up/removed, and 
maybe described better. I'll fix that for the next patch set.
.
>
> >> I know that you're
> >> trying to support multiple operating systems with the same codebase,
> >> but once your code is merged it will get patched by other people
> >> making kernel-wide changes, and testing (or even eyeballing) all those
> >> permutations will be far outside the realm of feasibility.
> >
> > To be clear: none of the Kconfig options relate to other OS support.
> >
> > It is my intention to continue to support other OSs and backporting + new
> > features though yaffs.net and patch those into mainstream. While some
> > future changes might make this infeasible, I'll cross that bridge when we
> > get to it. I'm not going to give up yet.
>
> You're a braver man than I, but as long as that doesn't directly
> impact non-YAFFS users/developers, I don't mind.

Thanks for your input.

Charles
