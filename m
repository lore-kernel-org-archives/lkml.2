Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336Ab0GTErZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 00:47:25 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:18376 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753198Ab0GTErV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 00:47:21 -0400
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
Date: Tue, 20 Jul 2010 00:45:49 -0400
In-Reply-To: <20100716083034.GA7474@schmichrtp.ibm.com> (Christof Schmitt's
	message of "Fri, 16 Jul 2010 10:30:34 +0200")
Message-ID: <yq1bpa292wy.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4C452A51.001B:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Christof" == Christof Schmitt <christof.schmitt@de.ibm.com> writes:

Christof,

Christof> The motivation stems from research how the integrity data can
Christof> be mapped to the hardware interface used by the zfcp
Christof> driver. When passing data segments to the zfcp hardware
Christof> controller, there is the constraint that each data segment has
Christof> a maximum size of 4k and a segment must not cross a 4k
Christof> boundary.

Ok.


Christof> Right now, this is done by reporting the maximum segment size
Christof> and segment boundary accordingly from zfcp. When issuing a
Christof> request, zfcp simply walks the sg list and passes the segments
Christof> to the hardware controller, no mapping or readjustment is
Christof> necessary in the driver.

In that case I don't really have a problem with adhering to the queue
segment size and segment boundary for the integrity metadata.  As long
as we avoid using the max number of data segments to cap the integrity
scatterlist because that'll definitely break a lot of stuff.

Does the zfcp hardware have scatterlist length constraints?


>> Your change also has repercussions when merging requests and bios.
>> We'd need to honor the DI segmentation constraints when merging.
>> Otherwise we may end up going beyond the controller limits when
>> mapping the sgl.

Christof> Meaning the integrity data sg list would have more entries
Christof> than max_segments? I have not seen this during my experiments,
Christof> but then i likely have not hit every case of a possible
Christof> request layout.

It happens all the time.

-- 
Martin K. Petersen	Oracle Linux Engineering
