Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755007Ab0HCEpt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 00:45:49 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:62178 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453Ab0HCEps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 00:45:48 -0400
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
	<yq1y6d579fy.fsf@sermon.lab.mkp.net>
	<20100802110517.GA4556@schmichrtp.mainz.de.ibm.com>
Date: Tue, 03 Aug 2010 00:44:50 -0400
In-Reply-To: <20100802110517.GA4556@schmichrtp.mainz.de.ibm.com> (Christof
	Schmitt's message of "Mon, 2 Aug 2010 13:05:17 +0200")
Message-ID: <yq1vd7s8ful.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4C579EF5.0002:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Christof" == Christof Schmitt <christof.schmitt@de.ibm.com> writes:

Christof> To summarize the limits i see in the zfcp hardware:
Christof> - Maximum size of 4k per segment
Christof> - The segments must not cross page boundaries
Christof> - The number of segments per request is limited

The interesting thing here is that your hw has a limit for the total
number of segments whereas other DIX HBAs have separate limits for data
and integrity scatterlists.


Christof> What would be the preferred approach for handling the
Christof> integrity data limits in the block layer? Introduce new queue
Christof> limits for integrity data, or assume that the limits for
Christof> integrity data are the same as for user data? I can update my
Christof> patch accordingly and include a check for the maximum number
Christof> of segments.

I've been messing with this tonight.  It's not entirely trivial because
of the housekeeping involved, having to accomodate different types of
hardware, having to avoid breaking existing setups, and having to work
with integrity compiled and without.

My first attempt at this got quite messy.  I think I have found a way
but it's bedtime here.  Give me a day or two to get back to you with
something that'll hopefully work for everyone.

-- 
Martin K. Petersen	Oracle Linux Engineering
