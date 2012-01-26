Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222Ab2AZLIa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 06:08:30 -0500
Received: from casper.infradead.org ([85.118.1.10]:42213 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257Ab2AZLI3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 06:08:29 -0500
Message-ID: <1327576091.2446.87.camel@twins>
Subject: Re: [RFC PATCH v1 1/2] sched: unified sched_powersavings sysfs
 tunable
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jens Axboe <axboe@kernel.dk>
Cc: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Indan Zupancic <indan@nul.nu>, Youquan Song <youquan.song@intel.com>,
        Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@linux.intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Date: Thu, 26 Jan 2012 12:08:11 +0100
In-Reply-To: <4F212DFF.8060802@kernel.dk>
References: <20120116161740.29759.4679.stgit@localhost>
	  <20120116162241.29759.13220.stgit@localhost>
	 <1327503181.2614.76.camel@laptop> <4F212DFF.8060802@kernel.dk>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-01-26 at 11:42 +0100, Jens Axboe wrote:
> On 01/25/2012 03:53 PM, Peter Zijlstra wrote:

> > Jens, what is this thing trying to do?
> 
>The intent of the code
> is to return the first CPU in the "group" that the passed in core/thread
> belongs to. This is used to decide whether to perform a completion
> locally, or to send it off to a different "group".

Would you perhaps have meant to identify some shared cache domain?

In the scheduler core code we have (for CONFIG_SMP):

  static int ttwu_share_cache(int this_cpu, int that_cpu);

which returns true if this and that share a cache and false otherwise.
Would that suffice or do you need a slightly different form? That is, we
should provide you with some API and avoid you having to poke around
with CONFIG_SCHED* and topology bits methinks.

