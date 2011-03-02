Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886Ab1CBPGS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 10:06:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10524 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750802Ab1CBPGR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 10:06:17 -0500
Date: Wed, 2 Mar 2011 16:06:07 +0100
From: Karel Zak <kzak@redhat.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: linux-kernel@vger.kernel.org, t.artem@mailcity.com,
        Roman Zippel <zippel@linux-m68k.org>
Subject: Re: MS_SILENT vs. vfat and hfs
Message-ID: <20110302150607.GD14636@nb.net.home>
References: <20110302114517.GA496@nb.net.home> <87d3m9r4mz.fsf@devron.myhome.or.jp> <20110302144303.GC14636@nb.net.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110302144303.GC14636@nb.net.home>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 02, 2011 at 03:43:03PM +0100, Karel Zak wrote:
> On Wed, Mar 02, 2011 at 11:14:28PM +0900, OGAWA Hirofumi wrote:
> > Karel Zak <kzak@redhat.com> writes:
> > 
> > >  The mount(8) command uses "quiet" mount option as a synonym to the
> > >  MS_SILENT mount flag (since util-linux 2.7, Aug 1997).
> > >
> > >  It means than on systems where is properly defined the MS_SILENT
> > >  mount flags in headers is the "quiet" mount option always translated
> > >  to the MS_SILENT mount flags and "quiet" string is never send to FS
> > >  drivers.
> > >
> > >    $ strace -e mount mount -o quiet /dev/sdb1 /mnt/test
> > >    mount("/dev/sdb1", "/mnt/test", "vfat", MS_MGC_VAL|MS_SILENT, NULL) = 0
> > >                                                       ^^^^^^^^^
> > >
> > >  Unfortunately, 
> > >  
> > >    $ grep -r \"quiet\" *
> > >
> > >    fat/inode.c:    {Opt_quiet, "quiet"},
> > >    hfs/super.c:    { opt_quiet, "quiet" },
> > >
> > >  vfat and hfs drivers use "quiet" as a mount option. That's bug.
> > >
> > >  There should not be a collision between mount(8) mount options and
> > >  filesystem specific mount options.
> > >
> > >  My suggestion is to fix the fat and hfs code to use something other
> > >  than "quiet" (shutup, noisless, ...). I think you don't have to care
> > >  about backward compatibility, because it's probably broken for years.
> > 
> > No. Actually the _new_ option is MS_SILENT. In history, there was no
> > MS_SILENT (it was called MS_VERBOSE) in kernel, then _added_ newly, and
> > never be enabled MS_SILENT in mount command until that.
> 
>  I know, but I don't care which option is newer. I'd like to found a
>  solution with minimal impact to users.
> 
> > So, my suggestion is use "silent" (or something) as MS_SILENT for
> > backward compatibility. Because the "quiet" is already hardcoded by some
> > userland apps for vfat.
> 
>  Then all people who use "quiet" in their fstab will see problems...

 I'll probably add an exception for vfat and hfs to mount(8), "silent"
 as MS_SILENT and mark "quiet" as deprecated for non-fat filesystems.

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com
