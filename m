Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777Ab2AZL1X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 06:27:23 -0500
Received: from casper.infradead.org ([85.118.1.10]:42490 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023Ab2AZL1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 06:27:21 -0500
Message-ID: <4F21386C.5000809@kernel.dk>
Date: Thu, 26 Jan 2012 12:26:36 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Indan Zupancic <indan@nul.nu>, Youquan Song <youquan.song@intel.com>,
        Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@linux.intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v1 1/2] sched: unified sched_powersavings sysfs tunable
References: <20120116161740.29759.4679.stgit@localhost>   <20120116162241.29759.13220.stgit@localhost>  <1327503181.2614.76.camel@laptop> <4F212DFF.8060802@kernel.dk> <1327576091.2446.87.camel@twins>
In-Reply-To: <1327576091.2446.87.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/26/2012 12:08 PM, Peter Zijlstra wrote:
> On Thu, 2012-01-26 at 11:42 +0100, Jens Axboe wrote:
>> On 01/25/2012 03:53 PM, Peter Zijlstra wrote:
> 
>>> Jens, what is this thing trying to do?
>>
>> The intent of the code
>> is to return the first CPU in the "group" that the passed in core/thread
>> belongs to. This is used to decide whether to perform a completion
>> locally, or to send it off to a different "group".
> 
> Would you perhaps have meant to identify some shared cache domain?
> 
> In the scheduler core code we have (for CONFIG_SMP):
> 
>   static int ttwu_share_cache(int this_cpu, int that_cpu);
> 
> which returns true if this and that share a cache and false otherwise.
> Would that suffice or do you need a slightly different form? That is, we
> should provide you with some API and avoid you having to poke around
> with CONFIG_SCHED* and topology bits methinks.

Yeah, I think that would suit my purpose nicely, in fact. What level of
cache sharing is being used here? The block code wanted a per-socket
type operation, but since it's a heuristic, perhaps the above is even
better (or equivelant, perhaps).

-- 
Jens Axboe

