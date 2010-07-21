Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751707Ab0GUEVs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 00:21:48 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:40142 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026Ab0GUEVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:21:44 -0400
To: Christof Schmitt <christof.schmitt@de.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 0/1] Apply segment size and segment boundary to integrity data
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <20100715153410.774329000@de.ibm.com>
	<yq1mxtspwab.fsf@sermon.lab.mkp.net>
	<20100716083034.GA7474@schmichrtp.ibm.com>
	<yq1bpa292wy.fsf@sermon.lab.mkp.net>
	<20100720092850.GA4547@schmichrtp.mainz.de.ibm.com>
Date: Wed, 21 Jul 2010 00:20:01 -0400
In-Reply-To: <20100720092850.GA4547@schmichrtp.mainz.de.ibm.com> (Christof
	Schmitt's message of "Tue, 20 Jul 2010 11:28:50 +0200")
Message-ID: <yq1y6d579fy.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4C4675D2.0055:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Christof" == Christof Schmitt <christof.schmitt@de.ibm.com> writes:

Christof> To have a simple approach that covers the case with one
Christof> integrity data segment per user data segment, we only report
Christof> half the size for the scatterlist length when running
Christof> DIX. This guarantees that the other half can be used for
Christof> integrity data.

Yup, a few of our partners did something similar.

My concern is the scenario where we submit lots of 512-byte writes that
get merged into (in your case) 4 KB segments.  Each of those 512-byte
writes could come with an 8-byte integrity metadata tuple.  And so you'd
need 8 DI scatterlist elements per data element.


Christof> Meaning the integrity data sg list would have more entries
Christof> than max_segments? I have not seen this during my experiments,
Christof> but then i likely have not hit every case of a possible
Christof> request layout.

dd to the block device is usually a good way to issue long scatterlists.


Christof> Ok, i have to look into that as well. It would be an issue
Christof> with the approach we are looking at now: If there are
Christof> max_segments data segments, and more than max_segments
Christof> integrity data segments, we will overrun the hardware
Christof> constraint.

Ok.

-- 
Martin K. Petersen	Oracle Linux Engineering
