Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756666Ab2JEQIK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 12:08:10 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:45267 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756151Ab2JEQIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 12:08:09 -0400
MIME-Version: 1.0
In-Reply-To: <20121001213809.GA31155@ZenIV.linux.org.uk>
References: <20121001213809.GA31155@ZenIV.linux.org.uk>
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Fri, 5 Oct 2012 17:07:47 +0100
X-Google-Sender-Auth: poqSO7nuFhgHjpZrzOUqlVTEdno
Message-ID: <CAHkRjk6oaZh643hciXyVbvq74KTWgZjfKhyZW1gi8oNEMw3h-A@mail.gmail.com>
Subject: Re: [RFC][CFT][CFReview] execve and kernel_thread unification work
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-arch@vger.kernel.org, David Miller <davem@davemloft.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al,

On 1 October 2012 22:38, Al Viro <viro@zeniv.linux.org.uk> wrote:
>         Right now the tree lives in
> git.kernel.org/pub/scm/linux/kernel/git/viro/signal experimental-kernel_thread
> Some of that had been in -next for a while.
>
>         Folks, help with review, testing and filling the missing bits, please.

I tested this branch with the arm64 kernel and runs ok (I get couple
of compiler warnings because reparent_to_kthread and
__set_special_pids are no longer used with the removal of daemonize).

I have three arm64 patches on this branch:

git://git.kernel.org/pub/scm/linux/kernel/git/cmarinas/linux-aarch64.git execve

Catalin Marinas (3):
      arm64: Use generic kernel_thread() implementation
      arm64: Use generic kernel_execve() implementation
      arm64: Use generic sys_execve() implementation

 arch/arm64/Kconfig                 |    1 +
 arch/arm64/include/asm/processor.h |    5 --
 arch/arm64/include/asm/syscalls.h  |    3 -
 arch/arm64/include/asm/unistd.h    |    3 +
 arch/arm64/kernel/entry.S          |   28 ++++++++++---
 arch/arm64/kernel/process.c        |   78 +++++++++++------------------------
 arch/arm64/kernel/sys.c            |   65 ------------------------------
 arch/arm64/kernel/sys32.S          |    7 +---
 arch/arm64/kernel/sys_compat.c     |   18 --------
 9 files changed, 52 insertions(+), 156 deletions(-)

-- 
Catalin
