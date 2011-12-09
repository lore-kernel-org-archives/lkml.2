Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751106Ab1LIQCs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 11:02:48 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:62119 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780Ab1LIQCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 11:02:47 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Chris Metcalf <cmetcalf@tilera.com>
Subject: Re: [PATCH] ipc: provide generic compat versions of IPC syscalls
Date: Fri, 9 Dec 2011 16:02:31 +0000
User-Agent: KMail/1.12.2 (Linux/3.2.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "J. Bruce Fields" <bfields@redhat.com>, NeilBrown <neilb@suse.de>
References: <201112091536.pB9Fa5f7002738@farm-0002.internal.tilera.com>
In-Reply-To: <201112091536.pB9Fa5f7002738@farm-0002.internal.tilera.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201112091602.31325.arnd@arndb.de>
X-Provags-ID: V02:K0:wbUynH2Ue2zCMaRUgqakLqLEIxsl45hrSVhTrq+9LtJ
 5TmcsEW+iaDCrz8A9acVninHKuOVmyDskRxpScWhqSVFZiIrOU
 imygq1jaDmG538oWwJ7Vsqg90uJd3MtokJelhDvXzVZGC+X5Yh
 GYbD7Td2BsMEOR82KBHiDA0o8gfr3ShxoMs8sUYMYWkb3QCtnI
 pNcHiQLuInXUaU6zhX/saEi9pfCSoZ50oRjNCky4f2EKpKtIEu
 0R32baTcC5nTylzYPME+X/876o4H44j/RqxAu52qbsu96dKyV2
 HnTuC5rKnlV/TAxHT3iQrdiHEcO9ygrihkAu81BZAW1pLV8p3t
 kHzetGZa5ctwIu0FliUg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 December 2011, Chris Metcalf wrote:
> 
> Several of the existing compat IPC syscalls are really just i386
> compatibility, not generic compatibility.  semctl() expects a
> pointer to the fourth argument, instead of the fourth argument itself.
> msgsnd(), msgrcv() and shmat() expect arguments in different order.
> 
> This change adds an __ARCH_WANT_GENERIC_COMPAT_IPC define that
> can be set in <asm/compat.h> to indicate that the IPC compat code
> should provide exactly the same APIs to "compat" users as the
> regular IPC code does to regular users.  In addition, it sets up
> to always request the IPC_64 mode, since that's what the <asm-generic>
> APIs always use.
> 
> The workaround code in "tile" for msgsnd() and msgrcv() is removed
> with this change; it fixes the bug that shmat() and semctl() were
> not also being properly converted to expect generic compat IPC.
> 
> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>

I like the patch, but I think the __ARCH_WANT_GENERIC_COMPAT_IPC
should be defined as the opposite, so all "old" architectures
have to set it while tile (and future architectures like arm64
and unicore64) just get the default.

> Finding the shmat/semctl bugs in tilegx finally motivated me to go and
> do the thing he suggested 18 months ago. :-)  Whether someone wants to
> go a step further and actually move the i386-ish versions into arch/x86
> I will leave to the x86 platform maintainers; I also don't know whether,
> perhaps, some other platforms are actually using the i386 convention.

I don't see them as x86 specific. We have powerpc, mips, s390, sparc and
x86 using the legacy method, while only parisc and tile get it right
and use the syscalls directly.

	Arnd
