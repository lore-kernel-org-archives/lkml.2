Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751509Ab1HJFVo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 01:21:44 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:44594 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836Ab1HJFVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 01:21:43 -0400
Date: Wed, 10 Aug 2011 00:21:35 -0500
From: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        ecryptfs@vger.kernel.org
Subject: [GIT PULL] eCryptfs fixes for 3.1-rc2
Message-ID: <20110810052134.GA26944@boyd.l.tihix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

John has added an eCryptfs mount option to do a mount time check
ensuring that the source mount point is owned by the real uid of the
process performing the mount. Roberto's Kconfig patch fixes a
dependency-based compile error when encrypted keys are built as a module
but eCryptfs is a built-in. My first patch removes a call to BUG() when
we should be returning an error and my second patch simply fixes a
compiler warning.

The following changes since commit 322a8b034003c0d46d39af85bf24fee27b902f48:

  Linux 3.1-rc1 (2011-08-07 18:23:30 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/ecryptfs/ecryptfs-2.6.git for-linus

John Johansen (1):
      Ecryptfs: Add mount option to check uid of device being mounted = expect uid

Roberto Sassu (1):
      eCryptfs: fix compile error

Tyler Hicks (2):
      eCryptfs: Return error when lower file pointer is NULL
      eCryptfs: Fix payload_len unitialized variable warning

 fs/ecryptfs/Kconfig      |    2 +-
 fs/ecryptfs/keystore.c   |    2 +-
 fs/ecryptfs/main.c       |   23 +++++++++++++++++++++--
 fs/ecryptfs/read_write.c |   18 ++++++++++--------
 4 files changed, 33 insertions(+), 12 deletions(-)
