Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933254Ab1LFKhx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 05:37:53 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35303 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933134Ab1LFKhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 05:37:51 -0500
Date: Tue, 6 Dec 2011 02:37:30 -0800
From: tip-bot for Alan Cox <alan@linux.intel.com>
Message-ID: <tip-dd13752537d36cc6c145cb040f71ce7acda31e6e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, alan@linux.intel.com, hpa@zytor.com,
        mingo@redhat.com, tglx@linutronix.de, sgruszka@redhat.com,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, alan@linux.intel.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, sgruszka@redhat.com,
        mingo@elte.hu
In-Reply-To: <20111205231433.28811.51297.stgit@bob.linux.org.uk>
References: <20111205231433.28811.51297.stgit@bob.linux.org.uk>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/intel_mid: Fix the Kconfig for MID selection
Git-Commit-ID: dd13752537d36cc6c145cb040f71ce7acda31e6e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 06 Dec 2011 02:37:36 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  dd13752537d36cc6c145cb040f71ce7acda31e6e
Gitweb:     http://git.kernel.org/tip/dd13752537d36cc6c145cb040f71ce7acda31e6e
Author:     Alan Cox <alan@linux.intel.com>
AuthorDate: Mon, 5 Dec 2011 23:14:39 +0000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 6 Dec 2011 11:28:36 +0100

x86/intel_mid: Fix the Kconfig for MID selection

We currently fail to build on CONFIG_X86_INTEL_MID=y and
CONFIG_X86_MRST unset.

We could build all the bits to make generic MID work if you
picked MID platform alone but that's really silly. Instead use
select and two variables.

This looks a bit daft right now but once we add a Medfield
selection it'll start to look a good deal more sensible.

Reported-by: Ingo Molnar <mingo@elte.hu>
Reported-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
Link: http://lkml.kernel.org/r/20111205231433.28811.51297.stgit@bob.linux.org.uk
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/Kconfig |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index cb9a104..5553f9f 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -390,7 +390,7 @@ config X86_INTEL_CE
 	  This option compiles in support for the CE4100 SOC for settop
 	  boxes and media devices.
 
-config X86_INTEL_MID
+config X86_WANT_INTEL_MID
 	bool "Intel MID platform support"
 	depends on X86_32
 	depends on X86_EXTENDED_PLATFORM
@@ -399,7 +399,7 @@ config X86_INTEL_MID
 	  systems which do not have the PCI legacy interfaces (Moorestown,
 	  Medfield). If you are building for a PC class system say N here.
 
-if X86_INTEL_MID
+if X86_WANT_INTEL_MID
 
 config X86_MRST
        bool "Moorestown MID platform"
@@ -411,6 +411,7 @@ config X86_MRST
 	select SPI
 	select INTEL_SCU_IPC
 	select X86_PLATFORM_DEVICES
+	select X86_INTEL_MID
 	---help---
 	  Moorestown is Intel's Low Power Intel Architecture (LPIA) based Moblin
 	  Internet Device(MID) platform. Moorestown consists of two chips:
