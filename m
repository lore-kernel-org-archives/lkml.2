Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751866Ab1KDUK5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 16:10:57 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:59568 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029Ab1KDUKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 16:10:55 -0400
Subject: [GIT PULL] ib_srpt: Initial SRP Target merge for v3.2-rc1
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Roland Dreier <roland@purestorage.com>, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bart.vanassche@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Nov 2011 13:10:52 -0700
Message-ID: <1320437452.5859.96.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This is the PULL request for an initial merge of the ib_srpt driver
using mainline target infrastructure into v3.2-rc1.  Please go ahead and
pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git for-next-merge

Note that 'target: Updates for v3.2-rc1 (round two)' should be pulled
first via target-pending.git/for-next, and has gone out in a separate
PULL request. 

At this point should we should have a stable userspace API for the
layout of /sys/kernel/config/target/srpt/, and a number of legacy module
parameters have been removed or converted into per endpoint attributes
as per Roland's feedback.  This code has been getting build testing in
next the past week, and does not touch any external code.

There is an known issue with active I/O shutdown is currently being
addressed using the new generic active I/O shutdown bits in for-next,
and will be sent out post merge after more testing and feedback.  I also
see a few patches from DanC this morning to address a handful of non
critical issues that will be included post merge as well.

Here are full set of review changes from Roland and Bart that have been
made:

v1 -> v2 review changes:

ib_srpt: Fix potential out-of-bounds array access
ib_srpt: Avoid failed multipart RDMA transfers
ib_srpt: Fix srpt_alloc_fabric_acl failure case return value
ib_srpt: Update comments to reference $driver/$port layout
ib_srpt: Fix sport->port_guid formatting code
ib_srpt: Remove legacy use_port_guid_in_session_name module parameter
ib_srpt: Convert srp_max_rdma_size into per port configfs attribute
ib_srpt: Convert srp_max_rsp_size into per port configfs attribute
ib_srpt: Convert srpt_sq_size into per port configfs attribute

v2 -> v3 review changes:

ib_srpt: Fix possible race with srp_sq_size in srpt_create_ch_ib
ib_srpt: Fix possible race with srp_max_rsp_size in srpt_release_channel_work
ib_srpt: Fix up MAX_SRPT_RDMA_SIZE define
ib_srpt: Make srpt_map_sg_to_ib_sge() failure case return -EAGAIN
ib_srpt: Convert port_guid to use subnet_prefix + interface_id formatting
ib_srpt: Make srpt_check_stop_free return kref_put status

Thanks!

--nab

Bart Van Assche (1):
  ib_srpt: Initial SRP Target merge for v3.2-rc1

 drivers/infiniband/Kconfig              |    1 +
 drivers/infiniband/Makefile             |    1 +
 drivers/infiniband/ulp/srpt/Kconfig     |   12 +
 drivers/infiniband/ulp/srpt/Makefile    |    2 +
 drivers/infiniband/ulp/srpt/ib_dm_mad.h |  139 ++
 drivers/infiniband/ulp/srpt/ib_srpt.c   | 4081 +++++++++++++++++++++++++++++++
 drivers/infiniband/ulp/srpt/ib_srpt.h   |  444 ++++
 7 files changed, 4680 insertions(+), 0 deletions(-)
 create mode 100644 drivers/infiniband/ulp/srpt/Kconfig
 create mode 100644 drivers/infiniband/ulp/srpt/Makefile
 create mode 100644 drivers/infiniband/ulp/srpt/ib_dm_mad.h
 create mode 100644 drivers/infiniband/ulp/srpt/ib_srpt.c
 create mode 100644 drivers/infiniband/ulp/srpt/ib_srpt.h



