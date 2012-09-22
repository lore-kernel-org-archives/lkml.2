Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758138Ab2IVBb7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 21:31:59 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:55789 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752948Ab2IVBb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 21:31:57 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: <linux-fsdevel@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        "Serge E. Hallyn" <serge@hallyn.com>
Date: Fri, 21 Sep 2012 18:31:50 -0700
Message-ID: <877grmj115.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18Dz8y3L81U5qan11ugtOyBj7Hldy6Ff04=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.1 XMSubLong Long Subject
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0027]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [REVIEW][PATCH 00/11] userns: Simple filesystems conversions
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This continus my conversion of filesystems to support running
when kernel user namespace supprot is enabled.  This time I have
targed the filesystems that I had to look twice at to verify
the changes were correct.

The strategy is to convert the structures in the kernel where we store
uid_t and gid_t to to kuid_t and kgid_t.  To assume all file systems are
encoded in the initial user namespace for purposes of conversions.
Mount options containing uids and gids along with other user space
interfaces are of assumed to be encoded in the current user namespace.

These patches are against:
git.kernel.org:/pub/scm/linux/kernel/git/ebiederm/user-namespace.git for-next

Eric W. Biederman (11):
      userns: Convert affs to use kuid/kgid wherwe appropriate
      userns: Convert bfs to use kuid/kgid where appropriate
      userns: Convert btrfs to use kuid/kgid where appropriate
      userns: Convert hpfs to use kuid and kgid where appropriate
      userns: Convert jffs2 to use kuid and kgid where appropriate
      userns: Convert jfs to use kuid/kgid where appropriate
      userns: Convert reiserfs to use kuid and kgid where appropriate
      userns: Convert squashfs to use kuid/kgid where appropriate
      userns: Convert ubifs to use kuid/kgid
      userns: Convert the udf filesystem to use kuid/kgid where appropriate
      userns: Convert the ufs filesystem to use kuid/kgid where appropriate

 fs/affs/affs.h           |    4 ++--
 fs/affs/inode.c          |   20 ++++++++++----------
 fs/affs/super.c          |   18 +++++++++++-------
 fs/bfs/inode.c           |    8 ++++----
 fs/btrfs/delayed-inode.c |    8 ++++----
 fs/btrfs/inode.c         |    8 ++++----
 fs/btrfs/ioctl.c         |    6 +++---
 fs/hpfs/hpfs_fn.h        |    4 ++--
 fs/hpfs/inode.c          |   19 +++++++++++--------
 fs/hpfs/namei.c          |    8 ++++----
 fs/hpfs/super.c          |   18 +++++++++++-------
 fs/jffs2/acl.c           |   26 ++++++++++++++++++++------
 fs/jffs2/file.c          |    8 ++++----
 fs/jffs2/fs.c            |   24 +++++++++++++-----------
 fs/jffs2/os-linux.h      |    4 ++--
 fs/jfs/file.c            |    4 ++--
 fs/jfs/jfs_imap.c        |   22 ++++++++++++----------
 fs/jfs/jfs_incore.h      |    8 ++++----
 fs/jfs/super.c           |   22 +++++++++++++++-------
 fs/reiserfs/inode.c      |   26 +++++++++++++-------------
 fs/reiserfs/xattr_acl.c  |   20 +++++++++++++++++---
 fs/squashfs/inode.c      |    8 ++++++--
 fs/ubifs/budget.c        |    4 ++--
 fs/ubifs/debug.c         |    4 ++--
 fs/ubifs/journal.c       |    4 ++--
 fs/ubifs/sb.c            |    4 ++--
 fs/ubifs/super.c         |    4 ++--
 fs/ubifs/ubifs.h         |    4 ++--
 fs/udf/inode.c           |   12 ++++++------
 fs/udf/super.c           |   20 ++++++++++++--------
 fs/udf/udf_sb.h          |    4 ++--
 fs/ufs/inode.c           |   16 ++++++++--------
 init/Kconfig             |   11 -----------
 33 files changed, 214 insertions(+), 166 deletions(-)
