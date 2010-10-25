Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759585Ab0JYTaT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 15:30:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53206 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759523Ab0JYTaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 15:30:17 -0400
Date: Mon, 25 Oct 2010 12:29:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Richard Weinberger <richard@nod.at>
Cc: linux-kernel@vger.kernel.org, jdike@addtoit.com,
        user-mode-linux-devel@lists.sourceforge.net, dhowells@redhat.com,
        jkosina@suse.cz, jan.kiszka@web.de, xiyou.wangcong@gmail.com
Subject: Re: [PATCH] um: Fix IRQ flag handling naming
Message-Id: <20101025122936.56d0370f.akpm@linux-foundation.org>
In-Reply-To: <1288020273-31161-1-git-send-email-richard@nod.at>
References: <1288020273-31161-1-git-send-email-richard@nod.at>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Oct 2010 17:24:33 +0200
Richard Weinberger <richard@nod.at> wrote:

> Commit df9ee292 changed the IRQ flag handling naming scheme
> and broke UML.
> This patch brings the new scheme to UML and makes it work again.
> 

Please always fully describe a bug when fixing it.  Something more than
"broke".  In the case of compilation errors or warnings, that means
quoting the compiler error output and, if necessary, the means of
reproducing it (config, compiler version, etc).

I did an allnoconfig uml build and saw this:

In file included from /usr/src/25/arch/um/include/asm/fixmap.h:5,
                 from /usr/src/25/arch/um/include/shared/um_uaccess.h:10,
                 from /usr/src/25/arch/um/include/asm/uaccess.h:41,
                 from /usr/src/25/arch/um/include/asm/thread_info.h:13,
                 from include/linux/thread_info.h:56,
                 from include/linux/preempt.h:9,
                 from include/linux/spinlock.h:50,
                 from include/linux/seqlock.h:29,
                 from include/linux/time.h:8,
                 from include/linux/stat.h:60,
                 from include/linux/module.h:10,
                 from init/main.c:13:
/usr/src/25/arch/um/include/asm/system.h:11:1: warning: "local_save_flags" redefined

which I shall assume is the error which this patch addresses.
