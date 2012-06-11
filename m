Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752980Ab2FKJSB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 05:18:01 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:52355 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252Ab2FKJR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 05:17:59 -0400
From: kosaki.motohiro@gmail.com
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, Andrew Morton <akpm@google.com>,
        Dave Jones <davej@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Christoph Lameter <cl@linux.com>, stable@vger.kernel.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: [PATCH 0/6][resend] mempolicy memory corruption fixlet
Date: Mon, 11 Jun 2012 05:17:24 -0400
Message-Id: <1339406250-10169-1-git-send-email-kosaki.motohiro@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Hi

This is trivial fixes of mempolicy meory corruption issues. There
are independent patches each ather. and, they don't change userland
ABIs.

Thanks.

changes from v1: fix some typo of changelogs.

-----------------------------------------------
KOSAKI Motohiro (6):
  Revert "mm: mempolicy: Let vma_merge and vma_split handle
    vma->vm_policy linkages"
  mempolicy: Kill all mempolicy sharing
  mempolicy: fix a race in shared_policy_replace()
  mempolicy: fix refcount leak in mpol_set_shared_policy()
  mempolicy: fix a memory corruption by refcount imbalance in
    alloc_pages_vma()
  MAINTAINERS: Added MEMPOLICY entry

 MAINTAINERS    |    7 +++
 mm/mempolicy.c |  151 ++++++++++++++++++++++++++++++++++++++++----------------
 mm/shmem.c     |    9 ++--
 3 files changed, 120 insertions(+), 47 deletions(-)

