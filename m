Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759599Ab0JYTif (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 15:38:35 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:34449 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759577Ab0JYTie (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 15:38:34 -0400
/m: 
From: Richard Weinberger <richard@nod.at>
To: Andrew Morton <akpm@linux-foundation.org>, xiyou.wangcong@gmail.com
Subject: Re: [PATCH] um: Fix IRQ flag handling naming
Date: Mon, 25 Oct 2010 21:38:26 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.25.20-0.7-pae; KDE/4.4.4; i686; ; )
Cc: linux-kernel@vger.kernel.org, jdike@addtoit.com,
        user-mode-linux-devel@lists.sourceforge.net, dhowells@redhat.com,
        jkosina@suse.cz
References: <1288020273-31161-1-git-send-email-richard@nod.at> <20101025122936.56d0370f.akpm@linux-foundation.org>
In-Reply-To: <20101025122936.56d0370f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010252138.27096.richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag 25 Oktober 2010, 21:29:36 schrieb Andrew Morton:
> On Mon, 25 Oct 2010 17:24:33 +0200
> 
> Richard Weinberger <richard@nod.at> wrote:
> > Commit df9ee292 changed the IRQ flag handling naming scheme
> > and broke UML.
> > This patch brings the new scheme to UML and makes it work again.
> 
> Please always fully describe a bug when fixing it.  Something more than
> "broke".  In the case of compilation errors or warnings, that means
> quoting the compiler error output and, if necessary, the means of
> reproducing it (config, compiler version, etc).

Sorry!
I forgot to add the LKML-Reference to my initial report.

LKML-Reference: <201010190141.10365.richard () nod ! at>
 
> I did an allnoconfig uml build and saw this:
> 
> In file included from /usr/src/25/arch/um/include/asm/fixmap.h:5,
>                  from /usr/src/25/arch/um/include/shared/um_uaccess.h:10,
>                  from /usr/src/25/arch/um/include/asm/uaccess.h:41,
>                  from /usr/src/25/arch/um/include/asm/thread_info.h:13,
>                  from include/linux/thread_info.h:56,
>                  from include/linux/preempt.h:9,
>                  from include/linux/spinlock.h:50,
>                  from include/linux/seqlock.h:29,
>                  from include/linux/time.h:8,
>                  from include/linux/stat.h:60,
>                  from include/linux/module.h:10,
>                  from init/main.c:13:
> /usr/src/25/arch/um/include/asm/system.h:11:1: warning: "local_save_flags"
> redefined
> 
> which I shall assume is the error which this patch addresses.

Yes, this is the error.

Thanks,
//richard
