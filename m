Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757533Ab1EKQZ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:25:28 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:39606 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756621Ab1EKQZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:25:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=PORYEYImCmlWdtudV4W4ksS6xEP7kcSKBb3Iy4iHuRNUKCS44A9gKPie6U5VRG9W2k
         kuGIBjoXvNx/axY723uki07AU0S+4ffjJSgMz6XQZordq+VpQMpoHao8AOIY2kRa6Q0i
         a2e/P1bEWEXTLtVctKChpCNX+un0Jg+zk5Q4A=
MIME-Version: 1.0
Date: Wed, 11 May 2011 11:25:22 -0500
Message-ID: <BANLkTi=e1mUTX4X7ui+HVCGh=sZ=HLoNCw@mail.gmail.com>
Subject: Bug in MTD NAND ONFI chipsize detection
From: Nitin Garg <nitingarg98@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

The nand_flash_detect_onfi function in mtd/nand detects the NAND flash
device size using the ONFI parameters:
	chip->chipsize = (uint64_t)le32_to_cpu(p->blocks_per_lun) * mtd->erasesize;

The lun_count is not taken into consideration due to which we detect
wrong size for Micron MT29F8G08ADADAH4 as it has 2 logical units.

We should change the chipsize calculation to:
	chip->chipsize = (uint64_t)le32_to_cpu(p->blocks_per_lun) *
(uint64_t)le32_to_cpu(p->lun_count) * mtd->erasesize;

Pls suggest.

Regards,
Nitin Garg
