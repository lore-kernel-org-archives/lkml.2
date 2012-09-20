Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068Ab2ITLk3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 07:40:29 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:39009 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754000Ab2ITLk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 07:40:26 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: <linux-fsdevel@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>
Date: Thu, 20 Sep 2012 04:40:18 -0700
Message-ID: <877grox6ql.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/oX5Jslyd6zVysf5Z3PeyFQH0y1hkqHRk=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.1 XMSubLong Long Subject
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 FVGT_m_MULTI_ODD Contains multiple odd letter combinations
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [REVIEW][PATCH 00/25] userns: Trivial filesystem conversions
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This continues my conversion of uid_t and gidt into kuid_t and kgid_t.
This time my target was all of the file systems that had an extremely
trivial conversion.

These patches are against:
git.kernel.org:/pub/scm/linux/kernel/git/ebiederm/user-namespace.git for-next

Which is against 3.6-rc1.

Once the review is complete I will push these patches to my for-next
branch, hopefully in time for 3.7.

Eric

Eric W. Biederman (25):
      userns: Convert fat to use kuid/kgid where appropriate
      userns: Convert gadgetfs to use kuid and kgid where appropriate
      userns: Convert usb functionfs to use kuid/kgid where appropriate
      userns: Convert devtmpfs to use GLOBAL_ROOT_UID and GLOBAL_ROOT_GID
      userns: Convert hugetlbfs to use kuid/kgid where appropriate
      userns: Convert xenfs to use kuid and kgid where appropriate
      userns: Convert adfs to use kuid and kgid where appropriate
      userns: Convert befs to use kuid/kgid where appropriate
      userns: Convert cramfs to use kuid/kgid where appropriate
      userns: Convert ecryptfs to use kuid/kgid where appropriate
      userns: Convert efs to use kuid/kgid where appropriate
      userns: Convert exofs to use kuid/kgid where appropriate
      userns: Convert hfs to use kuid and kgid where appropriate
      userns: Convert hfsplus to use kuid and kgid where appropriate
      userns: Convert isofs to use kuid/kgid where appropriate
      userns: Convert logfs to use kuid/kgid where appropriate
      userns: Convert minix to use kuid/kgid where appropriate
      userns: Convert nillfs2 to use kuid/kgid where appropriate
      userns: Convert ntfs to use kuid and kgid where appropriate
      userns: Convert omfs to use kuid and kgid where appropriate
      userns: Convert the qnx4 filesystem to use kuid/kgid where appropriate
      userns: Convert the qnx6 filesystem to use kuid/kgid where appropriate
      userns: Convert the sysv filesystem to use kuid/kgid where appropriate
      userns: Convert freevxfs to use kuid/kgid where appropriate
      userns: Convert ipathfs to use GLOBAL_ROOT_UID and GLOBAL_ROOT_GID

 drivers/base/devtmpfs.c            |    4 +-
 drivers/infiniband/hw/qib/qib_fs.c |    4 +-
 drivers/usb/gadget/f_fs.c          |   23 ++++++++++++++------
 drivers/usb/gadget/inode.c         |    4 +-
 drivers/xen/xenfs/super.c          |    3 +-
 fs/adfs/adfs.h                     |    4 +-
 fs/adfs/inode.c                    |    4 +-
 fs/adfs/super.c                    |   21 ++++++++++++-------
 fs/befs/befs.h                     |    4 +-
 fs/befs/linuxvfs.c                 |   27 +++++++++++++++++-------
 fs/cramfs/inode.c                  |    4 +-
 fs/ecryptfs/main.c                 |    5 ++-
 fs/ecryptfs/messaging.c            |    5 +--
 fs/efs/inode.c                     |    4 +-
 fs/exofs/inode.c                   |    8 +++---
 fs/fat/fat.h                       |    4 +-
 fs/fat/file.c                      |    6 ++--
 fs/fat/inode.c                     |   18 +++++++++++-----
 fs/freevxfs/vxfs_inode.c           |    4 +-
 fs/hfs/hfs_fs.h                    |    4 +-
 fs/hfs/inode.c                     |    4 +-
 fs/hfs/super.c                     |   16 ++++++++++++--
 fs/hfsplus/catalog.c               |    4 +-
 fs/hfsplus/hfsplus_fs.h            |    4 +-
 fs/hfsplus/inode.c                 |    8 +++---
 fs/hfsplus/options.c               |   15 +++++++++++--
 fs/hugetlbfs/inode.c               |   16 ++++++++++----
 fs/isofs/inode.c                   |   17 ++++++++++-----
 fs/isofs/isofs.h                   |    4 +-
 fs/isofs/rock.c                    |    4 +-
 fs/logfs/inode.c                   |    4 +-
 fs/logfs/readwrite.c               |    8 +++---
 fs/minix/inode.c                   |   16 +++++++-------
 fs/nilfs2/inode.c                  |    8 +++---
 fs/ntfs/inode.c                    |    7 +++--
 fs/ntfs/super.c                    |   39 +++++++++++++++++++++++++++++------
 fs/ntfs/volume.h                   |    5 ++-
 fs/omfs/inode.c                    |    8 +++++-
 fs/omfs/omfs.h                     |    4 +-
 fs/qnx4/inode.c                    |    4 +-
 fs/qnx6/inode.c                    |    4 +-
 fs/sysv/inode.c                    |    8 +++---
 init/Kconfig                       |   26 ------------------------
 43 files changed, 230 insertions(+), 163 deletions(-)
