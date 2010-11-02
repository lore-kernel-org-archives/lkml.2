Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753106Ab0KCCvB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 22:51:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31010 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751392Ab0KCCu6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 22:50:58 -0400
Date: Tue, 2 Nov 2010 14:06:22 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Ravikiran G Thirumalai <kiran@scalex86.org>
Subject: lessen the impact of a deprecated warning in hugetlbfs
Message-ID: <20101102180622.GA12620@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Ravikiran G Thirumalai <kiran@scalex86.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WARN_ONCE is a bit strong for a deprecation warning, given that it spews a
huge backtrace.

Signed-off-by: Dave Jones <davej@redhat.com>

--- linux-2.6.36.noarch/fs/hugetlbfs/inode.c~	2010-11-02 14:01:19.489289082 -0400
+++ linux-2.6.36.noarch/fs/hugetlbfs/inode.c	2010-11-02 14:02:19.947986439 -0400
@@ -915,8 +915,7 @@ struct file *hugetlb_file_setup(const ch
 	if (creat_flags == HUGETLB_SHMFS_INODE && !can_do_hugetlb_shm()) {
 		*user = current_user();
 		if (user_shm_lock(size, *user)) {
-			WARN_ONCE(1,
-			  "Using mlock ulimits for SHM_HUGETLB deprecated\n");
+			printk_once("Using mlock ulimits for SHM_HUGETLB deprecated\n");
 		} else {
 			*user = NULL;
 			return ERR_PTR(-EPERM);
