Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693Ab2FEOGP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 10:06:15 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50855 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490Ab2FEOGN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 10:06:13 -0400
Message-ID: <1338905159.28282.186.camel@twins>
Subject: Re: [PATCH] kthread: Implement park/unpark facility
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Fenghua Yu <fenghua.yu@intel.com>,
        Ingo Molnar <mingo@elte.hu>, H Peter Anvin <hpa@zytor.com>,
        Suresh B Siddha <suresh.b.siddha@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Asit K Mallick <asit.k.mallick@intel.com>,
        Arjan Dan De Ven <arjan@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>,
        linux-pm <linux-pm@vger.kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Date: Tue, 05 Jun 2012 16:05:59 +0200
In-Reply-To: <alpine.LFD.2.02.1206051538280.3086@ionos>
References: <1338833876-29721-1-git-send-email-fenghua.yu@intel.com>
	 <alpine.LFD.2.02.1206042203590.3086@ionos>
	 <1338842001.28282.135.camel@twins> <87zk8iioam.fsf@rustcorp.com.au>
	 <alpine.LFD.2.02.1206051135260.3086@ionos>
	 <alpine.LFD.2.02.1206051538280.3086@ionos>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-06-05 at 15:41 +0200, Thomas Gleixner wrote:
>  struct kthread {
> -       int should_stop;
> +       bool should_stop;
> +       bool should_park;
> +       bool is_parked;
> +       bool is_percpu; 

bool doesn't have a well specified storage type. I typically try to
avoid using it in structures for this reason. Others might not care
though.
