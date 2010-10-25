Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685Ab0JYIyu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 04:54:50 -0400
Received: from hera.kernel.org ([140.211.167.34]:38648 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751103Ab0JYIyt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 04:54:49 -0400
Message-ID: <4CC545D2.9020303@kernel.org>
Date: Mon, 25 Oct 2010 10:54:42 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.11) Gecko/20101013 Lightning/1.0b2 Thunderbird/3.1.5
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
CC: Jens Axboe <jaxboe@fusionio.com>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] block: remove REQ_HARDBARRIER
References: <1281977523-19335-1-git-send-email-tj@kernel.org> <201008241745.35242.philipp.reisner@linbit.com> <20101022083511.GA7853@lst.de> <201010231318.33517.philipp.reisner@linbit.com> <4CC311D5.9040904@fusionio.com> <20101023165924.GA1395@lst.de>
In-Reply-To: <20101023165924.GA1395@lst.de>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 25 Oct 2010 08:54:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23/2010 06:59 PM, Christoph Hellwig wrote:
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
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good to me.

Reviewed-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
