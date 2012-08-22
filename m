Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932884Ab2HVPSH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 11:18:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50978 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757334Ab2HVPSA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 11:18:00 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Andi Kleen <andi.kleen@intel.com>, Wu Fengguang <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Tony Luck <tony.luck@intel.com>, Rik van Riel <riel@redhat.com>,
        "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/3 v2] HWPOISON: improve dirty pagecache error reporting
Date: Wed, 22 Aug 2012 11:17:32 -0400
Message-Id: <1345648655-4497-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Based on the previous discussion, in this version I propose only error
reporting fix ("overwrite recovery" is sparated out from this series.)

I think Fengguang's patch (patch 2 in this series) has a corner case
about inode cache drop, so I added patch 3 for it.

Shortlog and diffstat

 Naoya Horiguchi (2):
       HWPOISON: fix action_result() to print out dirty/clean
       HWPOISON: prevent inode cache removal to keep AS_HWPOISON sticky
 
 Wu Fengguang (1):
       HWPOISON: report sticky EIO for poisoned file
 
  fs/inode.c              | 12 ++++++++++++
  include/linux/pagemap.h | 24 ++++++++++++++++++++++++
  mm/filemap.c            | 11 +++++++++++
  mm/memory-failure.c     | 24 ++++++++++--------------
  mm/truncate.c           |  2 ++
  5 files changed, 59 insertions(+), 14 deletions(-)

Thanks,
Naoya
