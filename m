Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753063Ab2GPIbw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 04:31:52 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60812 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589Ab2GPIbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 04:31:50 -0400
Date: Mon, 16 Jul 2012 09:31:46 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for July 16
Message-ID: <20120716083146.GL31729@ZenIV.linux.org.uk>
References: <20120716171709.a2da2c69fd0052b1a519de65@canb.auug.org.au>
 <20120716074825.GK31729@ZenIV.linux.org.uk>
 <CA+icZUWBPm7wa=cHUwaFQkaVO5rKT39SZHpq68UdD8+HiLfUqQ@mail.gmail.com>
 <CA+icZUV1_QUyBh-PQoFy5jL5ft=neUvVyxx77PhiVgAnOCFUYA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+icZUV1_QUyBh-PQoFy5jL5ft=neUvVyxx77PhiVgAnOCFUYA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 16, 2012 at 09:56:45AM +0200, Sedat Dilek wrote:
> On Mon, Jul 16, 2012 at 9:54 AM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> > On Mon, Jul 16, 2012 at 9:48 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >> On Mon, Jul 16, 2012 at 05:17:09PM +1000, Stephen Rothwell wrote:
> >>> Hi all,
> >>>
> >>> Changes since 20120713:
> >>>
> >>> The ext4 tree lost its build failure.
> >>>
> >>> The vfs tree gained a build failure so I used the version from
> >>> next-20120713.
> >>
> >> Details, please?
> >
> > [1] http://lkml.indiana.edu/hypermail/linux/kernel/1107.2/00046.html
> >
> 
> Grr right subject - wrong email, Stephen's mail seems to be not in the
> offline mail-archives, so I am quoting:
> 
> "Hi Al,
> 
> After merging the vfs tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> fs/ext2/super.c: In function 'ext2_sync_fs':
> fs/ext2/super.c:1191:2: error: implicit declaration of function
> 'dquot_writeback_dquots' [-Werror=implicit-function-declaration]
> fs/ext3/super.c: In function 'ext3_sync_fs':
> fs/ext3/super.c:2534:2: error: implicit declaration of function
> 'dquot_writeback_dquots' [-Werror=implicit-function-declaration]
> fs/ext4/super.c: In function 'ext4_sync_fs':
> fs/ext4/super.c:4493:2: error: implicit declaration of function
> 'dquot_writeback_dquots' [-Werror=implicit-function-declaration]
> 
> Caused by commits 05566b558a47 ("quota: Move quota syncing to ->sync_fs
> method") and ad04033e79d2 ("quota: Split dquot_quota_sync() to writeback
> and cache flushing part").  Please do build testing with and without
> CONFIG QUOTA for quota changes ...

Fixed, folded and pushed...
