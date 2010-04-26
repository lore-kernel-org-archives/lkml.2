Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755867Ab0D2AWb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 20:22:31 -0400
Received: from smtp01.one2one.net ([149.254.200.196]:38612 "EHLO
	smtp01.one2one.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413Ab0D2AWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 20:22:30 -0400
X-Greylist: delayed 1743 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Apr 2010 20:22:30 EDT
From: Christoffer Dall <christofferdall@christofferdall.dk>
To: containers <containers@lists.linux-foundation.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Christoffer Dall <christofferdall@christofferdall.dk>
Subject: [C/R ARM v2][PATCH 0/3] Linux Checkpoint-Restart - ARM port
Date: Mon, 26 Apr 2010 17:43:40 -0400
Message-Id: <1272318223-28438-1-git-send-email-christofferdall@christofferdall.dk>
X-Mailer: git-send-email 1.5.6.5
X-SA-Exim-Connect-IP: 127.0.0.1
X-SA-Exim-Mail-From: christofferdall@christofferdall.dk
X-SA-Exim-Scanned: No (on localhost); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following there will be two preparatory patches for an ARM port of the
checkpoint-restart code and finally a third patch implementing the
architecture-specific parts of c/r.

The preparatory patches consist of a partial syscall trace implementation
for ARM and an eclone implementation for ARM. The syscall trace
implementation provides only the needed functionality for c/r.

There is a separate patch for the user space code, which supports
cross-compilation, extracting headers for ARM and an eclone implementation
for ARM.

The kernel patches presented here are based on the ckpt-v21-rc6 patch set.

---

CHANGELOG:

[2010-Apr-08] v2:
	- Systrace implementation now inspects process state to get the
	  system call number thereby avoiding extra work on system calls.
	- Removed __user attribute on long type in eclone implementation
	- Better check for architecture versions across C/R
	- Improved checking of user space ABI settings across C/R
	- Code simplifications

[2010-Mar-22] v1:
	- Initial version
	- Systrace implementation modified the system call entry path to
	  store the system call number globally in memory.
	- ARM implementation lightly tested
