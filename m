Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933762Ab0GOQfx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 12:35:53 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:28853 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933695Ab0GOQfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 12:35:52 -0400
To: Jens Axboe <axboe@kernel.dk>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christof Schmitt <christof.schmitt@de.ibm.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 0/1] Apply segment size and segment boundary to integrity data
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <20100715153410.774329000@de.ibm.com>
	<yq1mxtspwab.fsf@sermon.lab.mkp.net> <4C3F3400.7060005@kernel.dk>
Date: Thu, 15 Jul 2010 12:35:27 -0400
In-Reply-To: <4C3F3400.7060005@kernel.dk> (Jens Axboe's message of "Thu, 15
	Jul 2010 10:14:56 -0600")
Message-ID: <yq1iq4gpusw.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4C3F38DE.019D:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Jens" == Jens Axboe <axboe@kernel.dk> writes:

Jens> That sounds like a very batch design decision. Either the limits
Jens> are explicitly given and different, or if not we have to assume
Jens> that they are the same as the data limits at least.

Imagine a controller that has a 4KB segment, 1 entry limit.  If we
capped the DI sgl the same way as the data we'd only be able to issue
512-byte requests unless the DI entries happened to be contiguous in
memory.

For several types of I/O the DI sgl is much longer than the data sgl.
Especially if the submitter is using buffer_heads to map 512-byte
blocks.

And consequently we require vendors to be able to handle the
pathological case in which any data scatterlist honoring the
segmentation constraints given by the driver can be matched with an
integrity scatterlist in which there is a separate entry for each
logical block.  No vendor has had any problems with this.  Therefore
there are no block layer data integrity queue limits.

If a device appears that does in fact have constraints I have no
problems intruducing a set of suitable knobs.

-- 
Martin K. Petersen	Oracle Linux Engineering
