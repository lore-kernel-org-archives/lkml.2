Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868Ab0HPHvD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 03:51:03 -0400
Received: from casper.infradead.org ([85.118.1.10]:53316 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752769Ab0HPHvC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 03:51:02 -0400
Subject: Re: [patch 2/3] sched: fix minimum power returned by
 update_cpu_power()
From: Peter Zijlstra <peterz@infradead.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, chris@frostnet.net,
        debian00@aliceadsl.fr, hpa@zytor.com, jonathan.protzenko@gmail.com,
        mans@mansr.com, psastudio@mail.ru, rjw@sisk.pl, stephan.eicher@web.de,
        sxxe@gmx.de, thomas@archlinux.org, venki@google.com, wonghow@gmail.com
In-Reply-To: <20100813193911.909546779@sbsiddha-MOBL3.sc.intel.com>
References: <20100813190539.410550989@sbsiddha-MOBL3.sc.intel.com>
	 <20100813193911.909546779@sbsiddha-MOBL3.sc.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 16 Aug 2010 09:50:37 +0200
Message-ID: <1281945037.1926.954.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-08-13 at 12:45 -0700, Suresh Siddha wrote:
> plain text document attachment (fix_update_cpu_power.patch)
> Default cpu_power needs to be multiples of SCHED_LOAD_SCALE and not '1'.
> Fix it.
> 
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> ---
>  kernel/sched_fair.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: tree/kernel/sched_fair.c
> ===================================================================
> --- tree.orig/kernel/sched_fair.c
> +++ tree/kernel/sched_fair.c
> @@ -2309,7 +2309,7 @@ static void update_cpu_power(struct sche
>  	power >>= SCHED_LOAD_SHIFT;
>  
>  	if (!power)
> -		power = 1;
> +		power = SCHED_LOAD_SCALE;
>  

                            smt_power   freq_power    rt_power
power = SCHED_LOAD_SCALE * ---------- * ---------- * ----------
                           LOAD_SCALE   LOAD_SCALE   LOAD_SCALE

Which, in the above case ends up being 0, so how does resetting it back
to LOAD_SCALE make sense?
