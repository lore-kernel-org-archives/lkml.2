Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556Ab2A3XOZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 18:14:25 -0500
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:55675 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754475Ab2A3XOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 18:14:22 -0500
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH v2 0/4] PM / Freezer: Fix the semantics of thaw_processes()
 and thaw_kernel_threads()
To: rjw@sisk.pl
Cc: pavel@ucw.cz, len.brown@intel.com, tj@kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Date: Tue, 31 Jan 2012 04:44:11 +0530
Message-ID: <20120130231342.11129.87187.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12013023-2674-0000-0000-0000032BCBE3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the introduction of thaw_kernel_threads(), we can now finally fix the
semantics of thawing tasks, in such a way as to be just the opposite of
how tasks are frozen. This opens up some opportunities for code cleanup
as well. This patchset implements both of these improvements.

v2: Interchanged the ordering of patches 1 and 2 and transferred a small
    comment between them. No code changes.
--
 Srivatsa S. Bhat (4):
      PM/Freezer: Use thaw_kernel_threads() in preparation for changes to thaw_processes()
      PM/Freezer: Make thaw_processes() thaw only userspace tasks
      PM/Hibernate: Thaw kernel threads in hibernation_snapshot() in error/test path
      PM/Hibernate: Refactor and simplify freezer_test_done


  kernel/power/hibernate.c |   22 +++++++++++++++-------
 kernel/power/power.h     |   15 +++++++++++++--
 kernel/power/process.c   |   13 ++++++-------
 kernel/power/user.c      |   20 ++++++++++++--------
 4 files changed, 46 insertions(+), 24 deletions(-)


Regards,
Srivatsa S. Bhat
IBM Linux Technology Center

