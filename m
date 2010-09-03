Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756587Ab0ICJ2K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 05:28:10 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40014 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755849Ab0ICJ2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 05:28:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=CLWH1S0GNolsJyruPP/0wa1wxpTl7PWi7LoFjSrPYojfHDlwcCLyV96d7av4KX6a7I
         ZSsf+Te1squn97F4evRAwlsw12Hx1sJBFmIN+vAQHIXVvvAz9ZzIvWwK7aGwRx5wWGC9
         ZiITvrvmw8kmsSNKGDX81e07wDwrZrwlGmouk=
Date: Fri, 3 Sep 2010 11:27:59 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Subject: [PATCH 0/2] [RFC] posix clock tuning
Message-ID: <cover.1283504065.git.richard.cochran@omicron.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recently on the lkml, we discussed how to allow adjustment of posix
clocks. I have tried to understand and implement the ideas expressed
in the various threads.

If there is agreement on this approach, I will resubmit these two
patches as part of a longer series, including support for a new kind
of hardware clock, so you can see how it all fits together. But first,
I would like to concentrate on the new syscall itself.

The patches are against a recent net-next tree. Please don't worry if
the syscall tables are not quite up to date. I can fix that later.

Thanks,
Richard


Richard Cochran (2):
  posix clocks: introduce a syscall for clock tuning.
  posix clocks: introduce a sysfs presence.

 Documentation/ABI/testing/sysfs-timesource |   24 +++++
 arch/arm/include/asm/unistd.h              |    1 +
 arch/arm/kernel/calls.S                    |    1 +
 arch/blackfin/include/asm/unistd.h         |    3 +-
 arch/blackfin/mach-common/entry.S          |    1 +
 arch/powerpc/include/asm/systbl.h          |    1 +
 arch/powerpc/include/asm/unistd.h          |    3 +-
 arch/x86/ia32/ia32entry.S                  |    1 +
 arch/x86/include/asm/unistd_32.h           |    3 +-
 arch/x86/include/asm/unistd_64.h           |    2 +
 arch/x86/kernel/syscall_table_32.S         |    1 +
 drivers/char/mmtimer.c                     |    1 +
 include/linux/posix-timers.h               |   14 +++-
 include/linux/syscalls.h                   |    2 +
 include/linux/time.h                       |    2 +
 include/linux/timex.h                      |    3 +-
 kernel/compat.c                            |  136 ++++++++++++++++++----------
 kernel/posix-cpu-timers.c                  |    6 ++
 kernel/posix-timers.c                      |   98 +++++++++++++++++++--
 19 files changed, 243 insertions(+), 60 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-timesource

