Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759526Ab2EWKRb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 06:17:31 -0400
Received: from casper.infradead.org ([85.118.1.10]:47151 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061Ab2EWKRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 06:17:30 -0400
Message-ID: <4FBCB913.8050403@kernel.dk>
Date: Wed, 23 May 2012 12:16:51 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Sasha Levin <levinsasha928@gmail.com>
CC: Tejun Heo <tj@kernel.org>, Sasha Levin <sasha.levin@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH block/for-3.5/core] blkcg: tg_stats_alloc_lock is an irq
 lock
References: <1335339396.16988.80.camel@lappy> <20120426211042.GC27486@google.com> <CA+1xoqff_OQORFm05fCqeZ-vCt+2Y9H0KNfSxrCepfCDNGZgXQ@mail.gmail.com>
In-Reply-To: <CA+1xoqff_OQORFm05fCqeZ-vCt+2Y9H0KNfSxrCepfCDNGZgXQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2012 11:54 AM, Sasha Levin wrote:
> On Thu, Apr 26, 2012 at 11:10 PM, Tejun Heo <tj@kernel.org> wrote:
>> tg_stats_alloc_lock nests inside queue lock and should always be held
>> with irq disabled.  throtl_pd_{init|exit}() were using non-irqsafe
>> spinlock ops which triggered inverse lock ordering via irq warning via
>> RCU freeing of blkg invoking throtl_pd_exit() w/o disabling IRQ.
>>
>> Update both functions to use irq safe operations.
>>
>> Signed-off-by: Tejun Heo <tj@kernel.org>
>> Reported-by: Sasha Levin <sasha.levin@oracle.com>
>> LKML-Reference: <1335339396.16988.80.camel@lappy>
>> ---
> 
> I think that this patch got lost somewhere and never got merged into
> the for-3.5 branch.

Seems it did, odd. Applied it now.

-- 
Jens Axboe

