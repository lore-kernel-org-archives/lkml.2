Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752659Ab0HYTNN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 15:13:13 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:50912 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771Ab0HYTNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 15:13:10 -0400
Message-ID: <4C756B37.4000007@vlnb.net>
Date: Wed, 25 Aug 2010 23:12:55 +0400
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100527 Thunderbird/3.0.5
MIME-Version: 1.0
To: Chris Worley <worleys@gmail.com>
CC: =?ISO-8859-1?Q?Pasi_K=E4rkk=E4inen?= <pasik@iki.fi>,
        Chetan Loke <chetanloke@gmail.com>,
        Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        James Bottomley <James.Bottomley@suse.de>,
        scst-devel <scst-devel@lists.sourceforge.net>
Subject: Re: Linux I/O subsystem performance
References: <8A96806D-6CD7-44AD-8A9D-143C098C95A4@uni-paderborn.de>	<1282256949.30453.278.camel@haakon2.linux-iscsi.org>	<4C701E08.2020005@vlnb.net>	<1282423398.3015.39.camel@mulgrave.site>	<AANLkTikcReFsYMhs1RkCHoRkL1+Q9WuptHj1xbx49YsA@mail.gmail.com>	<1282508953.3042.102.camel@mulgrave.site>	<4C727BEB.9020100@scalableinformatics.com>	<AANLkTim-M6dfLvJQnbieFqZCGG33E+-i+u_soCq2p9f1@mail.gmail.com>	<AANLkTinDY8hEABHaPsCC+3wGMCn0ZLcyfDa9U9jXJ3d4@mail.gmail.com>	<AANLkTim+fj-OL+Bixfbrxv6AgSVv_NpT-KdG6vrc6ub-@mail.gmail.com>	<20100824072557.GK2804@reaktio.net>	<4C7404C4.4040704@vlnb.net> <AANLkTin85yqvykJPW=Zk46m2hA=n2wTRamYodRgMZCVM@mail.gmail.com>
In-Reply-To: <AANLkTin85yqvykJPW=Zk46m2hA=n2wTRamYodRgMZCVM@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:GjNEcN/X2VYXSzWJ3ULJ1pYnqyrMW5JE7yiYP9EnzxN
 m4voMtjN5WbI1ggi8XsidB1l/VrCotv0MF7LyrWzrCJ3hvdytD
 JngFRCODs0NpUGqZl1o/s3B75jWpm49pYavcegSGTz2yq5EYf5
 gOHzIvt2kd4g46FKYYuqX5ryBoRKP8adoh4MZzslCmCHBIYMYT
 EpH7EGXm8iT6oca9DmpIQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Worley, on 08/25/2010 12:31 AM wrote:
>> I also have an impression that Linux I/O subsystem has some performance
>> problems. For instance, in one recent SCST performance test only 8 Linux
>> initiators with fio as a load generator were able to saturate a single SCST
>> target with dual IB cards (SRP) on 4K AIO direct accesses over an SSD
>> backend. This rawly means that any initiator took several times (8?) more
>> processing time than the target.
>
> While I can't tell you where the bottlenecks are, I can share some
> performance numbers...
>
> 4 initiators can get>600K random 4KB IOPS off a single target...

Hmm, on the data you sent me only 8 initiators were capable to do so... 
I'm glad to see an improvement here ;).

> which is ~150% of what the Emulex/Intel/Microsoft results show using 8
> targets at 4KB (their 1M IOPS was at 512 byte blocks, which is not a
> realistic test point

 From my, a storage developer's, POV it isn't about if this test is 
realistic or not. 512 bytes tests are good if you want to test how 
processing effective your I/O stack, because they produce the max 
possible CPU/memory/hardware interaction load. Since processing power 
isn't unlimited, in case if it is a bottleneck, N IOPS on 512b < N IOPS 
on 4K * 8 and system with more effective processing will have better 
numbers.

Vlad
