Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932187Ab0FDBfc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 21:35:32 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:22408 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757024Ab0FDBfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 21:35:30 -0400
To: Dave Chinner <david@fromorbit.com>
Cc: Christof Schmitt <christof.schmitt@de.ibm.com>,
       "Martin K. Petersen" <martin.petersen@oracle.com>,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: Wrong DIF guard tag on ext2 write
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <20100531112817.GA16260@schmichrtp.mainz.de.ibm.com>
	<yq1iq64kv9f.fsf@sermon.lab.mkp.net>
	<20100531144648.GA19068@schmichrtp.mainz.de.ibm.com>
	<yq11vcqlwp8.fsf@sermon.lab.mkp.net>
	<20100602133748.GA11196@schmichrtp.mainz.de.ibm.com>
	<20100602232039.GA8287@dastard>
Date: Thu, 03 Jun 2010 21:34:18 -0400
In-Reply-To: <20100602232039.GA8287@dastard> (Dave Chinner's message of "Thu,
	3 Jun 2010 09:20:39 +1000")
Message-ID: <yq139x3y411.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Auth-Type: Internal IP
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-CT-RefId: str=0001.0A090203.4C085854.0011:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Dave" == Dave Chinner <david@fromorbit.com> writes:

Dave> If you are running DIF hardware, then XFS is only OK for direct
Dave> IO.  XFS will still get torn writes if you are overwriting
Dave> buffered data (either by write() or mmap()) because there are no
Dave> interlocks to prevent cached pages under writeback from being
Dave> modified while DMA is being performed.....

Didn't you use to wait_on_page_writeback() in page_mkwrite()?

-- 
Martin K. Petersen	Oracle Linux Engineering
