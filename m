Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461Ab1EDNbI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 09:31:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40942 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750748Ab1EDNbH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 09:31:07 -0400
From: Gleb Natapov <gleb@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: avi@redhat.com, mtosatti@redhat.com, kvm@vger.kernel.org,
        paulmck@linux.vnet.ibm.com
Subject: [PATCH 0/2] make kvm guest mode to be rcu quiescent state
Date: Wed,  4 May 2011 16:31:02 +0300
Message-Id: <1304515864-17105-1-git-send-email-gleb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CPU may spend a lot of time in a guest mode while other CPUs wait for
rcu grace period to elapse. This patch series makes guest mode into
quiescent state to shorten wait time.

Gleb Natapov (2):
  rcu: provide rcu_virt_note_context_switch() function.
  KVM: make guest mode entry to be rcu quiescent state

 include/linux/kvm_host.h |    9 +++++++++
 include/linux/rcutiny.h  |    8 ++++++++
 include/linux/rcutree.h  |   10 ++++++++++
 kernel/rcutree.c         |    1 +
 4 files changed, 28 insertions(+), 0 deletions(-)

-- 
1.7.4.4

