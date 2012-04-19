Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756489Ab2DSVGz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 17:06:55 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38883 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756215Ab2DSVGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 17:06:52 -0400
Message-Id: <20120419210306.269894183@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 19 Apr 2012 14:03:40 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alexey Shvetsov <alexxy@gentoo.org>,
        Roland Dreier <roland@purestorage.com>
Subject: [ 37/75] IB/srpt: Set srq_type to IB_SRQT_BASIC
In-Reply-To: <20120419210322.GA6478@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roland Dreier <roland@purestorage.com>

commit 6f3603367b8f7c34598fdfc1058622e0e1951e98 upstream.

Since commit 96104eda0169 ("RDMA/core: Add SRQ type field"), kernel
users of SRQs need to specify srq_type = IB_SRQT_BASIC in struct
ib_srq_init_attr, or else most low-level drivers will fail in
when srpt_add_one() calls ib_create_srq() and gets -ENOSYS.

(mlx4_ib works OK nearly all of the time, because it just needs
srq_type != IB_SRQT_XRC.  And apparently nearly everyone using
ib_srpt is using mlx4 hardware)

Reported-by: Alexey Shvetsov <alexxy@gentoo.org>
Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/ulp/srpt/ib_srpt.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -3225,6 +3225,7 @@ static void srpt_add_one(struct ib_devic
 	srq_attr.attr.max_wr = sdev->srq_size;
 	srq_attr.attr.max_sge = 1;
 	srq_attr.attr.srq_limit = 0;
+	srq_attr.srq_type = IB_SRQT_BASIC;
 
 	sdev->srq = ib_create_srq(sdev->pd, &srq_attr);
 	if (IS_ERR(sdev->srq))


