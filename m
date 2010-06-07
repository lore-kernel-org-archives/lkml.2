Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932446Ab0FGIa1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 04:30:27 -0400
Received: from daytona.panasas.com ([67.152.220.89]:28377 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751666Ab0FGIaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 04:30:22 -0400
Message-ID: <4C0CAE14.1020205@panasas.com>
Date: Mon, 07 Jun 2010 11:30:12 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: Christof Schmitt <christof.schmitt@de.ibm.com>, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       lsf10-pc@lists.linuxfoundation.org, Nick Piggin <npiggin@suse.de>,
       Al Viro <viro@ZenIV.linux.org.uk>, Chris Mason <chris.mason@oracle.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       "Martin K. Petersen" <martin.petersen@oracle.com>,
       Ric Wheeler <rwheeler@redhat.com>,
       Matthew Wilcox <willy@linux.intel.com>,
       Vladislav Bolkhovitin <vst@vlnb.net>, Christoph Hellwig <hch@lst.de>
Subject: Re: [LFS/VM TOPIC] Stable pages while IO (was Wrong DIF guard tag
 on ext2 write)
References: <20100531112817.GA16260@schmichrtp.mainz.de.ibm.com> <4C07D3D0.8010500@panasas.com> <20100604162332.GF3414@quack.suse.cz> <4C0B6BC7.8070803@panasas.com> <20100606233753.GC3302@quack.suse.cz>
In-Reply-To: <20100606233753.GC3302@quack.suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Jun 2010 08:30:17.0068 (UTC) FILETIME=[A87A92C0:01CB061B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/2010 02:37 AM, Jan Kara wrote:
>> With other none checksum fixtures, like RAID5/MIRROR this is not always
>> > an option and it becomes keep-constant vs copy. (That is complete
>> > workload copy). So for these setups the option is clear. No?
>
>   Is it? You can have enough CPU / memory bandwidth to do the copying while
> you need not be comfortable with a thread blocking until IO is finished
> when it tries to do a rewrite...
> 
>> I'm glad that you think it is easy/doable to implement. And I'll surly
>> test your above receipt. Do you think it would be acceptable as a generic
>> per-sb tunable.  So for instance an ext3 over RAID5 could turn this on
>> and eliminate the data copy?
>
>   Yes, that would be useful. At least so that one can get real performance
> numbers...
> 
> 									Honza

Thanks Jan.
You have helped me tremendously. I think I can begin to understand now what I
need to do.

With the workloads I need (HPC), every cycle/memory counts and that the app
waits for a rewrite is a good thing, which reminds me that I would want to trace
that case so applications could be fixed, tuned.

I do understand that for a desktop, that might be just the opposite, so testing
is important. Perhaps I'll need help in instrumenting all this.

Thanks
Boaz
