Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881Ab2E2MOo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 08:14:44 -0400
Received: from casper.infradead.org ([85.118.1.10]:54529 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753491Ab2E2MOk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 08:14:40 -0400
Message-ID: <1338293627.26856.51.camel@twins>
Subject: Re: [tip:sched/core] sched/numa: Rewrite the CONFIG_NUMA sched
 domain support
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jiang Liu <liuj97@gmail.com>
Cc: Yinghai Lu <yinghai@kernel.org>, mingo@kernel.org,
        torvalds@linux-foundation.org, cmetcalf@tilera.com,
        tony.luck@intel.com, sivanich@sgi.com, akpm@linux-foundation.org,
        ralf@linux-mips.org, greg.pearson@hp.com, ink@jurassic.park.msu.ru,
        tglx@linutronix.de, rth@twiddle.net, kamezawa.hiroyu@jp.fujitsu.com,
        paulus@samba.org, linux-kernel@vger.kernel.org, hpa@zytor.com,
        anton@samba.org, lethal@linux-sh.org, davem@davemloft.net,
        benh@kernel.crashing.org, dhowells@redhat.com, mattst88@gmail.com,
        fenghua.yu@intel.com, linux-tip-commits@vger.kernel.org
Date: Tue, 29 May 2012 14:13:47 +0200
In-Reply-To: <4FC41903.1060705@gmail.com>
References: <tip-r74n3n8hhuc2ynbrnp3vt954@git.kernel.org>
	 <CAE9FiQWat=55Ygp-f6ovJx+CD=Knjic9Xvpp+Ngf-o19zNUy7g@mail.gmail.com>
	 <1336671883.27020.128.camel@laptop>
	 <CAE9FiQWB23V=XoyzQaq1X+JNtUcV=4bLQ1sGCMOTjKRqAV7XuQ@mail.gmail.com>
	 <4FC41903.1060705@gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-29 at 08:32 +0800, Jiang Liu wrote:
>         Does this patch fix your issue? https://lkml.org/lkml/2012/5/9/183.
> I have encountered a similar issue on an IA64 platform and the patch above 
> works around it. But the root cause is a BIOS bug that the order of CPUs 
> in MADT table doesn't conform to the ACPI specification and the first CPU 
> in MADT is not the BSP, which breaks some assumption of the booting code
> and causes the core dump. 

Is that IA64 arch code that contains those false assumptions or is it
generic (sched) code that contains them? Esp in the latter case I'd be
very interested to hear where these are so we can fix them.


