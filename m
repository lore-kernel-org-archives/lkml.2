Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757564Ab0FBAOr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 20:14:47 -0400
Received: from hera.kernel.org ([140.211.167.34]:50179 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756488Ab0FBAOp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 20:14:45 -0400
Message-ID: <4C05A23F.90803@kernel.org>
Date: Wed, 02 Jun 2010 02:13:51 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, davem@davemloft.net,
       jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       viro@ZenIV.linux.org.uk, Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH] fs: run emergency remount on dedicated workqueue
References: <25328.1274886067@redhat.com> <4BFE4203.5010803@kernel.org> <20100601164603.39dfedf7.akpm@linux-foundation.org> <alpine.LFD.2.00.1006011651580.8175@i5.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1006011651580.8175@i5.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 02 Jun 2010 00:13:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 06/02/2010 01:57 AM, Linus Torvalds wrote:
> On Tue, 1 Jun 2010, Andrew Morton wrote:
>>
>> Please, always quote the patch title rather than a bare commit ID.  The
>> usual form is
>>
>>     fa4b9074cd8428958c2adf9dc0c831f46e27c193 ("buffer: make
>>     invalidate_bdev() drain all percpu LRU add caches:)
>>
>> The main reason for this is so that people can more reliably and simply
>> identify the patch within a different tree.  I think.
> 
> Absolutely. Also, I think it's usually more readable to quote just the 
> first 12 hex digits of the SHA1 - that's still going to be perfectly 
> unique in any practical situation, and makes it way easier to flow the 
> text to be readable.

Alright, will do so from now on.

>> gaah.  Do we really want to add Yet Another Kernel Thread just for that
>> dopey sysrq-U thing?
> 
> I do have to agree that it's disgusting. Can't we use an existing thread 
> (slow-work?) or something like that?

The dedicated workqueue can go away with cmwq.  As it's a temporary
measure until then, I wanted to keep it simple.  Would it be okay if I
note that the dedicated workqueue will go away soonish in the patch
description and comment?

Thanks.

-- 
tejun
