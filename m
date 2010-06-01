Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756317Ab0FANSa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 09:18:30 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:45770 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755995Ab0FANS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 09:18:27 -0400
To: Nick Piggin <npiggin@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
       Christof Schmitt <christof.schmitt@de.ibm.com>,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: Wrong DIF guard tag on ext2 write
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <20100531112817.GA16260@schmichrtp.mainz.de.ibm.com>
	<yq1iq64kv9f.fsf@sermon.lab.mkp.net> <20100531144904.GL9453@laptop>
Date: Tue, 01 Jun 2010 09:17:36 -0400
In-Reply-To: <20100531144904.GL9453@laptop> (Nick Piggin's message of "Tue, 1
	Jun 2010 00:49:04 +1000")
Message-ID: <yq1wruiki33.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090201.4C05089F.00C7:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Nick" == Nick Piggin <npiggin@suse.de> writes:

>> Yep, known bug.  Page writeback locking is messed up for buffer_head
>> users.  The extNfs folks volunteered to look into this a while back
>> but I don't think they have found the time yet.

Nick> What do you mean by messed up? Allowing modifications to the page
Nick> while it is under writeback? This is deliberate of course and not
Nick> limited to buffer_head users either.

Messed up in the sense that (at least last I looked) very few
buffer_head users were aware of the existence of the page writeback bit.

-- 
Martin K. Petersen	Oracle Linux Engineering
