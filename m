Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756545Ab1INMKh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 08:10:37 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:65403 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756484Ab1INMKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 08:10:36 -0400
From: Per Forlin <per.forlin@linaro.org>
To: linaro-dev@lists.linaro.org, Akinobu Mita <akinobu.mita@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-mmc@vger.kernel.org
Cc: Chris Ball <cjb@laptop.org>, Randy Dunlap <rdunlap@xenotime.net>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Per Forlin <per.forlin@linaro.org>
Subject: [PATCH v3 0/3] mmc: rectify boot param option for fault injection
Date: Wed, 14 Sep 2011 14:10:15 +0200
Message-Id: <1316002218-3408-1-git-send-email-per.forlin@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Akinobu Mita reported that the boot option for mmc fault injection is never
compiled in due to a fauly "ifdef KERNEL" that is never set.
A correct ifdef would be "ifndef MODULE". This patch set adds a
module_param_cb() and thereby no ifndef MODULE is needed.
Using a module_param makes it possible to pass default fault attributes for
external modules too.

This patch set is for 3.2
Change log:
v2 - use module_param_cb() to set default fault attributes
   - fix spelling of documentation in patch #3  
v3 - remove unused variable and return error if invalid boot param.

Per Forlin (3):
  fault-inject: export setup_fault_attr()
  mmc: add module param to set fault injection attributes
  fault-injection: update documentation with the mmc module param

 Documentation/fault-injection/fault-injection.txt |    2 +-
 drivers/mmc/core/debugfs.c                        |   38 +++++++++++----------
 lib/fault-inject.c                                |    3 +-
 3 files changed, 23 insertions(+), 20 deletions(-)

-- 
1.7.4.1

