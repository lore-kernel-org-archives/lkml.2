Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524Ab1BILCU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 06:02:20 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:40717 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753829Ab1BILCT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 06:02:19 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <balbir@linux.vnet.ibm.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>
Subject: [patch 0/4] memcg: operate on page quantities internally
Date: Wed,  9 Feb 2011 12:01:49 +0100
Message-Id: <1297249313-23746-1-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 1.7.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this patch set converts the memcg charge and uncharge paths to operate
on multiples of pages instead of bytes.  It already was a good idea
before, but with the merge of THP we made a real mess by specifying
huge pages alternatingly in bytes or in number of regular pages.

If I did not miss anything, this should leave only res_counter and
user-visible stuff in bytes.  The ABI probably won't change, so next
up is converting res_counter to operate on page quantities.

	Hannes

 include/linux/sched.h |    4 +-
 mm/memcontrol.c       |  157 ++++++++++++++++++++++++-------------------------
 2 files changed, 78 insertions(+), 83 deletions(-)
