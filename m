Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752291Ab0DIOBT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 10:01:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36372 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751079Ab0DIOBP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 10:01:15 -0400
From: Jan Blunck <jblunck@suse.de>
To: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
       Alan Cox <alan@linux.intel.com>, Jan Blunck <jblunck@suse.de>
Subject: [PATCH 00/12] Multiple file->f_pos/nonseekable_open/llseek fixes (reposy)
Date: Fri,  9 Apr 2010 16:00:43 +0200
Message-Id: <1270821655-4368-1-git-send-email-jblunck@suse.de>
X-Mailer: git-send-email 1.6.4.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a repost of a patch series I already posted in November 2009. This time
I left out the patch that removes the BKL from default_llseek() since this
should go through Frederic's tree. This series mostly consists of fixing direct
modifications of file->f_pos and some additional cases where nonseekable_open()
can be used. The rest of this series is unrelated to but a preparation for the
BKL removal from default_llseek().

Thanks,
Jan

Jan Blunck (12):
  osst: Update ppos instead of using file->f_pos
  flash_read should update ppos instead of file->f_pos
  eeprom_read()/eeprom_write() should update ppos instead of
    file->f_pos
  frv: remove "struct file *" argument from sysctl ->proc_handler
  mISDN: Remove unnecessary test on f_pos
  zcrypt: Use nonseekable_open()
  rtc-m41t80: Use nonseekable_open()
  Introduce noop_llseek()
  osst: Use noop_llseek() instead of default_llseek()
  st: Use noop_llseek() instead of default_llseek()
  Do not fallback to default_llseek() when readdir() uses BKL
  Documentation/filesystems/Locking: Update documentation on llseek()
    wrt BKL

 Documentation/filesystems/Locking   |    5 +++--
 arch/cris/arch-v10/drivers/eeprom.c |   34 +++++++++++++---------------------
 arch/frv/kernel/sysctl.c            |   18 ++++++++++--------
 drivers/isdn/mISDN/timerdev.c       |    2 --
 drivers/rtc/rtc-m41t80.c            |    6 +-----
 drivers/s390/crypto/zcrypt_api.c    |    2 +-
 drivers/sbus/char/flash.c           |    6 +++---
 drivers/scsi/osst.c                 |    9 +++++----
 drivers/scsi/st.c                   |    1 +
 fs/autofs/root.c                    |    1 +
 fs/freevxfs/vxfs_lookup.c           |    2 ++
 fs/isofs/dir.c                      |    1 +
 fs/ncpfs/dir.c                      |    1 +
 fs/qnx4/dir.c                       |    1 +
 fs/read_write.c                     |   17 +++++++++++++++++
 fs/reiserfs/dir.c                   |    1 +
 fs/smbfs/dir.c                      |    1 +
 fs/udf/dir.c                        |    1 +
 include/linux/fs.h                  |    1 +
 19 files changed, 64 insertions(+), 46 deletions(-)

