Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754932Ab2JPP76 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 11:59:58 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35298 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754371Ab2JPP75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 11:59:57 -0400
From: Ming Lei <ming.lei@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Alan Stern <stern@rowland.harvard.edu>, Oliver Neukum <oneukum@suse.de>,
        Minchan Kim <minchan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-pm@vger.kernel.org
Subject: [RFC PATCH v1 0/3] mm/PM/USB: memory allocation with no io in need
Date: Tue, 16 Oct 2012 23:59:40 +0800
Message-Id: <1350403183-12650-1-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch set introduces one process flag and trys to fix one deadlock
problem on block device during runtime resume or usb bus reset.

The 1st one is the change on include/sched.h and mm.

The other 2 patches are applied again PM and USB subsystem to demo
how to use the introduced mechanism to fix the deadlock problem.

V1:
        - take Minchan's change to avoid the check in alloc_page hot path
	- change the helpers' style into save/restore as suggested by Alan
	- memory allocation with no io in usb bus reset path for all devices
	as suggested by Greg and Oliver


 drivers/base/power/runtime.c |   14 ++++++++++++++
 drivers/usb/core/hub.c       |   11 +++++++++++
 include/linux/sched.h        |   11 +++++++++++
 mm/page_alloc.c              |   10 +++++++++-
 mm/vmscan.c                  |   13 +++++++++++++
 5 files changed, 58 insertions(+), 1 deletion(-)

Thanks,
--
Ming Lei

