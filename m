Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757678Ab0JRTbm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 15:31:42 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:56471 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754457Ab0JRTbl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 15:31:41 -0400
/m: 
From: Richard Weinberger <richard@nod.at>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [uml-devel] [PATCH 1/1] hostfs: fix UML crash
Date: Mon, 18 Oct 2010 21:31:33 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.25.20-0.7-pae; KDE/4.4.4; i686; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, toralf.foerster@gmx.de,
        jdike@addtoit.com, linux-kernel@vger.kernel.org,
        user-mode-linux-devel@lists.sourceforge.net, viro@zeniv.linux.org.uk
References: <1287419814-20086-1-git-send-email-richard@nod.at> <20101018114039.503233da.akpm@linux-foundation.org> <AANLkTimpmcZEV-V6rhZtJXnXLdtB_HRTxM+ExM-YyWmh@mail.gmail.com>
In-Reply-To: <AANLkTimpmcZEV-V6rhZtJXnXLdtB_HRTxM+ExM-YyWmh@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201010182131.33385.richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag 18 Oktober 2010, 21:22:31 schrieb Geert Uytterhoeven:
> On Mon, Oct 18, 2010 at 20:40, Andrew Morton <akpm@linux-foundation.org> 
wrote:
> > On Mon, 18 Oct 2010 18:36:54 +0200 Richard Weinberger <richard@nod.at> 
wrote:
> >> 365b1818 resized f_spare within struct statfs.
> >> hostfs accesses f_spare directly and needs an update.
> >> 
> >> Signed-off-by: Richard Weinberger <richard@nod.at>
> >> Reported-by: Toralf F__rster <toralf.foerster@gmx.de>
> >> Tested-by: Toralf F__rster <toralf.foerster@gmx.de>
> >> ---
> >>  fs/hostfs/hostfs_user.c |    2 +-
> >>  1 files changed, 1 insertions(+), 1 deletions(-)
> >> 
> >> diff --git a/fs/hostfs/hostfs_user.c b/fs/hostfs/hostfs_user.c
> >> index 6777aa0..ce2f168 100644
> >> --- a/fs/hostfs/hostfs_user.c
> >> +++ b/fs/hostfs/hostfs_user.c
> >> @@ -388,6 +388,6 @@ int do_statfs(char *root, long *bsize_out, long long
> >> *blocks_out, spare_out[1] = buf.f_spare[1];
> >>       spare_out[2] = buf.f_spare[2];
> >>       spare_out[3] = buf.f_spare[3];
> >> -     spare_out[4] = buf.f_spare[4];
> >> +
> >>       return 0;
> >>  }
> > 
> > Thanks.
> > 
> > Is there any reason for hostfs to be playing with the f_spare field at
> > all?
> 
> It just copies it from struct statfs64 on the host to struct kstatfs
> on the guest.
> Probably a memcpy() is more future-safe, if it's combined with a
> BUILD_BUG_ON(sizeof(statfs64.f_spare) != sizeof(kstatfs.f_spare)).
> 
> Still, currently it doesn't copy the recently added f_flags field.
> To protect against future changes like that, an explicit
> BUILD_BUG_ON(sizeof(kstatfs.f_spare) != 4*sizeof(long)) may be even
> better...

Anyway, why do we need to copy f_spare from the host to the guest?
I'm quite sure it can be omitted.

Thanks,
//richard
