Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759355Ab0FJO62 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 10:58:28 -0400
Received: from 64-131-60-146.usfamily.net ([64.131.60.146]:35650 "EHLO
	mail.sandeen.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753589Ab0FJO61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 10:58:27 -0400
Message-ID: <4C10FD91.4060209@sandeen.net>
Date: Thu, 10 Jun 2010 09:58:25 -0500
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.24 (Macintosh/20100228)
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: Michael Tokarev <mjt@tls.msk.ru>,
       Linux-kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Subject: Re: xfs, 2.6.27=>.32 sync write 10 times slowdown [was: xfs,	aacraid
 2.6.27 => 2.6.32 results in 6 times slowdown]
References: <4C0E13A7.20402@msgid.tls.msk.ru> <20100608122919.GC7869@dastard>	<4C0EA938.9000104@msgid.tls.msk.ru> <20100608231845.GG7869@dastard>	<4C0F3819.4000409@msgid.tls.msk.ru> <20100609074741.GJ7869@dastard>	<4C0FE779.8010603@msgid.tls.msk.ru> <20100610004701.GN7869@dastard>
In-Reply-To: <20100610004701.GN7869@dastard>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Chinner wrote:
> On Wed, Jun 09, 2010 at 11:11:53PM +0400, Michael Tokarev wrote:


>> The same is with -o osyncisosync (in .34).  Actually,
>> osyncis[od]sync mount options does not change anything, not
>> in .32 nor in .34.
> 
> I think only osyncisosync exists, and it doesn't do anything
> anymore.

Just to be pedantic, osyncisdsync "exists," but is deprecated and does
nothing to change defaults:

                } else if (!strcmp(this_char, "osyncisdsync")) {
                        /* no-op, this is now the default */
                        cmn_err(CE_WARN,
        "XFS: osyncisdsync is now the default, option is deprecated.");
                }

huh, didn't realize that osyncisosync does nothing but set a flag that
is never tested other than to show mount options:

  File                  Function      Line
0 xfs_mount.h           <global>      285 #define XFS_MOUNT_OSYNCISOSYNC (1ULL << 13)
1 linux-2.6/xfs_super.c xfs_parseargs 292 mp->m_flags |= XFS_MOUNT_OSYNCISOSYNC;
2 linux-2.6/xfs_super.c xfs_showargs  542 { XFS_MOUNT_OSYNCISOSYNC, "," MNTOPT_OSYNCISOSYNC },

Time to deprecate/remove that one too I guess?

-Eric
 
> Cheers,
> 
> Dave.

