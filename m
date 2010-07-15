Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933817Ab0GOQkz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 12:40:55 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:35366 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933757Ab0GOQky (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 12:40:54 -0400
Message-ID: <4C3F3A0C.10909@kernel.dk>
Date: Thu, 15 Jul 2010 10:40:44 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: "Martin K. Petersen" <martin.petersen@oracle.com>
CC: Christof Schmitt <christof.schmitt@de.ibm.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 0/1] Apply segment size and segment boundary to integrity
 data
References: <20100715153410.774329000@de.ibm.com>	<yq1mxtspwab.fsf@sermon.lab.mkp.net> <4C3F3400.7060005@kernel.dk> <yq1iq4gpusw.fsf@sermon.lab.mkp.net>
In-Reply-To: <yq1iq4gpusw.fsf@sermon.lab.mkp.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2010 10:35 AM, Martin K. Petersen wrote:
>>>>>> "Jens" == Jens Axboe <axboe@kernel.dk> writes:
> 
> Jens> That sounds like a very batch design decision. Either the limits
> Jens> are explicitly given and different, or if not we have to assume
> Jens> that they are the same as the data limits at least.
> 
> Imagine a controller that has a 4KB segment, 1 entry limit.  If we
> capped the DI sgl the same way as the data we'd only be able to issue
> 512-byte requests unless the DI entries happened to be contiguous in
> memory.
> 
> For several types of I/O the DI sgl is much longer than the data sgl.
> Especially if the submitter is using buffer_heads to map 512-byte
> blocks.
> 
> And consequently we require vendors to be able to handle the
> pathological case in which any data scatterlist honoring the
> segmentation constraints given by the driver can be matched with an
> integrity scatterlist in which there is a separate entry for each
> logical block.  No vendor has had any problems with this.  Therefore
> there are no block layer data integrity queue limits.
> 
> If a device appears that does in fact have constraints I have no
> problems intruducing a set of suitable knobs.

OK, lets wait and hear what problem that Christof ran into here.
Is it ensuring that a segment doesn't corss eg the 4GB boundary?

-- 
Jens Axboe

