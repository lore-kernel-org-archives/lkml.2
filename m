Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655Ab2EVEcL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 00:32:11 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:64321 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231Ab2EVEcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 00:32:09 -0400
Message-ID: <4FBB160D.9040600@ce.jp.nec.com>
Date: Tue, 22 May 2012 13:29:01 +0900
From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: device-mapper development <dm-devel@redhat.com>,
        Kent Overstreet <koverstreet@google.com>
CC: Tejun Heo <tj@kernel.org>, axboe@kernel.dk, linux-kernel@vger.kernel.org,
        linux-bcache@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        agk@redhat.com, Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [dm-devel] [PATCH 02/13] dm: kill dm_rq_bio_destructor
References: <cover.1337308722.git.koverstreet@google.com> <f07bc0f57562d98078e0f4c507cae165aa159e7c.1337308722.git.koverstreet@google.com> <20120518155729.GB19388@google.com> <20120518164319.GJ29330@agk-dp.fab.redhat.com> <20120518185027.GA9673@google.com>
In-Reply-To: <20120518185027.GA9673@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 05/19/12 03:50, Kent Overstreet wrote:
> On Fri, May 18, 2012 at 05:43:19PM +0100, Alasdair G Kergon wrote:
>> On Fri, May 18, 2012 at 08:57:29AM -0700, Tejun Heo wrote:
>>> Please explain why this is done and how it's safe.  Alasdair / dm
>>> folks, can you please ack this?
>>  
>> I think it's relying on there being never more than one reference on those 
>> bios so that that endio fn, called exactly once, always frees it and there
>> are no dm_puts elsewhere.
> 
> Is that a safe assumption? From my perusal of the code it certainly
> looks like it should be, but I don't know dm all that well.

Doing free_bio_info() in end_clone_bio() is safe.

But there is other problem.
This bio may be put by blk_rq_unprep_clone() and leak memory
without the destructor.

So could it be possible to keep bi_destructor available for this case?

Thanks,
-- 
Jun'ichi Nomura, NEC Corporation
