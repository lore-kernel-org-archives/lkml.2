Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471Ab1HILt0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 07:49:26 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:57861 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753272Ab1HILtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 07:49:23 -0400
From: Per Forlin <per.forlin@linaro.org>
To: Akinobu Mita <akinobu.mita@gmail.com>, akpm@linux-foundation.org,
        Linus Walleij <linus.ml.walleij@gmail.com>,
        linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
        Chris Ball <cjb@laptop.org>
Cc: linux-doc@vger.kernel.org, linux-mmc@vger.kernel.org,
        linaro-dev@lists.linaro.org, linux-mm@kvack.org,
        Per Forlin <per.forlin@linaro.org>
Subject: [PATCH --mmotm v7 0/3] Make fault injection available for MMC IO
Date: Tue,  9 Aug 2011 13:48:56 +0200
Message-Id: <1312890539-28177-1-git-send-email-per.forlin@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

change log:
 v2 - Resolve build issue in mmc core.c due to multiple init_module by
      removing the fault inject module.
    - Export fault injection functions to make them available for modules
    - Update fault injection documentation on MMC IO  
 v3 - add function descriptions in core.c
    - use export GPL for fault injection functions
 v4 - make the fault_attr per host. This prepares for upcoming patch from
      Akinobu that adds support for creating debugfs entries in
      arbitrary directory.
 v5 - Make use of fault_create_debugfs_attr() in Akinobu's
      patch "fault-injection: add ability to export fault_attr in...". 
 v6 - Fix typo in commit message in patch "export fault injection functions"
 v7 - Don't compile in boot param setup function if mmc-core is
      built as module.

Per Forlin (3):
  fault-inject: export fault injection functions
  mmc: core: add random fault injection
  fault injection: add documentation on MMC IO fault injection

 Documentation/fault-injection/fault-injection.txt |    5 ++
 drivers/mmc/core/core.c                           |   44 +++++++++++++++++++++
 drivers/mmc/core/debugfs.c                        |   27 +++++++++++++
 include/linux/mmc/host.h                          |    7 +++
 lib/Kconfig.debug                                 |   11 +++++
 lib/fault-inject.c                                |    2 +
 6 files changed, 96 insertions(+), 0 deletions(-)

-- 
1.7.4.1

