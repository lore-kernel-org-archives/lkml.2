Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756418Ab0FCQKG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 12:10:06 -0400
Received: from daytona.panasas.com ([67.152.220.89]:64323 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756029Ab0FCQKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 12:10:00 -0400
Message-ID: <4C07D3D0.8010500@panasas.com>
Date: Thu, 03 Jun 2010 19:09:52 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Christof Schmitt <christof.schmitt@de.ibm.com>, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       lsf10-pc@lists.linuxfoundation.org, Nick Piggin <npiggin@suse.de>,
       Al Viro <viro@ZenIV.linux.org.uk>, Chris Mason <chris.mason@oracle.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       "Martin K. Petersen" <martin.petersen@oracle.com>,
       Ric Wheeler <rwheeler@redhat.com>,
       Matthew Wilcox <willy@linux.intel.com>,
       Vladislav Bolkhovitin <vst@vlnb.net>, Christoph Hellwig <hch@lst.de>
Subject: [LFS/VM TOPIC] Stable pages while IO (was Wrong DIF guard tag on
 ext2 write)
References: <20100531112817.GA16260@schmichrtp.mainz.de.ibm.com>
In-Reply-To: <20100531112817.GA16260@schmichrtp.mainz.de.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Jun 2010 16:09:59.0300 (UTC) FILETIME=[371E2C40:01CB0337]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Topic]
How to not let pages change while in IO

[Abstract]
As seen in a long thread on the fsdvel scsi mailing lists. Lots of
people have headaches and sleep less nights because individual pages
can change while in IO and/or DMA. Though each one as slightly different
needs, the mechanics look to be the same.

People that care:
- Mirror and RAID people that need on disk consistency.
- Network storage that wants data checksum.
- DIF/DIX people
- ...

I for one know nothing of the subject but am a RAID person and would
like a solution that does not force me to copy the complete data load.

Please lets get all the VM VFS and drivers people in one room and see
if we can have a Linux solution to this problem

Boaz
