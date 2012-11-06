Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751785Ab2KFLcP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 06:32:15 -0500
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:34990 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751147Ab2KFLcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 06:32:13 -0500
From: Thomas Hellstrom <thellstrom@vmware.com>
To: airlied@gmail.com, airlied@redhat.com
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] drm/ttm: Get rid of a number of atomic read-modify-write ops v3
Date: Tue,  6 Nov 2012 12:31:47 +0100
Message-Id: <1352201511-6383-1-git-send-email-thellstrom@vmware.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A patch series for next that removes a substantial number of read-modify-write
operations from TTM command submission, in particular if TTM objects are used
to export objects to user-space. The only per-object atomic r-m-w operations
left during a typical execbuf call should be refcount up and down.

v2: Formatting fixes.
v3: Invert the return value of kref_get_unless_zero.
    Add a comment in the commit message to patch 4 that it may be obsoleted.

