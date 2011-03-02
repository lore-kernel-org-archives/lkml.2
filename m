Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754271Ab1CBOhh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 09:37:37 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:46371 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753313Ab1CBOhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 09:37:36 -0500
X-Greylist: delayed 1382 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Mar 2011 09:37:35 EST
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Karel Zak <kzak@redhat.com>
Cc: linux-kernel@vger.kernel.org, t.artem@mailcity.com,
        Roman Zippel <zippel@linux-m68k.org>
Subject: Re: MS_SILENT vs. vfat and hfs
References: <20110302114517.GA496@nb.net.home>
Date: Wed, 02 Mar 2011 23:14:28 +0900
In-Reply-To: <20110302114517.GA496@nb.net.home> (Karel Zak's message of "Wed,
	2 Mar 2011 12:45:17 +0100")
Message-ID: <87d3m9r4mz.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Karel Zak <kzak@redhat.com> writes:

>  The mount(8) command uses "quiet" mount option as a synonym to the
>  MS_SILENT mount flag (since util-linux 2.7, Aug 1997).
>
>  It means than on systems where is properly defined the MS_SILENT
>  mount flags in headers is the "quiet" mount option always translated
>  to the MS_SILENT mount flags and "quiet" string is never send to FS
>  drivers.
>
>    $ strace -e mount mount -o quiet /dev/sdb1 /mnt/test
>    mount("/dev/sdb1", "/mnt/test", "vfat", MS_MGC_VAL|MS_SILENT, NULL) = 0
>                                                       ^^^^^^^^^
>
>  Unfortunately, 
>  
>    $ grep -r \"quiet\" *
>
>    fat/inode.c:    {Opt_quiet, "quiet"},
>    hfs/super.c:    { opt_quiet, "quiet" },
>
>  vfat and hfs drivers use "quiet" as a mount option. That's bug.
>
>  There should not be a collision between mount(8) mount options and
>  filesystem specific mount options.
>
>  My suggestion is to fix the fat and hfs code to use something other
>  than "quiet" (shutup, noisless, ...). I think you don't have to care
>  about backward compatibility, because it's probably broken for years.

No. Actually the _new_ option is MS_SILENT. In history, there was no
MS_SILENT (it was called MS_VERBOSE) in kernel, then _added_ newly, and
never be enabled MS_SILENT in mount command until that.

So, my suggestion is use "silent" (or something) as MS_SILENT for
backward compatibility. Because the "quiet" is already hardcoded by some
userland apps for vfat.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
