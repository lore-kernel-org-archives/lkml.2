Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932098Ab0FDBbT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 21:31:19 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:54223 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756856Ab0FDBbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 21:31:17 -0400
To: Nick Piggin <npiggin@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
       Chris Mason <chris.mason@oracle.com>,
       James Bottomley <James.Bottomley@suse.de>,
       Matthew Wilcox <matthew@wil.cx>,
       Christof Schmitt <christof.schmitt@de.ibm.com>,
       Boaz Harrosh <bharrosh@panasas.com>, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: Wrong DIF guard tag on ext2 write
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <1275399637.21962.11.camel@mulgrave.site>
	<20100601134951.GM8980@think>
	<20100601162929.GC32708@parisc-linux.org>
	<20100601164750.GQ8980@think>
	<1275411293.21962.387.camel@mulgrave.site>
	<20100601180905.GR8980@think> <20100601184649.GE9453@laptop>
	<20100601193528.GV8980@think> <20100602032030.GF9453@laptop>
	<yq17hmhbmkb.fsf@sermon.lab.mkp.net> <20100602134121.GD6152@laptop>
Date: Thu, 03 Jun 2010 21:30:06 -0400
In-Reply-To: <20100602134121.GD6152@laptop> (Nick Piggin's message of "Wed, 2
	Jun 2010 23:41:21 +1000")
Message-ID: <yq17hmfy481.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090201.4C08575E.0049:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Nick" == Nick Piggin <npiggin@suse.de> writes:

Nick,

>> Filesystems will inevitably have to be integrity-aware for that to
>> work.  And it will be their job to keep the data pages stable during
>> DMA.

Nick> Closing the while it is dirty, while it is being written back
Nick> window still leaves a pretty big window. Also, how do you handle
Nick> mmap writes?  Write protect and checksum the destination page
Nick> after every store? Or leave some window between when the pagecache
Nick> is dirtied and when it is written back? So I don't know whether
Nick> it's worth putting a lot of effort into this case.

I'm mostly interested in the cases where the filesystem acts as a
conduit for integrity metadata from user space. 

I agree the corruption windows inside the kernel are only of moderate
interest.  No filesystems have added support for explicitly protecting a
bio because the block layer's function to do so automatically is just a
few function calls away.

-- 
Martin K. Petersen	Oracle Linux Engineering
