Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001Ab0DNGTQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 02:19:16 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:31512 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753365Ab0DNGTP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 02:19:15 -0400
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Subject: Re: [PATCH 1/4] blkdev: pass gfp_mask and flags to blkdev_issue_flush
References: <1271077437-7921-1-git-send-email-dmonakhov@openvz.org>
	<1271077437-7921-2-git-send-email-dmonakhov@openvz.org>
	<20100413181023.GB1483@infradead.org>
Date: Wed, 14 Apr 2010 10:18:54 +0400
In-Reply-To: <20100413181023.GB1483@infradead.org> (Christoph Hellwig's
	message of "Tue, 13 Apr 2010 14:10:23 -0400")
Message-ID: <878w8q5zg1.fsf@openvz.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig <hch@infradead.org> writes:

>> +enum{
>> +	__BLKDEV_IFL_WAIT,	/* wait for completion */
>> +	__BLKDEV_IFL_BARRIER,	/*issue request with barrier */
>> +};
>> +#define BLKDEV_IFL_WAIT		(1 << __BLKDEV_IFL_WAIT)
>> +#define BLKDEV_IFL_BARRIER	(1 << __BLKDEV_IFL_BARRIER)
>
> This is a very awkward stayle to define flags.  There really should
> be no need for the __-prefixed version.  While you're using them for
> test/set_bit and co there's no reason to use these atomic bitops here.
I need both bit_num(used inside function) and flag (1<<bit_num)
which is used by function caller.
No problem, i'll change it whenever you like
do you like following?
enum{
	IFN_BLKDEV_WAIT,	/* wait for completion */
	IFN_BLKDEV_BARRIER,	/*issue request with barrier */
};
#define BLKDEV_WAIT		(1 << IFN_BLKDEV_WAIT)
#define BLKDEV_BARRIER		(1 << IFN_BLKDEV_BARRIER)
