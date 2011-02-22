Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486Ab1BVQmq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 11:42:46 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:16650 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753725Ab1BVQmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 11:42:44 -0500
To: Andreas Dilger <adilger@dilger.ca>
Cc: "djwong\@us.ibm.com" <djwong@us.ibm.com>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-fsdevel\@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Mingming Cao <mcao@us.ibm.com>,
        linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: [RFC] block integrity: Fix write after checksum calculation problem
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <20110222020022.GH32261@tux1.beaverton.ibm.com>
	<180713DB-114C-454B-A91E-063AB0116251@dilger.ca>
Date: Tue, 22 Feb 2011 11:40:51 -0500
In-Reply-To: <180713DB-114C-454B-A91E-063AB0116251@dilger.ca> (Andreas
	Dilger's message of "Tue, 22 Feb 2011 09:13:49 -0700")
Message-ID: <yq1zkpof2ek.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.110013 (No Gnus v0.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4D63E726.00BD:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Andreas" == Andreas Dilger <adilger@dilger.ca> writes:

Andreas> I don't like adding a data copy in the IO path at all. 

No thanks!


Andreas> I'd definitely prefer that the filesystem be in charge of
Andreas> deciding whether this is needed or not. 

Absolutely. At the block layer we obviously have no idea whether the
filesystem is safe or not. So in my current tree the protection is only
generated if the relevant bio flag is set (unless the application
already added it, obviously).


Andreas> If the use of the data copy can be constrained to only the
Andreas> minimum required cases (e.g. if fs checks for rewrite on page
Andreas> that is marked as Writeback and either copies or blocks until
Andreas> writeback is complete, as a mount option) that would be
Andreas> better. At that point we can compare on different hardware
Andreas> whether copying or blocking should be the default.

Agreed.

As Chris mentioned we've got somebody on our team working through the
filesystem issues now. I'm hoping we can provide a status update at
LSF2011.

-- 
Martin K. Petersen	Oracle Linux Engineering
