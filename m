Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393Ab0D0PpQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 11:45:16 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48267 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754033Ab0D0PpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 11:45:14 -0400
Date: Tue, 27 Apr 2010 11:40:45 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Steve deRosier <steve@cozybit.com>
Subject: Re: linux-next: build warning after merge of the wireless tree
Message-ID: <20100427154043.GA25860@tuxdriver.com>
References: <20100427112842.3eec02a1.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100427112842.3eec02a1.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 27, 2010 at 11:28:42AM +1000, Stephen Rothwell wrote:
> Hi John,
> 
> After merging the wireless tree, today's linux-next build (x86_64 allmodconfig)
> produced these warnings:
> 
> In file included from drivers/net/wireless/libertas_tf/main.c:12:
> drivers/net/wireless/libertas_tf/deb_defs.h:12:1: warning: "pr_fmt" redefined
> In file included from arch/x86/include/asm/percpu.h:44,
>                  from arch/x86/include/asm/current.h:5,
>                  from arch/x86/include/asm/processor.h:15,
>                  from arch/x86/include/asm/thread_info.h:22,
>                  from include/linux/thread_info.h:56,
>                  from include/linux/preempt.h:9,
>                  from include/linux/spinlock.h:50,
>                  from include/linux/mmzone.h:7,
>                  from include/linux/gfp.h:4,
>                  from include/linux/slab.h:12,
>                  from drivers/net/wireless/libertas_tf/main.c:10:
> include/linux/kernel.h:376:1: warning: this is the location of the previous definition
> In file included from drivers/net/wireless/libertas_tf/cmd.c:12:
> drivers/net/wireless/libertas_tf/deb_defs.h:12:1: warning: "pr_fmt" redefined
> In file included from arch/x86/include/asm/percpu.h:44,
>                  from arch/x86/include/asm/current.h:5,
>                  from arch/x86/include/asm/processor.h:15,
>                  from arch/x86/include/asm/thread_info.h:22,
>                  from include/linux/thread_info.h:56,
>                  from include/linux/preempt.h:9,
>                  from include/linux/spinlock.h:50,
>                  from include/linux/mmzone.h:7,
>                  from include/linux/gfp.h:4,
>                  from include/linux/slab.h:12,
>                  from drivers/net/wireless/libertas_tf/cmd.c:10:
> include/linux/kernel.h:376:1: warning: this is the location of the previous definition
> 
> Presumably this is caused by the merge fixup I did that explicitly
> includes linux/slab.h before deb_defs.h.  So you may want to try a
> different merge fix.

Right.  So in wireless-testing I did the includes in the other order
(i.e. "deb_defs.h" first), but that is a bit ugly.  Any suggestions
on alternatives?

"#undef pr_fmt" just before the "#define pr_fmt(fmt)..." line in
db_defs.h seems to eliminate the warning even with the more normal
ordering of the #include lines.  I'm not familiar with the usage of
pr_fmt -- will doing the above preserve the desired effect?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
