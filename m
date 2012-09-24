Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755034Ab2IXGSx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 02:18:53 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:25603 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754976Ab2IXGSp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 02:18:45 -0400
Date: Mon, 24 Sep 2012 08:17:08 +0200
Message-Id: <201209240617.q8O6H8ED029430@localhost.localdomain>
From: Christophe Leroy <christophe.leroy@c-s.fr>
To: Alan Cox <alan@linux.intel.com>, Vitaly Bordug <vitb@kernel.crashing.org>,
        Marcelo Tosatti <marcelo@kvack.org>
CC: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v2] Powerpc 8xx CPM_UART desynchronisation
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a desynchronisation problem with CPM UART driver on
Powerpc MPC8xx. The problem happens if data is received before the device
is open by the user application.

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>

--- linux-3.5-vanilla/drivers/tty/serial/cpm_uart/cpm_uart_core.c	2012-07-21 22:58:29.000000000 +0200
+++ linux-3.5/drivers/tty/serial/cpm_uart/cpm_uart_core.c	2012-08-09 17:38:37.000000000 +0200
@@ -417,6 +417,7 @@
 			clrbits32(&pinfo->sccp->scc_gsmrl, SCC_GSMRL_ENR);
 			clrbits16(&pinfo->sccp->scc_sccm, UART_SCCM_RX);
 		}
+		cpm_uart_initbd(pinfo);
 		cpm_line_cr_cmd(pinfo, CPM_CR_INIT_TRX);
 	}
 	/* Install interrupt handler. */
