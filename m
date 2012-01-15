Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248Ab2AOCZ1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jan 2012 21:25:27 -0500
Received: from tundra.namei.org ([65.99.196.166]:44157 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751593Ab2AOCZZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jan 2012 21:25:25 -0500
Date: Sun, 15 Jan 2012 13:25:20 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: [GIT] Security updates for 3.3: SELinux
Message-ID: <alpine.LRH.2.00.1201151322240.1430@tundra.namei.org>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Due to a mixup, the SELinux tree wasn't merged into mine before the merge 
window, however, it has been in -next separately all along.

Please pull.

The following changes since commit 51be08419dc86c72486ac556aa39bc01026a403d:
  Linus Torvalds (1):
        Merge branch 'fbdev-next' of git://github.com/schandinat/linux-2.6

are available in the git repository at:

  git://selinuxproject.org/~jmorris/linux-security for-linus

David Howells (1):
      SELinux: Fix RCU deref check warning in sel_netport_insert()

Eric Paris (12):
      capabilities: remove the task from capable LSM hook entirely
      capabilities: reverse arguments to security_capable
      capabilities: introduce security_capable_noaudit
      capabilities: remove all _real_ interfaces
      capabilities: call has_ns_capability from has_capability
      capabilites: introduce new has_ns_capabilities_noaudit
      capabilities: style only - move capable below ns_capable
      capabitlies: ns_capable can use the cap helpers rather than lsm call
      capabilities: remove task_ns_* functions
      ptrace: do not audit capability check when outputing /proc/pid/stat
      security: remove the security_netlink_recv hook as it is equivalent to capable()
      capabilities: remove __cap_full_set definition

James Morris (7):
      selinux: sparse fix: make selinux_secmark_refcount static
      selinux: sparse fix: move selinux_complete_init
      selinux: sparse fix: declare selinux_disable() in security.h
      selinux: sparse fix: eliminate warnings for selinuxfs
      selinux: sparse fix: fix warnings in netlink code
      selinux: sparse fix: fix several warnings in the security server cod
      Merge branch 'eparis-master' into for-linus

 crypto/crypto_user.c            |    2 +-
 drivers/pci/pci-sysfs.c         |    2 +-
 drivers/scsi/scsi_netlink.c     |    2 +-
 fs/proc/array.c                 |    2 +-
 include/linux/capability.h      |    4 +-
 include/linux/cred.h            |    6 ++-
 include/linux/ptrace.h          |    5 +-
 include/linux/security.h        |   60 ++++++-----------------------
 kernel/audit.c                  |    4 +-
 kernel/capability.c             |   80 ++++++++++++++++++++++----------------
 kernel/ptrace.c                 |   14 +++++-
 kernel/sched/core.c             |    2 +-
 net/core/rtnetlink.c            |    2 +-
 net/decnet/netfilter/dn_rtmsg.c |    2 +-
 net/ipv4/netfilter/ip_queue.c   |    2 +-
 net/ipv6/netfilter/ip6_queue.c  |    2 +-
 net/netfilter/nfnetlink.c       |    2 +-
 net/netlink/genetlink.c         |    2 +-
 net/xfrm/xfrm_user.c            |    2 +-
 security/apparmor/lsm.c         |    8 ++--
 security/capability.c           |    1 -
 security/commoncap.c            |   24 +++--------
 security/security.c             |   35 ++--------------
 security/selinux/hooks.c        |   44 +++++----------------
 24 files changed, 120 insertions(+), 189 deletions(-)

