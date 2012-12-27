Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751765Ab2L0BEb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2012 20:04:31 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:46640 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333Ab2L0BE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2012 20:04:29 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>
Date: Wed, 26 Dec 2012 17:04:19 -0800
Message-ID: <87han82tm4.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+9IKdW5omrzjtrarDIw8Qnk2e320axMKU=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Linus Torvalds <torvalds@linux-foundation.org>
X-Spam-Relay-Country: 
Subject: [GIT PULL] namespace fixes for v3.8-rc2
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

Please pull the for-linus git tree from:

   git://git.kernel.org:/pub/scm/linux/kernel/git/ebiederm/user-namespace.git for-linus

   HEAD: 48c6d1217e3dc743e7d3ad9b9def8d4810d13a85 f2fs: Don't assign e_id in f2fs_acl_from_disk

   This tree is against v3.8-rc1

This tree includes two bug fixes for problems Oleg spotted on his review
of the recent pid namespace work.  A small fix to not enable bottom
halves with irqs disabled, and a trivial build fix for f2fs with user
namespaces enabled.

Eric W. Biederman (4):
      pidns: Outlaw thread creation after unshare(CLONE_NEWPID)
      pidns: Stop pid allocation when init dies
      proc: Allow proc_free_inum to be called from any context
      f2fs: Don't assign e_id in f2fs_acl_from_disk

 fs/f2fs/acl.c                 |    1 -
 fs/proc/generic.c             |   13 +++++++------
 include/linux/pid.h           |    1 +
 include/linux/pid_namespace.h |    4 +++-
 kernel/fork.c                 |    8 ++++++++
 kernel/pid.c                  |   15 ++++++++++++---
 kernel/pid_namespace.c        |    4 ++++
 7 files changed, 35 insertions(+), 11 deletions(-)
