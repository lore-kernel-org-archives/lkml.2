Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932614Ab0DGOW5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 10:22:57 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37776 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753431Ab0DGOW4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 10:22:56 -0400
Date: Wed, 7 Apr 2010 16:22:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jan III Sobieski <jan3sobi3ski@gmail.com>,
       Matthew Garrett <mjg@redhat.com>, Dmitry Torokhov <dtor@mail.ru>
Cc: Yong Wang <yong.y.wang@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] eepc-wmi.c: Fix build error
Message-ID: <20100407142245.GA8714@elte.hu>
References: <k2h9c2470ce1004070257z7c45897o10fb7f4d7d1de8f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <k2h9c2470ce1004070257z7c45897o10fb7f4d7d1de8f@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jan III Sobieski <jan3sobi3ski@gmail.com> wrote:

> Hi,
> 
>   GEN     .version
>   CHK     include/generated/compile.h
>   UPD     include/generated/compile.h
>   CC      init/version.o
>   LD      init/built-in.o
>   LD      .tmp_vmlinux1
> drivers/built-in.o: In function `eeepc_wmi_notify':
> /home/test/linux-2.6/drivers/platform/x86/eeepc-wmi.c:86: undefined
> reference to `sparse_keymap_report_event'

-tip testing has triggered this bug too, see the fix below.

	Ingo

--------------------------->
>From 763400ebb305711ebbd468c030db76d631400fe1 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Wed, 7 Apr 2010 16:15:51 +0200
Subject: [PATCH] eepc-wmi.c: Fix build error

-tip testing found:

eeepc-wmi.c:(.text+0x36673c): undefined reference to `sparse_keymap_report_event'
drivers/built-in.o: In function `eeepc_wmi_init':
eeepc-wmi.c:(.init.text+0x19cd0): undefined reference to `sparse_keymap_setup'
eeepc-wmi.c:(.init.text+0x19cf0): undefined reference to `sparse_keymap_free'
eeepc-wmi.c:(.init.text+0x19d0b): undefined reference to `sparse_keymap_free'
drivers/built-in.o: In function `eeepc_wmi_exit':
eeepc-wmi.c:(.exit.text+0x2e87): undefined reference to `sparse_keymap_free'

To fix this select INPUT_SPARSEKMAP, like the ASUS driver does.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/platform/x86/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index 3046776..301e379 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -392,6 +392,7 @@ config EEEPC_WMI
 	depends on ACPI_WMI
 	depends on INPUT
 	depends on EXPERIMENTAL
+	select INPUT_SPARSEKMAP
 	---help---
 	  Say Y here if you want to support WMI-based hotkeys on Eee PC laptops.
 
