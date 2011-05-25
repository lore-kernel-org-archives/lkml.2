Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754928Ab1EYVBC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 17:01:02 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:43072 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754754Ab1EYVBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 17:01:00 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Date: Wed, 25 May 2011 14:00:49 -0700
Message-ID: <m1pqn61on2.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+6UNjOzwChZXvALL36OFCn7HwOxuAufnY=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Linus Torvalds <torvalds@linux-foundation.org>
X-Spam-Relay-Country: 
Subject: [GIT PULL] namespace filedescriptors
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I have ripped out all of my work to wire up the syscalls and make that
work properly.

Please think about pulling:
git://git.kernel.org/pub/scm/linux/kernel/git/ebiederm/linux-2.6-nsfd.git

The code really cleans up working with namespaces.

The killer feature is probably going to be that it becomes trivial to
isolate a vpn connection into it's own network namespace, allowing
all of the weirdness that comes with vpn connections to be isolated.

If nothing happens with this until the next merge cycle I will
understand.

Eric W. Biederman (8):
      ns: proc files for namespace naming policy.
      ns: Introduce the setns syscall
      ns proc: Add support for the network namespace.
      ns proc: Add support for the uts namespace
      ns proc: Add support for the ipc namespace
      net: Allow setting the network namespace by fd
      ns: Declare sys_setns in syscalls.h
      ns proc: Return -ENOENT for a nonexistent /proc/self/ns/ entry.

Stephen Rothwell (1):
      net: fix get_net_ns_by_fd for !CONFIG_NET_NS


 fs/proc/Makefile            |    1 +
 fs/proc/base.c              |   20 ++---
 fs/proc/inode.c             |    7 ++
 fs/proc/internal.h          |   18 ++++
 fs/proc/namespaces.c        |  198 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/if_link.h     |    1 +
 include/linux/proc_fs.h     |   21 +++++
 include/linux/syscalls.h    |    1 +
 include/net/net_namespace.h |    1 +
 ipc/namespace.c             |   37 ++++++++
 kernel/nsproxy.c            |   42 +++++++++
 kernel/utsname.c            |   39 +++++++++
 net/core/net_namespace.c    |   65 ++++++++++++++
 net/core/rtnetlink.c        |    5 +-
 14 files changed, 444 insertions(+), 12 deletions(-)
