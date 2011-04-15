Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755680Ab1DOKbR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 06:31:17 -0400
Received: from smtp.nokia.com ([147.243.128.24]:51226 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755624Ab1DOKbQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 06:31:16 -0400
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        linux-kernel@vger.kernel.org
Date: Fri, 15 Apr 2011 13:34:33 +0300
Message-Id: <20110415103433.5187.44052.sendpatchset@localhost.localdomain>
Subject: [GIT PULL] UBIFS changes for 2.6.39
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull a couple of UBIFS fixes. One of them fixes a really bad bug
where UBIFS just oopses if one calls 'fsync()' when UBIFS is R/O-mounted.

I do not know why VFS does not filter out ->fsync() if the underlying
FS is R/O, but we simply missed this fact. And I won't be suprized if this
is an issue for some other FSes.

The second patch fixes compilation warnings.


The following changes since commit a6360dd37e1a144ed11e6548371bade559a1e4df:

  Linux 2.6.39-rc3 (2011-04-11 17:21:51 -0700)

are available in the git repository at:
  git://git.infradead.org/ubifs-2.6.git linux-next

Artem Bityutskiy (1):
      UBIFS: fix oops when R/O file-system is fsync'ed

Maksim Rayskiy (1):
      UBIFS: fix compilation warnings when compiling with gcc 4.5

 fs/ubifs/debug.h |  152 +++++++++++++++++++++++++++++++++---------------------
 fs/ubifs/file.c  |    3 +
 2 files changed, 97 insertions(+), 58 deletions(-)


Thanks,
Artem.
