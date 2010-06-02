Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932459Ab0FBNTa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 09:19:30 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:49833 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758139Ab0FBNTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 09:19:25 -0400
To: Nick Piggin <npiggin@suse.de>
Cc: Chris Mason <chris.mason@oracle.com>,
       James Bottomley <James.Bottomley@suse.de>,
       Matthew Wilcox <matthew@wil.cx>,
       Christof Schmitt <christof.schmitt@de.ibm.com>,
       Boaz Harrosh <bharrosh@panasas.com>,
       "Martin K. Petersen" <martin.petersen@oracle.com>,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: Wrong DIF guard tag on ext2 write
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <1275398876.21962.6.camel@mulgrave.site>
	<20100601133341.GK8980@think>
	<1275399637.21962.11.camel@mulgrave.site>
	<20100601134951.GM8980@think>
	<20100601162929.GC32708@parisc-linux.org>
	<20100601164750.GQ8980@think>
	<1275411293.21962.387.camel@mulgrave.site>
	<20100601180905.GR8980@think> <20100601184649.GE9453@laptop>
	<20100601193528.GV8980@think> <20100602032030.GF9453@laptop>
Date: Wed, 02 Jun 2010 09:17:56 -0400
In-Reply-To: <20100602032030.GF9453@laptop> (Nick Piggin's message of "Wed, 2
	Jun 2010 13:20:30 +1000")
Message-ID: <yq17hmhbmkb.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090209.4C065A54.00FA:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Nick" == Nick Piggin <npiggin@suse.de> writes:

>> 1) filesystem changed it
>> 2) corruption on the wire or in the raid controller
>> 3) the page was corrupted while the IO layer was doing the IO.
>> 
>> 1 and 2 are easy, we bounce, retry and everyone continues on with
>> their lives.  With #3, we'll recrc and send the IO down again
>> thinking the data is correct when really we're writing garbage.
>> 
>> How can we tell these three cases apart?

Nick> Do we really need to handle #3? It could have happened before the
Nick> checksum was calculated.

Reason #3 is one of the main reasons for having the checksum in the
first place.  The whole premise of the data integrity extensions is that
the checksum is calculated in close temporal proximity to the data
creation.  I.e. eventually in userland.

Filesystems will inevitably have to be integrity-aware for that to work.
And it will be their job to keep the data pages stable during DMA.

-- 
Martin K. Petersen	Oracle Linux Engineering
