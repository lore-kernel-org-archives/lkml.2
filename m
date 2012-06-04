Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760886Ab2FDVOx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 17:14:53 -0400
Received: from casper.infradead.org ([85.118.1.10]:35133 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754606Ab2FDVOw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 17:14:52 -0400
Message-ID: <1338844480.28282.147.camel@twins>
Subject: Re: [PATCH] cpuidle: menu: use nr_running instead of cpuload for
 calculating perf mult
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Vladimir Davydov <vdavydov@parallels.com>, Ingo Molnar <mingo@elte.hu>,
        Len Brown <lenb@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Date: Mon, 04 Jun 2012 23:14:40 +0200
In-Reply-To: <4FCD1E57.5070706@linux.intel.com>
References: <1338805485-10874-1-git-send-email-vdavydov@parallels.com>
	       <1338805967.28282.12.camel@twins> <4FCCB486.4040905@linux.intel.com>
	      <1338817519.28282.54.camel@twins> <4FCCBC97.8060101@linux.intel.com>
	     <1338822509.28282.65.camel@twins> <4FCCD0CD.8080700@linux.intel.com>
	    <1338823568.28282.79.camel@twins> <4FCCD6B7.4030703@linux.intel.com>
	   <1338827607.28282.99.camel@twins> <4FCCE823.8090700@linux.intel.com>
	  <1338830167.28282.115.camel@twins> <4FCCEF94.6010805@linux.intel.com>
	 <1338841878.28282.133.camel@twins> <4FCD1E57.5070706@linux.intel.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-04 at 13:45 -0700, Arjan van de Ven wrote:
> On 6/4/2012 1:31 PM, Peter Zijlstra wrote:
> > 
> > And like I said many times now, if you inflate some of the idle periods,
> > the work shifts (it doesn't become less) and a next idle period will be
> > smaller -- since we'll only become idle again once all work is done.
> 
> this is what is not really correct.
> 
> you can be idle for many reasons, not just because you have no work
> left. most common is waiting for a disk IO. the idle period for that
> will not get shorter just because the previous one took more time.

Then you're back to synchronous behaviour and your earlier claim that it
is was not about latency response is false.
