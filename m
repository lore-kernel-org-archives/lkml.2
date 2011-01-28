Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752290Ab1A1FtQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 00:49:16 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:57998 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345Ab1A1FtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 00:49:15 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.5.1
Message-ID: <4D42599E.9020004@np.css.fujitsu.com>
Date: Fri, 28 Jan 2011 14:52:30 +0900
From: Jin Dongming <jin.dongming@np.css.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; ja; rv:1.9.2.7) Gecko/20100713 Thunderbird/3.1.1
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>, Andrea Arcangeli <aarcange@redhat.com>
CC: =?ISO-2022-JP?B?QUtQTRskQiEhGyhC?= <akpm@linux-foundation.org>,
        Huang Ying <ying.huang@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        LKLM <linux-kernel@vger.kernel.org>
Subject: [PATCH -v2 0/3] Patchset for fixing poison failure of THP.
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I found the following problems while testing the poison of THP:
    1. If the poisoned THP is failed to be split, the process could not be
       killed.
    2. The reported address with sigbus is the address of the head page.
       This will make that the unexpected process on Guest OS(running on KVM)
       to be killed.
    3. The test of poisoned tail page always fails. This is because the lru
       check of THP is done always, though the tail page is not set with
       PG_lru flag.

To resolve the above problems, I made the following patches.

Jin Dongming (3):
      [PATCH 1/3] Fix splitting poisoned THP.
      [PATCH 2/3] Fix the wrong reported address of poisoned THP.
      [PATCH 3/3] Fix unsuitable behavior for poisoned tail pages of THP.

 mm/huge_memory.c    |    7 ++++-
 mm/memory-failure.c |   84 +++++++++++++++++++++++++++++++++++++++-----------
 2 files changed, 71 insertions(+), 20 deletions(-)

