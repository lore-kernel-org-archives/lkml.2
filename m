Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932208Ab0FCRl2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 13:41:28 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:56921 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756914Ab0FCRl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 13:41:26 -0400
Message-ID: <4C07E960.2040303@vlnb.net>
Date: Thu, 03 Jun 2010 21:41:52 +0400
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Thunderbird 2.0.0.23 (X11/20090825)
MIME-Version: 1.0
To: Boaz Harrosh <bharrosh@panasas.com>
CC: Christof Schmitt <christof.schmitt@de.ibm.com>, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       lsf10-pc@lists.linuxfoundation.org, Nick Piggin <npiggin@suse.de>,
       Al Viro <viro@ZenIV.linux.org.uk>, Chris Mason <chris.mason@oracle.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       "Martin K. Petersen" <martin.petersen@oracle.com>,
       Ric Wheeler <rwheeler@redhat.com>,
       Matthew Wilcox <willy@linux.intel.com>, Christoph Hellwig <hch@lst.de>
Subject: Re: [LFS/VM TOPIC] Stable pages while IO (was Wrong DIF guard tag
 on ext2 write)
References: <20100531112817.GA16260@schmichrtp.mainz.de.ibm.com> <4C07D3D0.8010500@panasas.com>
In-Reply-To: <4C07D3D0.8010500@panasas.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1/ybd/oeQf9OPnxiiKBOx3wGzaOfefhqVW0Au8
 7Wfi3oVef977bpIhZNa9thISjUtaSGhxO8QYyl8fEsjijdK2TG
 d0mUK2kqpfJTcLFGvMeVQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Boaz Harrosh, on 06/03/2010 08:09 PM wrote:
> [Topic]
> How to not let pages change while in IO
> 
> [Abstract]
> As seen in a long thread on the fsdvel scsi mailing lists. Lots of
> people have headaches and sleep less nights because individual pages
> can change while in IO and/or DMA. Though each one as slightly different
> needs, the mechanics look to be the same.
> 
> People that care:
> - Mirror and RAID people that need on disk consistency.
> - Network storage that wants data checksum.
> - DIF/DIX people

  - Load balancing MPIO clusters, where out of order execution of 
overlapping write requests for the changed pages can introduce a data 
corruption, which makes using Linux with load balancing MPIO clusters 
unsafe.

> - ...
> 
> I for one know nothing of the subject but am a RAID person and would
> like a solution that does not force me to copy the complete data load.
> 
> Please lets get all the VM VFS and drivers people in one room and see
> if we can have a Linux solution to this problem
> 
> Boaz
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

