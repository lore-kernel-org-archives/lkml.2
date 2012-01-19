Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755385Ab2ASIXs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 03:23:48 -0500
Received: from casper.infradead.org ([85.118.1.10]:59731 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754104Ab2ASIXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 03:23:45 -0500
Message-ID: <4F17D2F4.6030006@kernel.dk>
Date: Thu, 19 Jan 2012 09:23:16 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: linux-next: build failure after merge of the origin tree
References: <20120119103136.e92b828eca9f2e903da0ea29@canb.auug.org.au> <4F17D2A6.4070705@kernel.dk>
In-Reply-To: <4F17D2A6.4070705@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/19/2012 09:21 AM, Jens Axboe wrote:
> On 01/19/2012 12:31 AM, Stephen Rothwell wrote:
>> Hi Linus,
>>
>> After merging the origin tree, today's linux-next build (x86_64
>> allmodconfig) failed like this:
>>
>> ERROR: "xen_biovec_phys_mergeable" [drivers/block/nvme.ko] undefined!
>>
>> This is weird, as CONFIG_BLOCK and CONFIG_XEN are both set in this build
>> and I started with an empty object directory.  And biomerge.o has been
>> built.
>>
>> Ah ha!
>>
>> drivers/xen/biomerge.c:14:1: warning: data definition has no type or storage class [enabled by default]
>> drivers/xen/biomerge.c:14:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL' [-Wimplicit-int]
>> drivers/xen/biomerge.c:14:1: warning: parameter names (without types) in function declaration [enabled by default]
>>
>> drivers/xen/biomerge.c does not include export.h.  It would be nice if
>> this produced an error, not just the warnings above.  Caused by commit
>> 0b934ccd707f ("Xen: Export xen_biovec_phys_mergeable") (which was never
>> in linux-next :-().
>>
>> I applied the following patch for today:
> 
> Thanks Stephen, applied.

Already in, even better :-)

-- 
Jens Axboe

