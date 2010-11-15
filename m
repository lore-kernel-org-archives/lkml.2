Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757149Ab0KOAtv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 19:49:51 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:61993 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755027Ab0KOAtu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 19:49:50 -0500
Message-ID: <4CE083A7.3000906@cn.fujitsu.com>
Date: Mon, 15 Nov 2010 08:49:43 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <axboe@kernel.dk>
CC: linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Corrado Zoccolo <czoccolo@gmail.com>,
        Chad Talbott <ctalbott@google.com>, Nauman Rafique <nauman@google.com>,
        Divyesh Shah <dpshah@google.com>,
        Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: [RFC] [PATCH 0/8] cfq-iosched: Introduce hierarchical scheduling
 logic
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-15 08:50:13,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-15 08:50:14,
	Serialize complete at 2010-11-15 08:50:14
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Previously, I posted a patchset to add support of CFQ group hierarchical scheduling
in the way that it puts all CFQ queues in a hidden group and schedules with other 
CFQ group under their parent. The patchset is available here,
http://lkml.org/lkml/2010/8/30/30

Vivek think this approach isn't so instinct that we should treat CFQ queues
and groups at the same level. Here is the new approach for hierarchical 
scheduling based on Vivek's suggestion. The most big change of CFQ is that
it gets rid of cfq_slice_offset logic, and makes use of vdisktime for CFQ
queue scheduling just like CFQ group does. Now CFQ queue and CFQ group uses
the same scheduling algorithm. Later, a "use_hierarchy" interface should be
added to switch between hierarchical mode and flat mode.

Any comments are welcome.

[RFC] [PATCH 1/8] cfq-iosched: Introduce io_sched_entity for CFQ queue
[RFC] [PATCH 2/8] cfq-iosched: Introduce io_sched_entity for CFQ group
[RFC] [PATCH 3/8] cfq-iosched: Introduce vdisktime and io weight for CFQ queue
[RFC] [PATCH 4/8] cfq-iosched: Get rid of st->active
[RFC] [PATCH 5/8] cfq-iosched: Extract some common code of service tree handling for CFQ queue and CFQ group
[RFC] [PATCH 6/8] cfq-iosched: Get rid of on_st flag
[RFC] [PATCH 7/8] cfq-iosched: Enable deep hierarchy in CGgroup
[RFC] [PATCH 8/8] cfq-iosched: Introduce hierarchical scheduling with CFQ queue and group at the same level

Thanks,
Gui



