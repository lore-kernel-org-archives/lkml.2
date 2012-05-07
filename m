Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756542Ab2EGLkF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 07:40:05 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:50909 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756489Ab2EGLiO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 07:38:14 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Gavin Shan <shangw@linux.vnet.ibm.com>, David Miller <davem@davemloft.net>,
        Yinghai Lu <yinghai@kernel.org>, Tejun Heo <tj@kernel.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [patch 00/10] (no)bootmem bits for 3.5
Date: Mon,  7 May 2012 13:37:42 +0200
Message-Id: <1336390672-14421-1-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

here are some (no)bootmem fixes and cleanups for 3.5.  Most of it is
unifying allocation behaviour across bootmem and nobootmem when it
comes to respecting the specified allocation address goal and numa.

But also refactoring the codebases of the two bootmem APIs so that we
can think about sharing code between them again.

 include/linux/bootmem.h |    3 ---
 mm/bootmem.c            |  118 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-------------------------------------------------------
 mm/nobootmem.c          |  112 ++++++++++++++++++++++++++++++++++++++++++++++++++++------------------------------------------------------------
 mm/sparse.c             |   25 ++++++++++++-------------
 4 files changed, 127 insertions(+), 131 deletions(-)

