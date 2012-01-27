Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474Ab2A0GVN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 01:21:13 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:53182 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747Ab2A0GVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 01:21:10 -0500
X-AuditID: b753bd60-9a062ba00000359c-5d-4f224253930d
X-AuditID: b753bd60-9a062ba00000359c-5d-4f224253930d
Message-ID: <4F22424E.8070407@hitachi.com>
Date: Fri, 27 Jan 2012 15:21:02 +0900
From: HAYASAKA Mitsuo <mitsuo.hayasaka.hu@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
Cc: Ben Myers <bpm@sgi.com>, Alex Elder <aelder@sgi.com>,
        Christoph Hellwig <hch@lst.de>, xfs-masters@oss.sgi.com,
        linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [PATCH 0/3] xfs: change available ranges in quota check
References: <20120123034513.3339.97432.stgit@ltc219.sdl.hitachi.co.jp> <20120124174612.GC9853@infradead.org>
In-Reply-To: <20120124174612.GC9853@infradead.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,

(2012/01/25 2:46), Christoph Hellwig wrote:
> On Mon, Jan 23, 2012 at 12:45:14PM +0900, Mitsuo Hayasaka wrote:
>> Hi,
>>
>> This patch series changes available ranges of softlimit and
>> hardlimit in quota check, as follows.
>>
>> (1) Consider new reservation for quota check
>>     The disk block reservation checks if (current usage + new
>>     reservation) reach the quota limit although the inode reservation
>>     does not use the new reservation for quota check. It should
>>     consider it, as well. This is mandatory for (2).
> 
> Can you send a testcase that reproduces issues with the old behaviour?
> 

Regarding (1) related to inode reservation, current xfs works well
because inode is reserved one by one if required.

For example, when an new inode tries to be reserved in xfs_trans_dqresv(),
it checks quota as follows.

if (ninos > 0) {	// ninos: # of new inodes expected to be allocated.
	if (cur_usage >= limit)
		goto error;

	cur_usage += ninos;
}

It checks only current usage, but this code works well since the caller
always set the argument ninos to 1 or 0 in current xfs. So, inode can be
used up to the limits due to the one by one reservation.

To make it more general, this check should be the same way as the new
block quota check introduced in the PATCH 2/3 where the disk block can
be used up to the block quota limits.

So, this part is a kind of cleanup patch. I'm going to split the part
into another patch, and to send a new patch series.

Thanks.
