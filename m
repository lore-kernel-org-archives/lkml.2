Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797Ab0JMKKD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 06:10:03 -0400
Received: from smtp.nokia.com ([192.100.122.230]:65438 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569Ab0JMKKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 06:10:00 -0400
From: Evgeny Kuznetsov <EXT-Eugeny.Kuznetsov@nokia.com>
To: tony@atomide.com
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, balbi@ti.com,
        linux@arm.linux.org.uk, khilman@deeprootsystems.com,
        akpm@linux-foundation.org, charu@ti.com, tero.kristo@nokia.com,
        ext-eugeny.kuznetsov@nokia.com
Subject: [PATCHv2 0/1] omap: Ptr "isr_reg" tracked as NULL was dereferenced
Date: Wed, 13 Oct 2010 14:04:49 +0400
Message-Id: <cover.1286961160.git.EXT-Eugeny.Kuznetsov@nokia.com>
X-Mailer: git-send-email 1.6.3.3
X-OriginalArrivalTime: 13 Oct 2010 10:08:36.0410 (UTC) FILETIME=[99A2B9A0:01CB6ABE]
X-Nokia-AV: Unscannable
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is second version of patch which fixes bug in 
/arch/arm/plat-omap/gpio.c file.
Pointer which may have NULL value in some cases (depend on kernel
configuration and GPIO method) is dereferenced later in code.

I removed BUG() macro to do not halt code execution accoding to comments.
And added WARN_ON() macro and exit from function if pointer "isr_reg" is NULL.
Also compilation check is added for correct architecture
configuration.

Thanks,
Evgeny

Evgeny Kuznetsov (1):
  omap: Ptr "isr_reg" tracked as NULL was dereferenced

 arch/arm/plat-omap/gpio.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

