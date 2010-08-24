Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755147Ab0HXOn0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 10:43:26 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:62167 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071Ab0HXOnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 10:43:24 -0400
Message-ID: <4C73DA91.9040101@vlnb.net>
Date: Tue, 24 Aug 2010 18:43:29 +0400
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100527 Thunderbird/3.0.5
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Pasi_K=E4rkk=E4inen?= <pasik@iki.fi>
CC: Chetan Loke <chetanloke@gmail.com>, Bart Van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        James Bottomley <James.Bottomley@suse.de>,
        scst-devel <scst-devel@lists.sourceforge.net>
Subject: Re: Linux I/O subsystem performance (was: linuxcon 2010...)
References: <8A96806D-6CD7-44AD-8A9D-143C098C95A4@uni-paderborn.de> <1282256949.30453.278.camel@haakon2.linux-iscsi.org> <4C701E08.2020005@vlnb.net> <1282423398.3015.39.camel@mulgrave.site> <AANLkTikcReFsYMhs1RkCHoRkL1+Q9WuptHj1xbx49YsA@mail.gmail.com> <1282508953.3042.102.camel@mulgrave.site> <4C727BEB.9020100@scalableinformatics.com> <AANLkTim-M6dfLvJQnbieFqZCGG33E+-i+u_soCq2p9f1@mail.gmail.com> <AANLkTinDY8hEABHaPsCC+3wGMCn0ZLcyfDa9U9jXJ3d4@mail.gmail.com> <AANLkTim+fj-OL+Bixfbrxv6AgSVv_NpT-KdG6vrc6ub-@mail.gmail.com> <20100824072557.GK2804@reaktio.net>
In-Reply-To: <20100824072557.GK2804@reaktio.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Provags-ID: V02:K0:v4+NgGUk6brmdgDBQzr11aYYbzaWSediOrmudRoObsE
 A0TIrsqzN4bTS9XVnaGL9iXVk95OyuuKQMhA9PvJBwaL/WUi1N
 LckDQ6CsvtVW7j17jMSADyR0UMRiu1/3oajZdFWx5n51t9p4u3
 m269prpLJoazPCJTevu/fmyJLO6t4cxWC2yfphdobu1ZpZ20hx
 Fg3zpAa8BaWW0NKrul1eQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pasi Kärkkäinen, on 08/24/2010 11:25 AM wrote:
> On Mon, Aug 23, 2010 at 02:03:26PM -0400, Chetan Loke wrote:
>> I actually received 3+ off-post emails asking whether I was talking
>> about initiator or target in the 100K IOPS case below and what did I
>> mean by the ACKs.
>> I was referring to the 'Initiator' side.
>> ACKs == When scsi-ML down-calls the LLD via the queue-command, process
>> the sgl's(if you like) and then trigger the scsi_done up-call path.
>>
>
> Uhm, Intel and Microsoft demonstrated over 1 million IOPS
> using software iSCSI and a single 10 Gbit Ethernet NIC (Intel 82599).
>
> How come there is such a huge difference? What are we lacking in Linux?

I also have an impression that Linux I/O subsystem has some performance 
problems. For instance, in one recent SCST performance test only 8 Linux 
initiators with fio as a load generator were able to saturate a single 
SCST target with dual IB cards (SRP) on 4K AIO direct accesses over an 
SSD backend. This rawly means that any initiator took several times (8?) 
more processing time than the target. Hardware used for that target and 
initiators was the same. I can't see on this load why the initiators 
would need to do something more than the target. Well, I know we in SCST 
did an excellent work to maximize performance, but such a difference 
looks too much ;)

Also it looks very suspicious why nobody even tried to match that 
Microsoft/Intel record, even Intel itself who closely works with Linux 
community in the storage area and could do it using the same hardware.

Vlad
