Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756601Ab2IUA1H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 20:27:07 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:41489 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754675Ab2IUA1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 20:27:01 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: <linux-security-module@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        "Serge E. Hallyn" <serge@hallyn.com>
Date: Thu, 20 Sep 2012 17:26:52 -0700
Message-ID: <87k3vote43.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+wReDl0BGd8q0TDjEzFGOD8RYpQPHQbE0=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  1.5 TR_Symld_Words too many words that have symbols inside
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0079]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;<linux-security-module@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [REVIEW][PATCH 00/14] userns: Miscelanous conversions
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The following patchset contains conversion for basic user namespace
support for the security modules and a few miscelaneous other things.

I am placing these patches up for review before I add them to
linux-next.

Please holler if it looks if you see something scary.

The following patchset is against
git.kernel.org/pub/scm/linux/kernel/git/ebiederm/user-namespace.git for-next
which is based on v3.6-rc1

Eric

Eric W. Biederman (14):
      userns: Convert loop to use kuid_t instead of uid_t
      userns: Convert apparmor to use kuid and kgid where appropriate
      userns: Convert tomoyo to use kuid and kgid where appropriate
      userns: Convert selinux to use kuid and kgid where appropriate
      userns: Convert hostfs to use kuid and kgid where appropriate
      userns: Convert EVM to deal with kuids and kgids in it's hmac computation
      userns: Add user namespace support to IMA
      userns: Teach security_path_chown to take kuids and kgids
      userns: Convert binder ipc to use kuids
      userns: Convert s390 hypfs to use kuid and kgid where appropriate
      userns: Convert s390 getting uid and gid system calls to use kuid and kgid
      userns: On ppc convert current_uid from a kuid before printing.
      userns: On ia64 deal with current_uid and current_gid being kuid and kgid
      userns: On alpha modify linux_to_osf_stat to use convert from kuids and kgids

 arch/alpha/kernel/osf_sys.c         |    4 +-
 arch/ia64/kernel/mca_drv.c          |    3 +-
 arch/ia64/kernel/perfmon.c          |   32 +++++++++++++++---------------
 arch/ia64/kernel/signal.c           |    4 +-
 arch/powerpc/mm/fault.c             |    2 +-
 arch/s390/hypfs/inode.c             |   20 +++++++++++++-----
 arch/s390/kernel/compat_linux.c     |   36 +++++++++++++++++++++++-----------
 drivers/block/loop.c                |    4 +-
 drivers/staging/android/binder.c    |   14 ++++++------
 fs/hostfs/hostfs_kern.c             |    8 +++---
 fs/open.c                           |    2 +-
 include/linux/loop.h                |    2 +-
 include/linux/security.h            |    6 ++--
 init/Kconfig                        |   15 --------------
 security/apparmor/domain.c          |    4 +-
 security/apparmor/file.c            |   12 ++++++----
 security/apparmor/include/audit.h   |    2 +-
 security/apparmor/include/file.h    |    4 +-
 security/apparmor/lsm.c             |    2 +-
 security/capability.c               |    2 +-
 security/integrity/evm/evm_crypto.c |    4 +-
 security/integrity/ima/ima_audit.c  |    5 ++-
 security/integrity/ima/ima_policy.c |   14 ++++++------
 security/security.c                 |    2 +-
 security/selinux/selinuxfs.c        |    6 ++--
 security/selinux/ss/services.c      |    2 +-
 security/tomoyo/audit.c             |   23 +++++++++++++++------
 security/tomoyo/common.c            |    4 ++-
 security/tomoyo/common.h            |    4 +-
 security/tomoyo/condition.c         |   20 +++++++++---------
 security/tomoyo/tomoyo.c            |   12 ++++++----
 31 files changed, 148 insertions(+), 126 deletions(-)
