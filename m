Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932238Ab0ICLxi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 07:53:38 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:52931 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756788Ab0ICLxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 07:53:36 -0400
Message-ID: <4C80E14F.9040307@ct.jp.nec.com>
Date: Fri, 03 Sep 2010 20:51:43 +0900
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090825)
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Mike Snitzer <snitzer@redhat.com>, jaxboe@fusionio.com,
        j-nomura@ce.jp.nec.com, jamie@shareable.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-raid@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH] block: make sure FSEQ_DATA request has the same rq_disk
 as the original
References: <1283162296-13650-1-git-send-email-tj@kernel.org> <1283162296-13650-5-git-send-email-tj@kernel.org> <20100830132836.GB5283@redhat.com> <4C7BB932.1070405@kernel.org> <4C7BD202.4040700@kernel.org> <4C7DFD8F.6070200@ct.jp.nec.com> <4C7FE251.2020003@kernel.org> <4C808BF8.7060402@ct.jp.nec.com> <4C80C0D6.4030405@kernel.org> <4C80CDC6.8060100@ct.jp.nec.com> <4C80DF15.20100@kernel.org>
In-Reply-To: <4C80DF15.20100@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

On 09/03/2010 08:42 PM +0900, Tejun Heo wrote:
> Hello,
> 
> On 09/03/2010 12:28 PM, Kiyoshi Ueda wrote:
>> Thank you for pointing it.
>> Yes, the interface should also set rq->q.
>>
>> About the naming of the interface, blk_set_<something> sounds
>> reasonable to me.
>> But does blk_set_rq_q() take request and queue as arguments?
>> Then, I'm afraid we can't find bdev for bio from given queue.
> 
> Oh, right.  Maybe blk_set_rq_bdev() then?

Yeah, although struct request doesn't have the member 'bdev',
blk_set_rq_bdev() may be better from the view of the arguments.

Thanks,
Kiyoshi Ueda
