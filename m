Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932613Ab0JWTHc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 15:07:32 -0400
Received: from mx1.fusionio.com ([64.244.102.30]:39724 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932583Ab0JWTHb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 15:07:31 -0400
X-ASG-Debug-ID: 1287860849-169668760001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4CC3326E.5020009@fusionio.com>
Date: Sat, 23 Oct 2010 21:07:26 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH] block: remove REQ_HARDBARRIER
References: <1281977523-19335-1-git-send-email-tj@kernel.org> <201008241745.35242.philipp.reisner@linbit.com> <20101022083511.GA7853@lst.de> <201010231318.33517.philipp.reisner@linbit.com> <4CC311D5.9040904@fusionio.com> <20101023165924.GA1395@lst.de>
X-ASG-Orig-Subj: Re: [PATCH] block: remove REQ_HARDBARRIER
In-Reply-To: <20101023165924.GA1395@lst.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1287860849
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.4845 1.0000 0.0000
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.44533
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-10-23 18:59, Christoph Hellwig wrote:
> REQ_HARDBARRIER is dead now, so remove the leftovers.  What's left
> at this point is:
> 
>  - various checks inside the block layer.
>  - sanity checks in bio based drivers.
>  - now unused bio_empty_barrier helper.
>  - Xen blockfront use of BLKIF_OP_WRITE_BARRIER - it's dead for a while,
>    but Xen really needs to sort out it's barrier situaton.
>  - setting of ordered tags in uas - dead code copied from old scsi
>    drivers.
>  - scsi different retry for barriers - it's dead and should have been
>    removed when flushes were converted to FS requests.
>  - blktrace handling of barriers - removed.  Someone who knows blktrace
>    better should add support for REQ_FLUSH and REQ_FUA, though.

Thanks Christoph, applied for 2.6.37 (but with a few days of brewing).

-- 
Jens Axboe

