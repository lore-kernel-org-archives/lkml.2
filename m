Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758693Ab2HHPCk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 11:02:40 -0400
Received: from www.linutronix.de ([62.245.132.108]:59490 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758537Ab2HHPCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 11:02:38 -0400
Message-ID: <50227F89.6020408@linutronix.de>
Date: Wed, 08 Aug 2012 17:02:33 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: linux-kernel@vger.kernel.org, x86@kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Roland McGrath <roland@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakaynahalli <ananth@in.ibm.com>, stan_shebs@mentor.com
Subject: Re: [PATCH 2/5] x86/uprobes: implement x86 specific arch_uprobe_*_step
References: <1344355952-2382-1-git-send-email-bigeasy@linutronix.de> <1344355952-2382-3-git-send-email-bigeasy@linutronix.de> <20120808125709.GA4504@redhat.com> <50226700.9000606@linutronix.de> <20120808145345.GA8171@redhat.com>
In-Reply-To: <20120808145345.GA8171@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2012 04:53 PM, Oleg Nesterov wrote:
>> Why? I tried 'lock popf' and I got invalid instruction. The same for
>> 'rep popf'.
>
> 	int main(void)
> 	{
> 		asm volatile ("pushf; rep; popf");
>
> 		return 0;
> 	}
>

Just tested and it works. Hmm.

> OK, probably nobody should do this (although the kernel should not
> assume this imho), but
>
> 	asm volatile ("pushfw; popfw");
>
> doesn't look bad and the code is
>
> 	000000000040047c<main>:
> 	  40047c:       55                      push   %rbp
> 	  40047d:       48 89 e5                mov    %rsp,%rbp
> 	  400480:       66 9c                   pushfw
> 	  400482:       66 9d                   popfw
> 	  400484:       b8 00 00 00 00          mov    $0x0,%eax
> 	  400489:       c9                      leaveq
> 	  40048a:       c3                      retq

Yes, that one works as well.

> And in any case it would be better to re-use auprobe->fixups.

Okay.

> Oleg.
>

Sebastian
