Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449Ab1HEVYh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 17:24:37 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:55591 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191Ab1HEVYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 17:24:36 -0400
From: Rob Herring <robherring2@gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH 0/3] Move OF i2c functions into i2c core
Date: Fri,  5 Aug 2011 16:24:25 -0500
Message-Id: <1312579468-19365-1-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

As suggested by Grant, this series moves OF i2c functions in of_i2c.c into
i2c-core.c. This simplifies OF i2c drivers slightly. Combining the
functions is necessary to avoid a module circular dependency between
i2c-core.ko and of_i2c.ko.

Compile tested on ARM (DT/non-DT VExpress) and PowerPC (8xxx and 44x).

Rob

Rob Herring (3):
  i2c: move of_i2c_register_devices call into core
  i2c: move OF i2c related functions into i2c core
  i2c-designware: add OF binding support

 Documentation/devicetree/bindings/i2c/dw-i2c.txt |   23 +++++
 arch/powerpc/platforms/44x/warp.c                |    1 -
 drivers/i2c/busses/i2c-cpm.c                     |    6 --
 drivers/i2c/busses/i2c-designware.c              |    8 ++
 drivers/i2c/busses/i2c-ibm_iic.c                 |    4 -
 drivers/i2c/busses/i2c-mpc.c                     |    2 -
 drivers/i2c/busses/i2c-pxa.c                     |    2 -
 drivers/i2c/busses/i2c-tegra.c                   |    3 -
 drivers/i2c/i2c-core.c                           |   87 +++++++++++++++++++-
 drivers/of/Makefile                              |    1 -
 drivers/of/of_i2c.c                              |   97 ----------------------
 include/linux/i2c.h                              |    4 +
 include/linux/of_i2c.h                           |   30 -------
 13 files changed, 121 insertions(+), 147 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/i2c/dw-i2c.txt
 delete mode 100644 drivers/of/of_i2c.c
 delete mode 100644 include/linux/of_i2c.h

-- 
1.7.4.1

