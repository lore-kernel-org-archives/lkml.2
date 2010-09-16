Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755944Ab0IPSzQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 14:55:16 -0400
Received: from mx2.fusionio.com ([64.244.102.31]:36651 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754604Ab0IPSzO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 14:55:14 -0400
X-ASG-Debug-ID: 1284663313-08b707a20001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4C92680D.1030605@fusionio.com>
Date: Thu, 16 Sep 2010 20:55:09 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
CC: "tj@kernel.org" <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] block: remove BLKDEV_IFL_WAIT
References: <20100916161450.GA5587@lst.de>
X-ASG-Orig-Subj: Re: [PATCH] block: remove BLKDEV_IFL_WAIT
In-Reply-To: <20100916161450.GA5587@lst.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1284663313
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.41014
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-09-16 18:14, Christoph Hellwig wrote:
> All the blkdev_issue_* helpers can only sanely be used for synchronous
> caller.  To issue cache flushes or barriers asynchronously the caller needs
> to set up a bio by itself with a completion callback to move the asynchronous
> state machine ahead.  So drop the BLKDEV_IFL_WAIT flag that is always
> specified when calling blkdev_issue_* and also remove the now unused flags
> argument to blkdev_issue_flush and blkdev_issue_zeroout.  For
> blkdev_issue_discard we need to keep it for the secure discard flag, which
> gains a more descriptive name and loses the bitops vs flag confusion.

Thanks, applied. I think we still have a missing unplug for these cases,
I'll take a look at that.

-- 
Jens Axboe


Confidentiality Notice: This e-mail message, its contents and any attachments to it are confidential to the intended recipient, and may contain information that is privileged and/or exempt from disclosure under applicable law. If you are not the intended recipient, please immediately notify the sender and destroy the original e-mail message and any attachments (and any copies that may have been made) from your system or otherwise. Any unauthorized use, copying, disclosure or distribution of this information is strictly prohibited.
