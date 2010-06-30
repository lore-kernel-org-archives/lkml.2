Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481Ab0F3KZH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 06:25:07 -0400
Received: from daytona.panasas.com ([67.152.220.89]:13807 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751947Ab0F3KZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 06:25:05 -0400
Message-ID: <4C2B1B7D.2090607@panasas.com>
Date: Wed, 30 Jun 2010 13:25:01 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
CC: James Bottomley <James.Bottomley@suse.de>,
       Mike Snitzer <snitzer@redhat.com>, axboe@kernel.dk, dm-devel@redhat.com,
       linux-kernel@vger.kernel.org, martin.petersen@oracle.com,
       akpm@linux-foundation.org, linux-scsi@vger.kernel.org,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 1/2] block: fix leaks associated with discard request
 payload
References: <20100622180029.GA15950@redhat.com> <1277582211-10725-1-git-send-email-snitzer@redhat.com> <1277652576.4366.19.camel@mulgrave.site> <4C2B012B.2000407@panasas.com> <20100630084204.GA27609@lst.de>
In-Reply-To: <20100630084204.GA27609@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Jun 2010 10:25:04.0894 (UTC) FILETIME=[8171A9E0:01CB183E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/30/2010 11:42 AM, Christoph Hellwig wrote:
> On Wed, Jun 30, 2010 at 11:32:43AM +0300, Boaz Harrosh wrote:
>> May I ask a silly question? Why the dynamic allocation?
>>
>> Why not have a const-static single global page at the block-layer somewhere
>> that will be used for all discard-type operations and be done with it once and
>> for all. A single page can be used for any size bio , any number of concurrent
>> discards, any ZERO needed operation. It can also be used by other operations
>> like padding and others. In fact isn't there one for the libsata padding?
> 
> for UNMAP we need to write into the payload.  And for ATA TRIM we need
> to write into the WRITE SAME payload.  

OK, Thanks, I see. Is it one of these operations, (like we have in OSD) where
the CDB information spills into the payload? like the scatter-gather and extent
lists and such. Do we actually use a WRITE_SAME which is not zero? for what use?

> That's another layering violation
> for those looking for them, btw..
> 

Agreed
