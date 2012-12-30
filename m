Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755200Ab2L3WrP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2012 17:47:15 -0500
Received: from server.prisktech.co.nz ([115.188.14.127]:54629 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753046Ab2L3WrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2012 17:47:10 -0500
From: Tony Prisk <linux@prisktech.co.nz>
To: Input Mailing List <linux-input@vger.kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        vt8500-wm8505-linux-kernel@googlegroups.com,
        Tony Prisk <linux@prisktech.co.nz>
Subject: [RFC PATCH] Add support for devicetree to i8042 serio driver
Date: Mon, 31 Dec 2012 11:47:08 +1300
Message-Id: <1356907629-25459-1-git-send-email-linux@prisktech.co.nz>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since this patch may adversely affect a lot of users, I thought I'd post this
as an RFC first. I don't think the changes should affect any existing i8042
implementations, but can never be certain.

Limitations:

This patch does not overcome the problem of only being able to select
a single i8042 platform at compile-time. If compiling for a multiplatform
kernel, all platforms must use the DT version or only one platform
can have i8042 support.

The DT version assumes memory-mapped i8042 registers. It can not handle
IO-mapped modules (eg. x86)

Tony Prisk (1):
  input: i8042: Add support for devicetree to i8042 serio driver

 .../devicetree/bindings/input/intel-8042.txt       |   29 +++++
 drivers/input/serio/Kconfig                        |   10 +-
 drivers/input/serio/i8042-dt.h                     |  127 ++++++++++++++++++++
 drivers/input/serio/i8042.c                        |   15 ++-
 drivers/input/serio/i8042.h                        |    4 +-
 5 files changed, 181 insertions(+), 4 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/input/intel-8042.txt
 create mode 100644 drivers/input/serio/i8042-dt.h

-- 
1.7.9.5

