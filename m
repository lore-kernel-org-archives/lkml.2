Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403Ab0KZQ3p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 11:29:45 -0500
Received: from casper.infradead.org ([85.118.1.10]:58597 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755300Ab0KZQ3n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 11:29:43 -0500
Subject: Re: [PATCH] printk: use this_cpu_{read|write} api on printk_pending
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        heiko.carstens@de.ibm.com, tglx@linutronix.de, mingo@elte.hu,
        Christoph Lameter <cl@linux.com>
In-Reply-To: <1290788536.2855.237.camel@edumazet-laptop>
References: <20101126120235.406766476@de.ibm.com>
	 <tip-61ab25447ad6334a74e32f60efb135a3467223f8@git.kernel.org>
	 <1290788536.2855.237.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 26 Nov 2010 17:29:48 +0100
Message-ID: <1290788988.2145.152.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-26 at 17:22 +0100, Eric Dumazet wrote:
> [PATCH] printk: use this_cpu_{read|write} api on printk_pending
> 
> __get_cpu_var() is a bit inefficient, lets use __this_cpu_read() and
> __this_cpu_write() to manipulate printk_pending.
> 
> printk_needs_cpu(cpu) is called only for the current cpu :
> Use faster __this_cpu_read().
> 
> remove the redondant unlikely on (cpu_is_offline(cpu)) test
> 
> # size kernel/printk.o*
>    text    data     bss     dec     hex filename
>    9942     756  263488  274186   42f0a kernel/printk.o.new
>    9990     756  263488  274234   42f3a kernel/printk.o.old


Thanks, queued!
