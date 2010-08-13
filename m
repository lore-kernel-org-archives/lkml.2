Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934159Ab0HMKgw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 06:36:52 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:32349 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761449Ab0HMKgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 06:36:51 -0400
From: Kukjin Kim <kgene.kim@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: ben-linux@fluff.org, "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Maxim Levitsky'" <maximlevitsky@gmail.com>
Subject: undefined reference to `mmc_pm_notify' when selected MMC without PM.
Date: Fri, 13 Aug 2010 19:36:19 +0900
Message-id: <009301cb3ad3$77c8a620$6759f260$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Acs6013kncgG7a0xT7OSTxXxSM1aSw==
Content-language: ko
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Following is build error when selected MMC without PM.

drivers/built-in.o: In function `mmc_alloc_host':
drivers/mmc/core/host.c:108: undefined reference to `mmc_pm_notify'
make[1]: *** [.tmp_vmlinux1] Error 1
make: *** [sub-make] Error 2

That is added from Maxim's ' mmc: fix all hangs related to mmc/sd card
insert/removal during suspend/resume '
(commit ID: 4c2ef25fe0b847d2ae818f74758ddb0be1c27d8e)

Below is temporary patch for avoiding build error.
But I'm not sure about this... :-(

---

diff --git a/drivers/mmc/core/host.c b/drivers/mmc/core/host.c
index 0efe631..d80cfdc 100644
--- a/drivers/mmc/core/host.c
+++ b/drivers/mmc/core/host.c
@@ -86,7 +86,9 @@ struct mmc_host *mmc_alloc_host(int extra, struct device
*dev)
        init_waitqueue_head(&host->wq);
        INIT_DELAYED_WORK(&host->detect, mmc_rescan);
        INIT_DELAYED_WORK_DEFERRABLE(&host->disable,
mmc_host_deeper_disable);
+#ifdef CONFIG_PM
        host->pm_notify.notifier_call = mmc_pm_notify;
+#endif

        /*
         * By default, hosts do not support SGIO or large requests.

---

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

