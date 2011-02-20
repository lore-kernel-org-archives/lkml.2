Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751977Ab1BTHIX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 02:08:23 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48039 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792Ab1BTHIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 02:08:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:message-id:x-mailer;
        b=n8WaOBlQysdZHQ4PEJD3R8+7F+Oeyz8t/88ywO319b+E/K0/8BMdryOP+7QUeUyRnN
         9ZzjVCPEN+tug0OKhd8gfowmsQjBMeXv00zWoeVum5lY1Kybo/ThhBpBPhIVFKQspyNS
         YwFtth424dgets2/VJj9lSa0c1btF4yg2BfNQ=
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] autogroup runtime enable/disable tuning fix
Date: Sun, 20 Feb 2011 15:08:11 +0800
Message-Id: <1298185696-4403-1-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset focus on autogroup runtime enable/disable tuning
issue.

Below is my test when disable autogroup at runtime:

vanilla:
  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND            
 1046 test1     20   0 25544  844  276 R 50.0  0.0   0:23.30 bash               
 1044 test2     20   0 25544  860  280 R 25.2  0.0   0:20.55 bash               
 1045 test2     20   0 25544  864  284 R 24.8  0.0   0:17.48 bash

patched:
  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND            
  991 test1     20   0 25544  844  276 R 31.7  0.0   2:05.93 bash               
  992 test2     20   0 25544  848  276 R 31.7  0.0   1:16.84 bash               
  994 test2     20   0 25544  856  284 R 29.8  0.0   1:02.67 bash 


---
Yong Zhang (5):
      sched, autogroup, sysctl: use proc_dointvec_minmax instead.
      sched: hide cfs_rq of autogroup if autogroup is disabled
      sched, autogroup: stop going ahead if autogroup is disabled
      sched: refactor task_group()
      sched, autogroup: runtime enable/disable tuning fix

 include/linux/sched.h    |    3 +++
 kernel/sched.c           |   10 +++++++++-
 kernel/sched_autogroup.c |   38 ++++++++++++++++++++++++++++++++++++++
 kernel/sched_autogroup.h |    5 +++++
 kernel/sched_debug.c     |    6 ++++++
 kernel/sysctl.c          |    2 +-
 6 files changed, 62 insertions(+), 2 deletions(-)
