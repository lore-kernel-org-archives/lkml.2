Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758061Ab2BOInv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 03:43:51 -0500
Received: from casper.infradead.org ([85.118.1.10]:37242 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758027Ab2BOInc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 03:43:32 -0500
Message-ID: <4F3B701F.6050703@kernel.dk>
Date: Wed, 15 Feb 2012 09:43:11 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Shaohua Li <shaohua.li@intel.com>
CC: Tejun Heo <tj@kernel.org>, Vivek Goyal <vgoyal@redhat.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Knut Petersen <Knut_Petersen@t-online.de>, mroos@linux.ee,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH block/for-linus 1/3] block: replace icq->changed with
 icq->flags
References: <20120214181245.GS12117@google.com> <CANejiEVmBOJ7ggD1O6tbXhvZAzZCa6VCi4D421Kqnszx_6QL-Q@mail.gmail.com>
In-Reply-To: <CANejiEVmBOJ7ggD1O6tbXhvZAzZCa6VCi4D421Kqnszx_6QL-Q@mail.gmail.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-02-15 02:09, Shaohua Li wrote:
> 2012/2/15 Tejun Heo <tj@kernel.org>:
>> icq->changed was used for ICQ_*_CHANGED bits.  Rename it to flags and
>> access it under ioc->lock instead of using atomic bitops.
>> ioc_get_changed() is added so that the changed part can be fetched and
>> cleared as before.
>>
>> icq->flags will be used to carry other flags.
>>
>> Signed-off-by: Tejun Heo <tj@kernel.org>
>> ---
>> Jens, these three patches are to fix the swap heavy workload
>> regression reported by Shaohua.
>>
>> Shaohua, I ended up changing the second patch, which shouldn't change
>> anything but it would be great if you can verify this series once
>> more.
> yes, confirmed the patches fix the regression. Thanks for fixing it.
> Tested-by: Shaohua Li <shaohua.li@intel.com>

Great, thanks Tejun - and Shaohua for finding/reporting/testing. I'll
get this applied.

-- 
Jens Axboe

