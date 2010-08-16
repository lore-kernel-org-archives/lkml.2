Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755753Ab0HPShK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 14:37:10 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42538 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755790Ab0HPShH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 14:37:07 -0400
Subject: Re: [LOCKDEP BUG][2.6.36-rc1] xt_info_wrlock?
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Patrick McHardy <kaber@trash.net>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1281982566.3268.137.camel@gandalf.stny.rr.com>
References: <1281978469.3268.55.camel@gandalf.stny.rr.com>
	 <1281979893.2524.54.camel@edumazet-laptop>
	 <1281981301.3268.110.camel@gandalf.stny.rr.com>
	 <1281982566.3268.137.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 16 Aug 2010 20:36:54 +0200
Message-ID: <1281983814.1926.1763.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-08-16 at 14:16 -0400, Steven Rostedt wrote:
> @@ -729,8 +729,10 @@  static void get_counters(const struct
> xt_table_info *t,
>         local_bh_enable();
>         /* Processing counters from other cpus, we can let bottom half
> enabled,
>          * (preemption is disabled)
> +        * We must turn off lockdep to avoid a false positive.
>          */
>  
> +       lockdep_off();
>         for_each_possible_cpu(cpu) {
> 
nack!
