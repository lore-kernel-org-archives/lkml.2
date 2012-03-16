Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755787Ab2CPTBL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 15:01:11 -0400
Received: from mga11.intel.com ([192.55.52.93]:12056 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752566Ab2CPTBI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 15:01:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="140089248"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Subject: Tree sweep for spin_is_locked misuses and start warning about it
Date: Fri, 16 Mar 2012 12:00:53 -0700
Message-Id: <1331924464-18023-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I did a tree sweep for spin_is_locked() users and many of them were
wrong, got UP incorrect, were obviously racy and had other problems.
I replaced a lot of users with calls to the correct lock debugging functions,
like lockdep_assert_held()

Generally I think spin_is_locked() should be deprecated because it 
is rarely used correctly. There are a few legitimate users so we cannot
outright remove it unfortunately.

But most users can be removed or changed.

After this start warning in checkpatch.pl for spin_is_locked() because
it's rarely wrong. Also error out there for the broken
(WARN|BUG)_ON(!spin_is_locked()) which does not work on UP builds.

-Andi

