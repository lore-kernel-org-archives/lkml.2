Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758127Ab0LMVxt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 16:53:49 -0500
Received: from sj-iport-4.cisco.com ([171.68.10.86]:11676 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758013Ab0LMVxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 16:53:46 -0500
Authentication-Results: sj-iport-4.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAD8lBk2rR7Ht/2dsb2JhbACkDHinYptThUoEhGSGFQ
X-IronPort-AV: E=Sophos;i="4.59,338,1288569600"; 
   d="scan'208";a="231975975"
From: Roland Dreier <rdreier@cisco.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
X-Message-Flag: Warning: May contain useful information
Date: Mon, 13 Dec 2010 13:53:36 -0800
Message-ID: <ada4oahibkv.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

Just a one thing here: a fix for a user-triggerable integer overflow
as a well as a leak of a few bytes of kernel memory.  The severity is
not too high here as actually hitting this requires a system with real
RDMA hardware, and the user must be granted direct access to that hardware.

Dan Carpenter (1):
      IB/uverbs: Handle large number of entries in poll CQ

 drivers/infiniband/core/uverbs_cmd.c |  101 +++++++++++++++++++---------------
 1 files changed, 57 insertions(+), 44 deletions(-)
