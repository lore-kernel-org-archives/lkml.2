Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932791Ab1LFBF6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 20:05:58 -0500
Received: from mga11.intel.com ([192.55.52.93]:41617 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932716Ab1LFBF5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 20:05:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,302,1320652800"; 
   d="scan'208";a="92645287"
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        user-mode-linux-devel@lists.sourceforge.net,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [PATCH 0/3] UML fixes for tip:x86/syscall
Date: Mon,  5 Dec 2011 17:05:46 -0800
Message-Id: <1323133549-13590-1-git-send-email-hpa@linux.intel.com>
X-Mailer: git-send-email 1.7.6.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@linux.intel.com>

The patch series currently in -tip as x86/syscall, which builds
syscall tables from a simple text file also broke UML.

I intend to apply this patch to tip:x86/syscall, but if the UML folks
would either holler or ack that would be appreciated.

This patch series enables using generated host header files in UML,
and then uses the new x86 generated syscall tables in the same uniform
style as the native kernel.

The native kernel relies on asm-offsets.h to generate the syscall
fencepost symbols automatically (it is done that way rather in the
script to make the future extension to multiple supported ABIs work
better.)  On UML, asm-offsets.h is generated globally, but
user-constants.h has per-subarchitecture support; it feels a little
like an odd place for it but I put the fenceposts there.  The UML
folks might want to holler if that is too broken.

 arch/um/Makefile                |    9 +++++-
 arch/x86/um/Makefile            |    3 +-
 arch/x86/um/sys_call_table_32.S |   26 ------------------
 arch/x86/um/sys_call_table_32.c |   55 +++++++++++++++++++++++++++++++++++++++
 arch/x86/um/sys_call_table_64.c |   31 ++++++++-------------
 arch/x86/um/user-offsets.c      |   15 ++++++++++
 6 files changed, 91 insertions(+), 48 deletions(-)

