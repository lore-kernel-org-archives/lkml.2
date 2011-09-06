Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753767Ab1IFSIa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 14:08:30 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:34773 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753542Ab1IFSI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 14:08:27 -0400
Date: Tue, 6 Sep 2011 15:08:19 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -rt] sched: teach migrate_disable about atomic contexts
Message-ID: <20110906180819.GA5365@ghostprotocols.net>
References: <1314967297.1301.14.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314967297.1301.14.camel@twins>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Sep 02, 2011 at 02:41:37PM +0200, Peter Zijlstra escreveu:
> Subject: sched: teach migrate_disable about atomic contexts
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Fri Sep 02 14:29:27 CEST 2011
> 
>  <NMI>  [<ffffffff812dafd8>] spin_bug+0x94/0xa8
>  [<ffffffff812db07f>] do_raw_spin_lock+0x43/0xea
>  [<ffffffff814fa9be>] _raw_spin_lock_irqsave+0x6b/0x85
>  [<ffffffff8106ff9e>] ? migrate_disable+0x75/0x12d
>  [<ffffffff81078aaf>] ? pin_current_cpu+0x36/0xb0
>  [<ffffffff8106ff9e>] migrate_disable+0x75/0x12d
>  [<ffffffff81115b9d>] pagefault_disable+0xe/0x1f
>  [<ffffffff81047027>] copy_from_user_nmi+0x74/0xe6
>  [<ffffffff810489d7>] perf_callchain_user+0xf3/0x135
> 
> Now clearly we can't go around taking locks from NMI context, cure
> this by short-circuiting migrate_disable() when we're in an atomic
> context already.
> 
> Add some extra debugging to avoid things like:
> 
>   preempt_disable()
>   migrate_disable();
> 
>   preempt_enable();
>   migrate_enable();
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Link: http://lkml.kernel.org/n/tip-wbot4vsmwhi8vmbf83hsclk6@git.kernel.org

Now I can collect callchains with perf on linux RT, thanks.

Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>

- Arnaldo
