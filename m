Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754305Ab2FEH1k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 03:27:40 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:31360 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709Ab2FEH1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 03:27:39 -0400
From: Junxiao Bi <junxiao.bi@oracle.com>
To: ocfs2-devel@oss.oracle.com, linux-aio@kvack.org
Cc: jmoyer@redhat.com, mfasheh@suse.com, jlbec@evilplan.org, bcrl@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        joe.jin@oracle.com, dave.kleikamp@oracle.com
Subject: [V2]fix ocfs2 aio/dio writing process hang
Date: Tue,  5 Jun 2012 15:26:48 +0800
Message-Id: <1338881210-14863-1-git-send-email-junxiao.bi@oracle.com>
X-Mailer: git-send-email 1.7.9.5
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


V2 changes:
- update the patch header of the first patch to make it more clear.


This patch list fixes an issue about ocfs2 aio/dio write process hang.
The call trace is like this:
@  cat /proc/15913/stack
@ [<ffffffffa06e1085>] ocfs2_aiodio_wait+0x85/0xc0 [ocfs2]
@ [<ffffffffa06e3e39>] ocfs2_file_aio_write+0x99/0xa0 [ocfs2]
@ [<ffffffff811ace97>] aio_rw_vect_retry+0x87/0x150
@ [<ffffffff811aebd1>] aio_run_iocb+0x71/0x170
@ [<ffffffff811af59b>] io_submit_one+0x1ab/0x280
@ [<ffffffff811af77c>] do_io_submit+0x10c/0x1c0
@ [<ffffffff811af840>] sys_io_submit+0x10/0x20
@ [<ffffffff81509b42>] system_call_fastpath+0x16/0x1b
@ [<ffffffffffffffff>] 0xffffffffffffffff



