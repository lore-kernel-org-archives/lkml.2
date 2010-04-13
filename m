Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520Ab0DMBr7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 21:47:59 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57694 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754481Ab0DMBr6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 21:47:58 -0400
Message-ID: <4BC3CD24.3020400@cn.fujitsu.com>
Date: Tue, 13 Apr 2010 09:47:16 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Oleg Nesterov <oleg@redhat.com>, Gautham R Shenoy <ego@in.ibm.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Ingo Molnar <mingo@elte.hu>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Nathan Fontenot <nfont@austin.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Sachin Sant <sachinp@in.ibm.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Shane Wang <shane.wang@intel.com>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] cpuhotplug: make get_online_cpus() scalability by
 using percpu counter
References: <4BB9BD8A.9040209@cn.fujitsu.com>	 <20100405162901.GA3567@redhat.com> <20100406120039.GC5680@redhat.com>	 <4BBC8A11.3040501@cn.fujitsu.com> <20100407135456.GA12029@redhat.com>	 <20100409121235.GA5784@redhat.com>  <4BC2E6CE.7060401@cn.fujitsu.com>	 <1271064539.4222.27.camel@twins>  <4BC31265.4090503@cn.fujitsu.com> <1271075670.4807.2.camel@twins>
In-Reply-To: <1271075670.4807.2.camel@twins>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Mon, 2010-04-12 at 20:30 +0800, Lai Jiangshan wrote:
>> Because read-preference RWL will cause write site starvation.
> 
> Sure, but why is that a problem? Hotplug should be a rare event,


> who cares if it takes a while to come through.

It is totally starvation, hotplug can not complete.
I think it is a kind of DOS attack.
