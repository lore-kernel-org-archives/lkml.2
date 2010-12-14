Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754923Ab0LNDaa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 22:30:30 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:62800 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753564Ab0LNDa3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 22:30:29 -0500
Message-ID: <4D06E4E8.8070807@cn.fujitsu.com>
Date: Tue, 14 Dec 2010 11:30:48 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: Vivek Goyal <vgoyal@redhat.com>, Corrado Zoccolo <czoccolo@gmail.com>,
        Chad Talbott <ctalbott@google.com>, Nauman Rafique <nauman@google.com>,
        Divyesh Shah <dpshah@google.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/8 v2] Introduce CFQ group hierarchical scheduling and
 "use_hierarchy"  interface
References: <4CDF7BC5.9080803@cn.fujitsu.com> <4CDF9CC6.2040106@cn.fujitsu.com> <20101115165319.GI30792@redhat.com> <4CE2718C.6010406@kernel.dk> <4D057A6A.8060000@cn.fujitsu.com> <4D062161.4010300@kernel.dk>
In-Reply-To: <4D062161.4010300@kernel.dk>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-12-14 11:30:23,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-12-14 11:30:25,
	Serialize complete at 2010-12-14 11:30:25
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On 2010-12-13 02:44, Gui Jianfeng wrote:
>> Hi
>>
>> Previously, I posted a patchset to add support of CFQ group hierarchical scheduling
>> in the way that it puts all CFQ queues in a hidden group and schedules with other 
>> CFQ group under their parent. The patchset is available here,
>> http://lkml.org/lkml/2010/8/30/30
>>
>> Vivek think this approach isn't so instinct that we should treat CFQ queues
>> and groups at the same level. Here is the new approach for hierarchical 
>> scheduling based on Vivek's suggestion. The most big change of CFQ is that
>> it gets rid of cfq_slice_offset logic, and makes use of vdisktime for CFQ
>> queue scheduling just like CFQ group does. But I still give cfqq some jump 
>> in vdisktime based on ioprio, thanks for Vivek to point out this. Now CFQ 
>> queue and CFQ group uses the same scheduling algorithm. 
>>
>> "use_hierarchy" interface is now added to switch between hierarchical mode
>> and flat mode. For this time being, this interface only appears in Root Cgroup.
>>
>> V1 -> V2 Changes:
>> - Raname "struct io_sched_entity" to "struct cfq_entity" and don't differentiate
>>   queue_entity and group_entity, just use cfqe instead. 
>> - Give newly added cfqq a small vdisktime jump accord to its ioprio.
>> - Make flat mode as default CFQ group scheduling mode.
>> - Introduce "use_hierarchy" interface.
>> - Update blkio cgroup documents
>>
>> [PATCH 1/8 v2] cfq-iosched: Introduce cfq_entity for CFQ queue
>> [PATCH 2/8 v2] cfq-iosched: Introduce cfq_entity for CFQ group
>> [PATCH 3/8 v2] cfq-iosched: Introduce vdisktime and io weight for CFQ queue
>> [PATCH 4/8 v2] cfq-iosched: Extract some common code of service tree handling for CFQ queue and CFQ group
>> [PATCH 5/8 v2] cfq-iosched: Introduce hierarchical scheduling with CFQ queue and group at the same level
>> [PATCH 6/8] blkio-cgroup: "use_hierarchy" interface without any functionality
>> [PATCH 7/8] cfq-iosched: Add flat mode and switch between two modes by "use_hierarchy"
>> [PATCH 8/8] blkio-cgroup: Document for blkio.use_hierarchy.
>>
>> Benchmarks:
>> I made use of Vivek's iostest to perform some benchmarks on my box. I tested different workloads, and
>> didn't see any performance drop comparing to vanilla kernel. The attached files are some performance
>> numbers on vanilla Kernel, patched kernel with flat mode and patched kernel with hierarchical mode.
> 
> I was going to apply this patchset now, but it doesn't apply to current
> for-2.6.38/core (#5 fails, git am stops there). Care to resend it
> against that branch? Thanks.

Sure.

Thanks,
Gui

> 


