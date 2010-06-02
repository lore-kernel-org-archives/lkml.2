Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757700Ab0FBJjf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 05:39:35 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:34459 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932109Ab0FBJjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 05:39:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=AIKmBvG8TroBmfAjGh9YCYhypA5WmRAVNOgKRGOl187wa2JxaKUk8ejq0rZpr2pRx8
         v45GELBDO4QXyGK06SmiK0nD1ukQFNKjsfBdOrJLddltXcSkZLOH7k4Ikmflh7ZA74+N
         XAd6q4x8tFr0dLqBcjcttxq8XecUnpTAOA0dk=
From: Vitaly Mayatskikh <v.mayatskih@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Vivek Goyal <vgoyal@redhat.com>,
       Randy Dunlap <rdunlap@xenotime.net>
Subject: [PATCH 0/5] kdump: extract log buffer and registers from vmcore on NMI button pressing
Date: Wed,  2 Jun 2010 09:39:14 +0200
Message-Id: <1275464359-1566-1-git-send-email-v.mayatskih@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sometimes non-interactive dump capture environment silently fails to
store vmcore due to hardware or software bug. It is hard then to
understand and fix reasons of system failure in both production and
dump capture environments to prevent this failure to reoccur. It would
be quite usefull to see log buffer contents of crashed kernel at
least.

This patchset adds possibility for dump capture mode to extract and
print log buffer and CPU registers from captured vmcore. Also the
state of running kernel is printed. This action can be triggered via
NMI button.

Signed-off-by: Vitaly Mayatskikh <v.mayatskih@gmail.com>

 arch/x86/include/asm/elf.h    |   46 +++++
 arch/x86/include/asm/kdebug.h |    1 +
 arch/x86/include/asm/nmi.h    |    1 +
 arch/x86/kernel/apic/nmi.c    |   27 +++
 arch/x86/kernel/process_32.c  |   22 ++-
 arch/x86/kernel/process_64.c  |   20 ++-
 fs/proc/vmcore.c              |  365 +++++++++++++++++++++++++++++++++++++++--
 include/linux/sysctl.h        |    1 +
 kernel/sysctl.c               |    7 +
 kernel/sysctl_binary.c        |    1 +
 10 files changed, 463 insertions(+), 28 deletions(-)

