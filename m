Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758461Ab1D1JwV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 05:52:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14140 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758246Ab1D1JwM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 05:52:12 -0400
From: Gleb Natapov <gleb@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: paulmck@linux.vnet.ibm.com, avi@redhat.com, mtosatti@redhat.com,
        kvm@vger.kernel.org
Subject: [PATCH 0/2] make kvm guest mode to be rcu quiescent state
Date: Thu, 28 Apr 2011 12:52:01 +0300
Message-Id: <1303984323-3203-1-git-send-email-gleb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CPU may spend a lot of time in a guest mode while other CPUs wait for
rcu grace period to elapse. This patch series makes guest mode into
quiescent state to shorten wait time.

Gleb Natapov (2):
  rcu: export rcu_note_context_switch() function
  KVM: make guest mode entry to be rcu quiescent state

 include/linux/kvm_host.h |    1 +
 include/linux/rcutiny.h  |    6 +-----
 kernel/rcutiny.c         |    7 +++++++
 kernel/rcutree.c         |    1 +
 4 files changed, 10 insertions(+), 5 deletions(-)

-- 
1.7.2.3

