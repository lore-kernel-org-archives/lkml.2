Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760317Ab2EIWWc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 18:22:32 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58259 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757441Ab2EIWWa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 18:22:30 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1205091818430.1272@file.rdu.redhat.com>
References: <Pine.LNX.4.64.1205091758310.1272@file.rdu.redhat.com>
 <Pine.LNX.4.64.1205091816470.1272@file.rdu.redhat.com> <Pine.LNX.4.64.1205091817170.1272@file.rdu.redhat.com>
 <Pine.LNX.4.64.1205091818160.1272@file.rdu.redhat.com> <Pine.LNX.4.64.1205091818430.1272@file.rdu.redhat.com>
From: Matt Turner <mattst88@gmail.com>
Date: Wed, 9 May 2012 18:22:09 -0400
Message-ID: <CAEdQ38H4MjAGKYW3jbcRs98qKnikPwgN_0k2KWbK8wLmJa8xxQ@mail.gmail.com>
Subject: Re: [PATCH 5/5] PA-RISC: fix compile errors
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: torvalds@linux-foundation.org, linux-parisc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rolf Eike Beer <eike-kernel@sf-tec.de>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 9, 2012 at 6:19 PM, Mikulas Patocka <mpatocka@redhat.com> wrote:
> From: Rolf Eike Beer <eike-kernel@sf-tec.de>
>
> This was defined in asm/pdc.h which needs to include asm/page.h for
> __PAGE_OFFSET. This leads to an include loop so that page.h eventually will
> include pdc.h again. While this is no problem because of header guards, it is
> a problem because some symbols may be undefined. Such an error is this:
>
> In file included from /home/buildbot/repos/linux/include/linux/bitops.h:35:0,
>                 from /home/buildbot/repos/linux/include/asm-generic/getorder.h:7,
>                 from /home/buildbot/repos/linux/arch/parisc/include/asm/page.h:162,
>                 from /home/buildbot/repos/linux/arch/parisc/include/asm/pdc.h:346,
>                 from /home/buildbot/repos/linux/arch/parisc/include/asm/processor.h:16,
>                 from /home/buildbot/repos/linux/arch/parisc/include/asm/spinlock.h:6,
>                 from /home/buildbot/repos/linux/arch/parisc/include/asm/atomic.h:20,
>                 from /home/buildbot/repos/linux/include/linux/atomic.h:4,
>                 from /home/buildbot/repos/linux/include/linux/sysfs.h:20,
>                 from /home/buildbot/repos/linux/include/linux/kobject.h:21,
>                 from /home/buildbot/repos/linux/include/linux/device.h:17,
>                 from /home/buildbot/repos/linux/include/linux/eisa.h:5,
>                 from /home/buildbot/repos/linux/arch/parisc/kernel/pci.c:11:
> /home/buildbot/repos/linux/arch/parisc/include/asm/bitops.h: In function "set_bit":
> /home/buildbot/repos/linux/arch/parisc/include/asm/bitops.h:82:2: error: implicit declaration of function "_atomic_spin_lock_irqsave" [-Werror=implicit-function-declaration]
> /home/buildbot/repos/linux/arch/parisc/include/asm/bitops.h:84:2: error: implicit declaration of function "_atomic_spin_unlock_irqrestore" [-Werror=implicit-function-declaration]
>
> Signed-off-by: Rolf Eike Beer <eike-kernel@xxxxxxxxx>

Email address got eaten?

> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
