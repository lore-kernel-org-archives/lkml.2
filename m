Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932232Ab0FDBrd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 21:47:33 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:41871 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757070Ab0FDBrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 21:47:32 -0400
To: Nick Piggin <npiggin@suse.de>
Cc: Chris Mason <chris.mason@oracle.com>,
       "Martin K. Petersen" <martin.petersen@oracle.com>,
       James Bottomley <James.Bottomley@suse.de>,
       Matthew Wilcox <matthew@wil.cx>,
       Christof Schmitt <christof.schmitt@de.ibm.com>,
       Boaz Harrosh <bharrosh@panasas.com>, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: Wrong DIF guard tag on ext2 write
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <20100601162929.GC32708@parisc-linux.org>
	<20100601164750.GQ8980@think>
	<1275411293.21962.387.camel@mulgrave.site>
	<20100601180905.GR8980@think> <20100601184649.GE9453@laptop>
	<20100601193528.GV8980@think> <20100602032030.GF9453@laptop>
	<yq17hmhbmkb.fsf@sermon.lab.mkp.net> <20100602134121.GD6152@laptop>
	<20100603154634.GC8980@think> <20100603162718.GR6822@laptop>
Date: Thu, 03 Jun 2010 21:46:02 -0400
In-Reply-To: <20100603162718.GR6822@laptop> (Nick Piggin's message of "Fri, 4
	Jun 2010 02:27:18 +1000")
Message-ID: <yq1y6evwox1.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Auth-Type: Internal IP
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-CT-RefId: str=0001.0A090209.4C085B2D.008E:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Nick" == Nick Piggin <npiggin@suse.de> writes:

Nick> Also I don't think we can deal with memory errors and scribbles
Nick> just by crcing dirty data. The calculations generating the data
Nick> could get corrupted.

Yep, the goal is to make the window as small as possible.


Nick> Data can be corrupted on its way back from the device to
Nick> userspace.

We also get a CRC back from the storage.  So the (integrity-aware)
application is also able to check on read.


Nick> Obviously this feature is being pushed by databases and such that
Nick> really want to pass checksums all the way from userspace. Block
Nick> retrying is _not_ needed or wanted here of course.

Nope.  The integrity error is bubbled all the way up to the database and
we can decide to retry, recreate or error out depending on what we find
when we do validation checks on the data buffer and the integrity
metadata.

-- 
Martin K. Petersen	Oracle Linux Engineering
