Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931Ab1AXTQI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 14:16:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28687 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751242Ab1AXTQG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 14:16:06 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hch\@infradead.org" <hch@infradead.org>,
        Shaohua Li <shaohua.li@intel.com>
Subject: Re: [PATCH 10/10] fs: make aio plug
References: <1295659049-2688-1-git-send-email-jaxboe@fusionio.com>
	<1295659049-2688-11-git-send-email-jaxboe@fusionio.com>
	<x497hdugp32.fsf@segfault.boston.devel.redhat.com>
	<4D3DCE5D.9090708@fusionio.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 24 Jan 2011 14:15:51 -0500
In-Reply-To: <4D3DCE5D.9090708@fusionio.com> (Jens Axboe's message of "Mon, 24
	Jan 2011 20:09:17 +0100")
Message-ID: <x4939oigljs.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe <jaxboe@fusionio.com> writes:

>>> @@ -1698,6 +1701,7 @@ long do_io_submit(aio_context_t ctx_id, long nr,
>>>  		if (ret)
>>>  			break;
>>>  	}
>>> +	blk_finish_plug(&plug);
>>>  	aio_batch_free(batch_hash);
>> 
>> I'm pretty sure you want blk_finish_plug to run after aio_batch_free.
>
> You mean to cover the iput()? That's not a bad idea, if that ends up
> writing it out. I did a few read tests here and confirmed it's sending
> down batches of whatever number is submitted.

No, I actually didn't make it all the way through 5/10, so I didn't
realize you got rid of the blk_run_address_space.  I agree with the TODO
item to get rid of the aio batching, since it's now taken care of with
the on-stack plugging.

As for the iput, I don't think you will get the final iput here, since
you've just scheduled I/O against the file.

Cheers,
Jeff
