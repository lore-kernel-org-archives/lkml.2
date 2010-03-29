Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755561Ab0C2Bjw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 21:39:52 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50788 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753237Ab0C2Bjv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 21:39:51 -0400
Message-ID: <4BB004ED.5060106@cn.fujitsu.com>
Date: Mon, 29 Mar 2010 09:39:57 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       dipankar@in.ibm.com, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
       rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
       eric.dumazet@gmail.com, adobriyan@gmail.com
Subject: Re: [RFC patch] extable and module add object is static
References: <20100327153233.993367557@efficios.com> <20100327224606.GK2343@linux.vnet.ibm.com> <20100327231421.GA4685@Krystal> <20100327232024.GB4685@Krystal> <20100327234314.GL2343@linux.vnet.ibm.com> <20100328000234.GA4924@Krystal>
In-Reply-To: <20100328000234.GA4924@Krystal>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> +static int core_object_is_static(void *obj)
> +{
[...]
> +	if (addr >= (unsigned long)__per_cpu_start &&
> +	    addr <= (unsigned long)__per_cpu_end)
> +		return 1;

This may only correct for UP.
You may need arch-special codes for SMP.

