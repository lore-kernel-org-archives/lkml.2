Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751719Ab0KATQx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 15:16:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18388 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751534Ab0KATQj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 15:16:39 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: dhowells@redhat.com, lizf@cn.fujitsu.com, paul.moore@hp.com,
        johannes@sipsolutions.net, dipankar@in.ibm.com
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        kvm@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 0/3] rcu - removing superfluous rcu_read_lock_held check
Date: Mon,  1 Nov 2010 20:15:06 +0100
Message-Id: <1288638909-10541-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

the rcu_dereference_check is defined as

  #define rcu_dereference_check(p, c) \
     __rcu_dereference_check((p), rcu_read_lock_held() || (c), __rcu)

so the caller does not need to specify rcu_read_lock_held()
condition.

Several places in kernel are spcifying rcu_read_lock_held as
rcu_dereference_check condition parameter.  I separated them
into 3 patches:

1/3 - cgroup - removing superfluous rcu_read_lock_held check
2/3 - kernel,cred,kvm,security - removing superfluous rcu_read_lock_held check
3/3 - net - removing superfluous rcu_read_lock_held check


sry if I might missed or added somebody wrongly to recipients

wbr,
jirka


Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 include/linux/cgroup.h             |    1 -
 include/linux/cred.h               |    1 -
 include/linux/fdtable.h            |    1 -
 include/linux/kvm_host.h           |    1 -
 include/linux/rtnetlink.h          |    3 +--
 include/net/sock.h                 |    3 +--
 kernel/cgroup.c                    |    6 ++----
 kernel/exit.c                      |    1 -
 kernel/pid.c                       |    1 -
 kernel/rcutorture.c                |    2 --
 net/mac80211/sta_info.c            |    4 ----
 net/netlabel/netlabel_domainhash.c |    3 +--
 net/netlabel/netlabel_unlabeled.c  |    3 +--
 security/keys/keyring.c            |    1 -
 14 files changed, 6 insertions(+), 25 deletions(-)
