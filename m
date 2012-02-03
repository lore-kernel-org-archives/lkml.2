Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754264Ab2BCEGE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 23:06:04 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:44359 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429Ab2BCEGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 23:06:03 -0500
X-AuditID: b753bd60-97991ba000007b1b-5e-4f2b5d2715b5
X-AuditID: b753bd60-97991ba000007b1b-5e-4f2b5d2715b5
Message-ID: <4F2B5D25.1040601@hitachi.com>
Date: Fri, 03 Feb 2012 13:05:57 +0900
From: HAYASAKA Mitsuo <mitsuo.hayasaka.hu@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
Cc: Ben Myers <bpm@sgi.com>, Alex Elder <aelder@sgi.com>,
        Christoph Hellwig <hch@lst.de>, Alex Elder <elder@kernel.org>,
        linux-kernel@vger.kernel.org, xfs@oss.sgi.com, xfs-masters@oss.sgi.com
Subject: Re: [PATCH 3/3] xfs: cleanup quota check on disk blocks and inodes
 reservations
References: <20120123034513.3339.97432.stgit@ltc219.sdl.hitachi.co.jp> <20120123034543.3339.56848.stgit@ltc219.sdl.hitachi.co.jp> <20120202160726.GA10568@infradead.org>
In-Reply-To: <20120202160726.GA10568@infradead.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph

Thank you for your comments.

(2012/02/03 1:07), Christoph Hellwig wrote:
> On Mon, Jan 23, 2012 at 12:45:43PM +0900, Mitsuo Hayasaka wrote:
>> This patch is a cleanup of quota check on disk blocks and inodes
>> reservations.
>>
>> Signed-off-by: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
>> Cc: Ben Myers <bpm@sgi.com>
>> Cc: Alex Elder <elder@kernel.org>
>> Cc: Christoph Hellwig <hch@lst.de>
>> ---
>>
>>  fs/xfs/xfs_trans_dquot.c |   17 +++++++----------
>>  1 files changed, 7 insertions(+), 10 deletions(-)
>>
>> diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
>> index c4ba366..5e6cd1c 100644
>> --- a/fs/xfs/xfs_trans_dquot.c
>> +++ b/fs/xfs/xfs_trans_dquot.c
>> @@ -605,7 +605,7 @@ xfs_trans_dqresv(
>>  	time_t		timer;
>>  	xfs_qwarncnt_t	warns;
>>  	xfs_qwarncnt_t	warnlimit;
>> -	xfs_qcnt_t	count;
>> +	xfs_qcnt_t	tcount;
> 
> Can you call this variable total_count to make it a bit more obvious?

Sure.

> 
>> +			tcount = *resbcountp + nblks;
>> +			if (hardlimit > 0ULL && tcount > hardlimit) {
> 
> Given that xfs_qcnt_t is unsigned what about transforming this into the
> more readable:
> 
> 			if (hardlimit && total_count > hardlimit)
> 
> and similar for the others?
> 

OK, I'm going to change them and send the revised patch series.

Thanks.
