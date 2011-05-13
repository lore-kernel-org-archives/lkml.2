Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758511Ab1EMXYz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 19:24:55 -0400
Received: from mga09.intel.com ([134.134.136.24]:53040 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758266Ab1EMXYy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 19:24:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,366,1301900400"; 
   d="scan'208";a="747037416"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: libc-alpha@sourceware.org
Subject: Add a sysconf syscall
Date: Fri, 13 May 2011 16:24:14 -0700
Message-Id: <1305329059-2017-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We ran into some problems with programs querying then number
of processors at startup through sysconf. This calls into /proc
from glibc, which is quite slow and scales poorly if the program
is frequently executed. This happens with programs using
Sleepycat DB for example.

While there are worarounds -- like using sched_getaffinity --
they don't have quite equivalent semantics.

This patchkit adds a sysconf() syscall to the kernel that allows
to get this information much faster. It only implements a subset
of sysconf() -- all the information the kernel knows usefully
about.

Another advantage is that the kernel can in several cases offer
more accurate information than glibc, which has to guess.

The syscall is quite compat and not a significant burden.

In addition I did a few cleanups first to export all the information
needed by sysconf clearly from other subsystems.

-Andi

