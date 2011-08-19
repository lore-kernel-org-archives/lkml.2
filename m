Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338Ab1HSMzj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 08:55:39 -0400
Received: from eu1sys200aog103.obsmtp.com ([207.126.144.115]:56300 "EHLO
	eu1sys200aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751277Ab1HSMzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 08:55:35 -0400
From: Per Forlin <per.forlin@stericsson.com>
To: <linux-mmc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linaro-dev@lists.linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Akinobu Mita <akinobu.mita@gmail.com>
Cc: Chris Ball <cjb@laptop.org>, <linux-doc@vger.kernel.org>,
        Per Forlin <per.forlin@linaro.org>
Subject: [PATCH v9 0/3] mmc: make fault injection available for MMC IO
Date: Fri, 19 Aug 2011 14:52:35 +0200
Message-ID: <1313758358-27536-1-git-send-email-per.forlin@stericsson.com>
X-Mailer: git-send-email 1.6.3.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Per Forlin <per.forlin@linaro.org>

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
 v8 - Update fault injection documentation.
      Add fail_mmc_request to boot option section. 
 v9 - remove ifdef around include files and inline empty function,
      comments from Linus Walleij.

Per Forlin (3):
  fault-inject: export fault injection functions
  mmc: core: add random fault injection
  fault injection: add documentation on MMC IO fault injection

 Documentation/fault-injection/fault-injection.txt |    8 ++++-
 drivers/mmc/core/core.c                           |   41 +++++++++++++++++++++
 drivers/mmc/core/debugfs.c                        |   25 +++++++++++++
 include/linux/mmc/host.h                          |    5 +++
 lib/Kconfig.debug                                 |   11 ++++++
 lib/fault-inject.c                                |    2 +
 6 files changed, 91 insertions(+), 1 deletions(-)

