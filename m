Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755085Ab0EaOWa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 10:22:30 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:41557 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754912Ab0EaOW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 10:22:27 -0400
To: Christof Schmitt <christof.schmitt@de.ibm.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: Wrong DIF guard tag on ext2 write
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <20100531112817.GA16260@schmichrtp.mainz.de.ibm.com>
Date: Mon, 31 May 2010 10:20:44 -0400
In-Reply-To: <20100531112817.GA16260@schmichrtp.mainz.de.ibm.com> (Christof
	Schmitt's message of "Mon, 31 May 2010 13:28:18 +0200")
Message-ID: <yq1iq64kv9f.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090209.4C03C620.00E3:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Christof" == Christof Schmitt <christof.schmitt@de.ibm.com> writes:

Christof> Since the guard tags are created in Linux, it seems that the
Christof> data attached to the write request changes between the
Christof> generation in bio_integrity_generate and the call to
Christof> sd_prep_fn.

Yep, known bug.  Page writeback locking is messed up for buffer_head
users.  The extNfs folks volunteered to look into this a while back but
I don't think they have found the time yet.


Christof> Using ext3 or ext4 instead of ext2 does not show the problem.

Last I looked there were still code paths in ext3 and ext4 that
permitted pages to be changed during flight.  I guess you've just been
lucky.

-- 
Martin K. Petersen	Oracle Linux Engineering
