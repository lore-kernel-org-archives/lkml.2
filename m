Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809Ab0HRSHi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 14:07:38 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:1597 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751621Ab0HRSHc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 14:07:32 -0400
X-Server-Uuid: B55A25B1-5D7D-41F8-BC53-C57E7AD3C201
From: "Brian Norris" <norris@broadcom.com>
To: linux-mtd@lists.infradead.org
cc: "Linux Kernel" <linux-kernel@vger.kernel.org>,
        "Artem Bityutskiy" <dedekind1@gmail.com>,
        "David Woodhouse" <dwmw2@infradead.org>,
        "Brian Norris" <norris@broadcom.com>,
        "Sneha Narnakaje" <nsnehaprabha@ti.com>
Subject: [PATCH v2 0/2] Deprecate ECCGETLAYOUT
Date: Wed, 18 Aug 2010 11:06:44 -0700
Message-ID: <1282154806-9420-1-git-send-email-norris@broadcom.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <4C5CA4A1.1040000@broadcom.com>
References: <4C5CA4A1.1040000@broadcom.com>
MIME-Version: 1.0
X-WSS-ID: 6072FEEA3KC81782374-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following two patches are implementations of two different
strategies to deprecate the ioctl ECCGETLAYOUT. This ioctl is not
very useful and imposes restrictions on expanding the corresponding
kernel struct nand_ecclayout. Either patch will leave functionality
intact but allow the kernel-space layouts to expand in the future.

Strategy 1: Create new struct nand_ecclayout_l and convert all kernel
  code to use this struct.
Strategy 2: Rename old struct nand_ecclayout_user and modify
  nand_ecclayout to be used in the kernel only.

Either strategy employs a new function that will shrink the larger
layout to fit the size of the old one.

Please let me know if either of these will have unintended
consequences. I believe I have tested these sufficiently in both
simulation and hardware.

Thanks,
Brian

Brian Norris (2):
  mtd: nand: Expand nand_ecc_layout, deprecate ioctl ECCGETLAYOUT
  mtd: nand: Expand nand_ecc_layout, deprecate ioctl ECCGETLAYOUT

