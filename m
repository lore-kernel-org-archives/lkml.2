Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751766Ab0FWJbs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 05:31:48 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:62396 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059Ab0FWJbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 05:31:46 -0400
Message-ID: <4C21D442.8080703@oracle.com>
Date: Wed, 23 Jun 2010 17:30:42 +0800
From: Tao Ma <tao.ma@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: axboe@kernel.dk, vgoyal@redhat.com, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org
Subject: Re: [PATCH 0/3 v5][RFC] ext3/4: enhance fsync performance when using
 CFQ
References: <1277242502-9047-1-git-send-email-jmoyer@redhat.com>
In-Reply-To: <1277242502-9047-1-git-send-email-jmoyer@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090204.4C21D474.0043:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeff,

On 06/23/2010 05:34 AM, Jeff Moyer wrote:
> Hi,
>
> Running iozone with the fsync flag, or fs_mark, the performance of CFQ is
> far worse than that of deadline for enterprise class storage when dealing
> with file sizes of 8MB or less.  I used the following command line as a
> representative test case:
>
>    fs_mark -S 1 -D 10000 -N 100000 -d /mnt/test/fs_mark -s 65536 -t 1 -w 4096 -F
>
> When run using the deadline I/O scheduler, an average of the first 5 numbers
> will give you 448.4 files / second.  CFQ will yield only 106.7.  With
> this patch series applied (and the two patches I sent yesterday), CFQ now
> achieves 462.5 files / second.
which 2 patches? Could you paste the link or the subject? Just want to 
make my test env like yours. ;)
As Joel mentioned in another mail, ocfs2 also use jbd/jbd2, so I'd like 
to give it a try and give you some feedback about the test.

Regards,
Tao
>
> This patch set is still an RFC.  I'd like to make it perform better when
> there is a competing sequential reader present.  For now, I've addressed
> the concerns voiced about the previous posting.
>
> Review and testing would be greatly appreciated.
>
> Thanks!
> Jeff
>
> ---
>
> New from the last round:
>
> - removed the think time calculation I added for the sync-noidle service tree
> - replaced above with a suggestion from Vivek to only guard against currently
>    active sequential readers when determining if we can preempt the sync-noidle
>    service tree.
> - bug fixes
>
> Over all, I think it's simpler now thanks to the suggestions from Jens and
> Vivek.
>
> [PATCH 1/3] block: Implement a blk_yield function to voluntarily give up the I/O scheduler.
> [PATCH 2/3] jbd: yield the device queue when waiting for commits
> [PATCH 3/3] jbd2: yield the device queue when waiting for journal commits
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
