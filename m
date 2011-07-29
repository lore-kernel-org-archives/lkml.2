Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752510Ab1G2Qwj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 12:52:39 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:53699 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752396Ab1G2Qwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 12:52:38 -0400
Date: Fri, 29 Jul 2011 11:52:31 -0500
From: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        ecryptfs@vger.kernel.org
Subject: [GIT PULL] eCryptfs fixes for 3.1-rc1
Message-ID: <20110729165231.GB29604@boyd.l.tihix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here are two important fixes for 3.1-rc1. My fix solves breakage in the
ability for eCryptfs to call out to userspace to do file encryption key
(un)wrappering. Thieu's fix should solve some writeback issues since the
i_mapping's bdi wasn't being properly initialized.

The following changes since commit 55f9c40ff632d03c527d6a6ceddcda0a224587a6:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc (2011-07-28 05:59:19 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ecryptfs/ecryptfs-2.6.git next

Thieu Le (1):
      ecryptfs: Make inode bdi consistent with superblock bdi

Tyler Hicks (1):
      eCryptfs: Unlock keys needed by ecryptfsd

 fs/ecryptfs/inode.c    |    1 +
 fs/ecryptfs/keystore.c |   47 +++++++++++++++++++++++++----------------------
 2 files changed, 26 insertions(+), 22 deletions(-)
