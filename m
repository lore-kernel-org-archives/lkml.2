Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934049Ab2C3AeJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 20:34:09 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:43801 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933574Ab2C3AeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 20:34:05 -0400
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <CAOesGMgaQ7mjV-1Q5uPthw8PAtU+BUfDgOqor=3jtvkL30L1ZA@mail.gmail.com>
References: <1332918842-13521-1-git-send-email-olof@lixom.net>
	<1332918842-13521-2-git-send-email-olof@lixom.net>
	<20120328082501.GA22414@n2100.arm.linux.org.uk>
	<CAOesGMjwZOON9kFNvaEq8QhSvjAgsJT_J1Ysb9-AbePd6g+-rQ@mail.gmail.com>
	<20120328192816.GD22414@n2100.arm.linux.org.uk>
	<CA+55aFyJH8yO7=AzuddsQZouHqRDtmeh-vbd8Y5VQLQx-6ZV-Q@mail.gmail.com>
	<CAOesGMgaQ7mjV-1Q5uPthw8PAtU+BUfDgOqor=3jtvkL30L1ZA@mail.gmail.com>
Date: Thu, 29 Mar 2012 17:34:04 -0700
Message-ID: <CAOesGMj4Osx0KBCxM4_N09PMTkpTdhhQRvEcwEeY8PFKanT_-w@mail.gmail.com>
Subject: Re: [GIT PULL 1/5] ARM: cleanups of io includes
From: Olof Johansson <olof@lixom.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>, arm@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 29, 2012 at 5:27 PM, Olof Johansson <olof@lixom.net> wrote:

> It hasn't grown any new merge conflicts
> since before as of now, so see the original pull request for those.

D'oh, I did a git remote update but didn't checkout the new head for
your tree when I verified the merge conflict situation. It does have a
couple of new trivial ones:

* arch/arm/mach-tegra/Makefile: keep reset.o, remove localtimer.o
* arch/arm/mach-vexpress/include/mach/io.h: line remove vs file remove
conflict: file is gone, but a patch in rmk's tree had removed a line
from it. It's safe to still remove the file.

+ the previous ones from original pull request:

arch/arm/Kconfig: New selects added for ARCH_S3C24X. Include both
sides of the merge.

arch/arm/mach-shmobile/smp-sh73a0.c: A readl vs readw fix collided
with the io accessor cleanup. Ditch the __io() use but keep readl.

arch/arm/mach-tegra/include/mach/debug-macro.S: include of mach/io.h
is going away, iomap.h is kept.

-Olof
