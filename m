Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752923Ab2BTKvg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 05:51:36 -0500
Received: from casper.infradead.org ([85.118.1.10]:49458 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752532Ab2BTKv0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 05:51:26 -0500
Message-ID: <1329735073.2293.305.camel@twins>
Subject: Re: [RFC PATCH 0/4] Gang scheduling in CFS
From: Peter Zijlstra <peterz@infradead.org>
To: Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Avi Kivity <avi@redhat.com>,
        Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
        vatsa@linux.vnet.ibm.com, bharata@linux.vnet.ibm.com
Date: Mon, 20 Feb 2012 11:51:13 +0100
In-Reply-To: <87fwe6ork3.fsf@abhimanyu.in.ibm.com>
References: <20111230095147.GA10543@elte.hu>
	 <878vlu4bgh.fsf@linux.vnet.ibm.com> <87pqf5mqg4.fsf@abhimanyu.in.ibm.com>
	 <4F017AD2.3090504@redhat.com> <87mxa3zqm1.fsf@abhimanyu.in.ibm.com>
	 <4F046536.5080207@redhat.com> <4F048295.1050907@redhat.com>
	 <4F04898B.1080600@redhat.com> <1325712710.3084.10.camel@laptop>
	 <4F04C789.40209@redhat.com> <20120105091059.GA3249@elte.hu>
	 <87fwe6ork3.fsf@abhimanyu.in.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-02-20 at 13:38 +0530, Nikunj A Dadhania wrote:
> +#ifdef CONFIG_PARAVIRT_FLUSH_TLB
> +               while (!cpumask_empty(to_cpumask(f->flush_cpumask)) && --loop)
> +                       cpu_relax();
> +               if (!loop && !cpumask_empty(to_cpumask(f->flush_cpumask)))
> +                       halt();


That's just vile, you don't need to wait for it, all you need to make
sure is that when that vcpu wakes up it does the flush.

But yeah, the results are a good hint that you're on the right track.
