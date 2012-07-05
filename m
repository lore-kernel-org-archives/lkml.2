Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932622Ab2GEWMD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 18:12:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61670 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932134Ab2GEWMA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 18:12:00 -0400
Date: Thu, 5 Jul 2012 17:43:06 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, snitzer@redhat.com, david@fromorbit.com,
        dm-devel@redhat.com, xfs@oss.sgi.com, hch@lst.de,
        martin.petersen@oracle.com, axboe@kernel.dk
Subject: Re: [PATCH v3 0/2] block: improvements for discard alignment
Message-ID: <20120705214306.GA18063@redhat.com>
References: <1341504104-1674-1-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341504104-1674-1-git-send-email-pbonzini@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 05, 2012 at 06:01:42PM +0200, Paolo Bonzini wrote:
> When a disk has a large discard_granularity, discards are not split with
> optimal alignment; the pessimization gets bigger as discard_granularity
> and max_discard_sectors become closer.
> 
> Take the limit case of discard_granularity == max_discard_sectors == 64.
> Then, if a request is submitted for 256 sectors 2..257 it will be split
> like this: 2..65, 66..129, 130..193, 194..257.  None of these requests
> is aligned, so in fact you might end up with no discarded logical blocks
> at all.  With this patch, the split will be 2..63, 64..127, 128..191,
> 192..255, 256..257.  The patches also take the discard_alignment into
> consideration.
> 
> Patch 1 adjusts the computation of the granularity-adjusted
> max_discard_sectors so that it prepares for the new code in patch 2,
> which actually adjusts the split.
> 
> v2->v3: drop addition of queue/discard_alignment to sysfs, use
>   correct alignment for partitions
> 
> Paolo Bonzini (2):
>   block: reorganize rounding of max_discard_sectors
>   block: split discard into aligned requests

Looks good to me. Did little testing with scsi_debug with discard_alignment=0
and discard_alignment=7 (sectors). We seem to be aligning requests better now.

Acked-by: Vivek Goyal <vgoyal@redhat.com>

Thanks
Vivek
