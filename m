Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816Ab0FGRkn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 13:40:43 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:30590 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847Ab0FGRkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 13:40:41 -0400
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
       Dave Chinner <david@fromorbit.com>,
       Christof Schmitt <christof.schmitt@de.ibm.com>,
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
	<20100602232039.GA8287@dastard> <yq139x3y411.fsf@sermon.lab.mkp.net>
	<20100604023253.GF19651@dastard> <yq1zkz6vmpu.fsf@sermon.lab.mkp.net>
	<4C0D2AD4.2020303@panasas.com>
Date: Mon, 07 Jun 2010 13:40:21 -0400
In-Reply-To: <4C0D2AD4.2020303@panasas.com> (Boaz Harrosh's message of "Mon,
	07 Jun 2010 20:22:28 +0300")
Message-ID: <yq1sk4yvj0a.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090208.4C0D2F11.0173:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Boaz" == Boaz Harrosh <bharrosh@panasas.com> writes:

Boaz> Do you remember some performance numbers that show degradation /
Boaz> sameness?

Boaz> What type of work loads?

I haven't been using XFS much for over a year.  I'm using an internal
async I/O tool and btrfs for most of my DIX/DIF testing these days.

But my original changes were along the lines of what Jan mentioned
earlier (hooking into page_mkwrite and waiting for writeback.  I could
have sworn that I only did it for ext[23] and that XFS waited out of the
box but git proves me wrong).  Anyway, I'll try to get some benchmarking
happening later this week.

This won't fix things completely, though.  ext2fs, for instance,
frequently changes metadata buffers in flight so it trips the guard
check in no time.

-- 
Martin K. Petersen	Oracle Linux Engineering
