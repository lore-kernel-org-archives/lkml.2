Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762530Ab2KBARX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 20:17:23 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:59887 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754359Ab2KBART (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 20:17:19 -0400
Message-ID: <5093110D.8000900@zankel.net>
Date: Thu, 01 Nov 2012 17:17:17 -0700
From: Chris Zankel <chris@zankel.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: [PULL REQUEST for 3.7-rc4 - second attempt] xtensa: fix syscall table
 and vfork, and switch to generic thread/execve
References: <509301AF.6000901@zankel.net>
In-Reply-To: <509301AF.6000901@zankel.net>
X-Forwarded-Message-Id: <509301AF.6000901@zankel.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Sorry for the mishap with my previous attempt. I noted the change to use
the git protocol, so it won't happen again (I think I actually used the
wrong one also the past two times). Regarding the invalid tag, I hadn't
pushed the tag up before creating the message, so git-request-pull seems
to have defaulted to the previous tag (or branch name?), and no warning.
I'll verify the tag next time.


Original message:

Would be great if you could pull the Xtensa tree for some important bug
fixes. With the change to uapi, there was a bug introduced that results
in an empty syscall table (mult-inclusion bug). Switching to the generic
thread/execve allowed us to fix a bug we had in vfork().

Thanks,
-Chris

The following changes since commit 6f0c0580b70c89094b3422ba81118c7b959c7556:

  Linux 3.7-rc2 (2012-10-20 12:11:32 -0700)

are available in the git repository at:

  git://github.com/czankel/xtensa-linux.git tags/xtensa-next-20121101

for you to fetch changes up to dc241f2c1761bfdec85915f4bbf7e750663f3442:

  xtensa: switch to generic sys_execve() (2012-10-25 15:00:44 -0700)

----------------------------------------------------------------
Xtensa patchset for 3.7-rc4

----------------------------------------------------------------
Chris Zankel (3):
      xtensa: allow multi-inclusion for uapi/unistd.h
      xtensa: use physical addresses for bus addresses
      xtensa: reset windowbase/windowstart when cloning the VM

Max Filippov (3):
      xtensa: switch to generic kernel_thread()
      xtensa: switch to generic kernel_execve()
      xtensa: switch to generic sys_execve()

 arch/xtensa/Kconfig                   |    2 +
 arch/xtensa/include/asm/io.h          |    4 ++
 arch/xtensa/include/asm/processor.h   |    4 +-
 arch/xtensa/include/asm/syscall.h     |    2 +-
 arch/xtensa/include/asm/unistd.h      |   15 ++--
 arch/xtensa/include/uapi/asm/unistd.h |   16 ++---
 arch/xtensa/kernel/entry.S            |   57 ++++-----------
 arch/xtensa/kernel/process.c          |  128 ++++++++++++++++++---------------
 arch/xtensa/kernel/syscall.c          |    7 +-
 arch/xtensa/kernel/xtensa_ksyms.c     |    1 -
 10 files changed, 104 insertions(+), 132 deletions(-)

