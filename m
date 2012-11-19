Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751811Ab2KSKsy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 05:48:54 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:48970 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248Ab2KSKsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 05:48:52 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: <linux-fsdevel@vger.kernel.org>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, Al Viro <viro@ZenIV.linux.org.uk>
Date: Mon, 19 Nov 2012 02:48:40 -0800
Message-ID: <87k3thc1h3.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+YAo5IBtNV/LWyoKeL4tj8ZiG/C+nUPeE=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0001]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH review 0/6] mount namespace container enhancements
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patchset adds the ability for the root user in a user namespace to
call choort, to create new mount namespaces, and to manipulate mount
namespaces (mount/umount) that the userns root has created.

Additionally support is added namespace file descriptors and for setns
on the namespace file descriptors.

To keep total chaos from breaking out mount namespace file descriptors
are not allowed to be mounted into a child mount namespace, and shared
subtrees become slave subtrees when creating a new mount namespace in a
different user namespace than it's parent.

This series of changes is available in git from:
git://git.kernel.org/pub/scm/linux/kernel/git/ebiederm/user-namespace.git mntns-v53

Baring problems I plan to merge these changes through my user namespace
tree for 3.8

Eric W. Biederman (5):
      vfs: Allow chroot if you have CAP_SYS_CHROOT in your user namespace
      vfs: Add setns support for the mount namespace
      vfs: Add a user namespace reference from struct mnt_namespace
      vfs: Only support slave subtrees across different user namespaces
      vfs: Allow unprivileged manipulation of the mount namespace.

Zhao Hongjiang (1):
      userns: fix return value on mntns_install() failure

 fs/mount.h                    |    2 +
 fs/namespace.c                |  197 +++++++++++++++++++++++++++++++++--------
 fs/open.c                     |    2 +-
 fs/pnode.h                    |    1 +
 fs/proc/namespaces.c          |    5 +
 include/linux/fs.h            |    2 +
 include/linux/mnt_namespace.h |    3 +-
 include/linux/proc_fs.h       |    7 ++
 kernel/nsproxy.c              |    2 +-
 9 files changed, 182 insertions(+), 39 deletions(-)
