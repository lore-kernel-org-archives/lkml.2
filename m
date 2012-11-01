Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762197Ab2KAS7b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 14:59:31 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:47935 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753555Ab2KAS71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 14:59:27 -0400
MIME-Version: 1.0
Date: Thu, 1 Nov 2012 11:59:26 -0700
X-Google-Sender-Auth: 1Fbtk3mRC06Th0zqjd2ezCAgiqY
Message-ID: <CAGXu5jLSA-DKt5BfimH96vOQW23UCgGaWcK9tPxx9+FGWLei2A@mail.gmail.com>
Subject: dropping CONFIG_EXPERIMENTAL (was: warning: (BLK_DEV_RBD && CEPH_FS)
 selects CEPH_LIB which has unmet direct dependencies (NET && INET && EXPERIMENTAL))
From: Kees Cook <keescook@chromium.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Fengguang Wu <fengguang.wu@intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It looks like the drop-experimental patches have started to land in
Linus's tree ahead of schedule (they're queuing up in linux-next[1]
currently). These types of warnings don't happen if the first patch
from my series (that explicitly enables CONFIG_EXPERIMENTAL until all
references are removed) is in the tree.

How would people like to handle this? I could ask Linus to pull the
ceph change to make this specific warning go away, but I'm nervous
that we'll just continue to see one-off problems.

-Kees

[1] http://git.kernel.org/?p=linux/kernel/git/kees/linux.git;a=shortlog;h=refs/heads/linux-next

On Thu, Nov 1, 2012 at 11:27 AM, kbuild test robot
<fengguang.wu@intel.com> wrote:
> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux master
> head:   8c23f406c6d86808726ace580657186bc3b44587
> commit: b8977285ecb0033b0bd9a99d4355f9c0bc8708f1 drivers/block: remove CONFIG_EXPERIMENTAL
> date:   9 days ago
> config: i386-randconfig-b610 (attached as .config)
>
> All warnings:
>
> warning: (BLK_DEV_RBD && CEPH_FS) selects CEPH_LIB which has unmet direct dependencies (NET && INET && EXPERIMENTAL)
> warning: (BLK_DEV_RBD && CEPH_FS) selects CEPH_LIB which has unmet direct dependencies (NET && INET && EXPERIMENTAL)
>
> ---
> 0-DAY kernel build testing backend         Open Source Technology Center
> Fengguang Wu, Yuanhan Liu                              Intel Corporation



-- 
Kees Cook
Chrome OS Security
