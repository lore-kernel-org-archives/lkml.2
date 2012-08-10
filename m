Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758965Ab2HJVmS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 17:42:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48069 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753645Ab2HJVmR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 17:42:17 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Andi Kleen <andi.kleen@intel.com>, Wu Fengguang <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Tony Luck <tony.luck@intel.com>, Rik van Riel <riel@redhat.com>,
        "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
        Naoya Horiguchi <nhoriguc@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/3 v1] HWPOISON: improve dirty pagecache error handling
Date: Fri, 10 Aug 2012 17:41:50 -0400
Message-Id: <1344634913-13681-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patchset is to improve handling and reporting of memory errors on
dirty pagecache.

Patch 1 is to fix a messaging bug, and patch 2 is to temporarily undo
the code which can happen the data lost.  I think these two are obvious
fixes so I want to push them to merge promptly.

Patch 3 is for a new feature. The problem in error reporting (where AS_EIO
we rely on to report the error to userspace is cleared once checked) is
discussed when hwpoison core patches were reviewed, and we left it unfixed
because it can be fixed with more generic solution which covers legacy EIO.
But in my opinion, legacy EIO and hwpoison are different in how it can or
should be handled (for example, as described in patch 3, we can recover
from memory errors on dirty pagecache with overwriting.) So this patch
only solves the problem of memory error reporting.

My test for this patchset is available on:
https://github.com/Naoya-Horiguchi/test_memory_error_on_dirty_pagecache.git

Could you review or comment?

Thanks,
Naoya
