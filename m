Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007Ab0KEQy7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 12:54:59 -0400
Received: from smtp107.prem.mail.ac4.yahoo.com ([76.13.13.46]:31210 "HELO
	smtp107.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753077Ab0KEQy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 12:54:56 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: fjcBvwYVM1lSnwX._gsvBo_3mQiuHMoP.JTHb75Sm2m1E0e
 HZmQaZkYyVL_3WqLyRw6bGgqcZhJjuvYfazx3wHJu_TVYN0Bu_DbV59_.gU0
 yF9PGxrnUS3Z1pY8dLy.7qviFYpm7sl4DeciJBpZNiq9rjmAz2vDouMZ3tvW
 YLdcJW9V6v56c1nbqV0HfgpnAk7pbm2.KehYhsk0xFJ563mcM73Kvo5rwqpe
 6kltk
X-Yahoo-Newman-Property: ymail-3
Date: Fri, 5 Nov 2010 11:54:53 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v2] irq: use per_cpu kstat_irqs
In-Reply-To: <1288973210.2882.733.camel@edumazet-laptop>
Message-ID: <alpine.DEB.2.00.1011051153110.8161@router.home>
References: <1288892908.2659.175.camel@edumazet-laptop> <1288973210.2882.733.camel@edumazet-laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Nov 2010, Eric Dumazet wrote:

>  static inline void kstat_incr_irqs_this_cpu(unsigned int irq,
>  					    struct irq_desc *desc)

desc is not used.

>  {
> -	kstat_this_cpu.irqs[irq]++;
> -	kstat_this_cpu.irqs_sum++;
> +	__this_cpu_inc(kstat.irqs[irq]);
> +	__this_cpu_inc(kstat.irqs_sum);
>  }

