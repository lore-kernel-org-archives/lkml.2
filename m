Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751706Ab1AXTWu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 14:22:50 -0500
Received: from mx2.fusionio.com ([64.244.102.31]:50933 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750712Ab1AXTWt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 14:22:49 -0500
X-ASG-Debug-ID: 1295896968-01de280c5331760001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D3DD184.4040700@fusionio.com>
Date: Mon, 24 Jan 2011 20:22:44 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hch@infradead.org" <hch@infradead.org>,
        Shaohua Li <shaohua.li@intel.com>
Subject: Re: [PATCH 10/10] fs: make aio plug
References: <1295659049-2688-1-git-send-email-jaxboe@fusionio.com>	<1295659049-2688-11-git-send-email-jaxboe@fusionio.com>	<x497hdugp32.fsf@segfault.boston.devel.redhat.com>	<4D3DCE5D.9090708@fusionio.com> <x4939oigljs.fsf@segfault.boston.devel.redhat.com>
X-ASG-Orig-Subj: Re: [PATCH 10/10] fs: make aio plug
In-Reply-To: <x4939oigljs.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1295896968
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.53327
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-01-24 20:15, Jeff Moyer wrote:
> Jens Axboe <jaxboe@fusionio.com> writes:
> 
>>>> @@ -1698,6 +1701,7 @@ long do_io_submit(aio_context_t ctx_id, long nr,
>>>>  		if (ret)
>>>>  			break;
>>>>  	}
>>>> +	blk_finish_plug(&plug);
>>>>  	aio_batch_free(batch_hash);
>>>
>>> I'm pretty sure you want blk_finish_plug to run after aio_batch_free.
>>
>> You mean to cover the iput()? That's not a bad idea, if that ends up
>> writing it out. I did a few read tests here and confirmed it's sending
>> down batches of whatever number is submitted.
> 
> No, I actually didn't make it all the way through 5/10, so I didn't
> realize you got rid of the blk_run_address_space.  I agree with the TODO
> item to get rid of the aio batching, since it's now taken care of with
> the on-stack plugging.

Oh, so that was the whole point of the series :-)

> As for the iput, I don't think you will get the final iput here, since
> you've just scheduled I/O against the file.

Good point, so the original comment is moot - it wont make a difference.
Still, may not be a bad idea to do the freeing first. I was sort-of
hoping to be able to kill the batching in fs/aio.c completely, though...

-- 
Jens Axboe

