Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751133Ab1HKNl2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 09:41:28 -0400
Received: from mx2.fusionio.com ([66.114.96.31]:33325 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751026Ab1HKNlZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 09:41:25 -0400
X-ASG-Debug-ID: 1313070080-01de280c1e13d480001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4E43DBFB.6020105@fusionio.com>
Date: Thu, 11 Aug 2011 15:41:15 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Kyungmin Park <kmpark@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "jh80.chung@samsung.com" <jh80.chung@samsung.com>,
        "shli@kernel.org" <shli@kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>
Subject: Re: [RFC PATCH v2] Add new elevator ops for request hint
References: <20110811004216.GA24810@july> <20110811133302.GC8552@redhat.com>
X-ASG-Orig-Subj: Re: [RFC PATCH v2] Add new elevator ops for request hint
In-Reply-To: <20110811133302.GC8552@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1313070080
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.71459
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-08-11 15:33, Vivek Goyal wrote:
> On Thu, Aug 11, 2011 at 09:42:16AM +0900, Kyungmin Park wrote:
>> Hi Jens
>>
>> Now eMMC device requires the upper layer information to improve the data
>> performance and reliability.
>>
>> . Context ID
>> Using the context information, it can sort out the data internally and improve the performance.
>> The main problem is that it's needed to define "What's the context". 
>> Actually I expect cfq queue has own unique ID but it doesn't so decide to use the pid instead
>>
> 
> Hi,
> 
> Can you please give little more details about the optimization you will
> do with this pid information?

It is provided in one of the other email threads for this patch.

> Also what happens in the case of noop and deadline which don't maintain
> per process queues and can't provide this information.

It'll still work, it isn't really tied to the CFQ way of diviying things
up.

>> First I expect the REQ_META but current ext4 doesn't pass the WRITE_META. only use the READ_META. so it needs to investigate it.
> 
> So are you planning to later fix file systems to appropriately mark meta
> data requests?

One thing that occured to me is that equating META to HOT is not
necessarily a good idea. Meta data isn't necessarily more "hot" than
regular data, it all depends on how it's being used. So I think it would
be a lot more appropriate to pass down this information specifically,
instead of overloading REQ_META.

-- 
Jens Axboe

