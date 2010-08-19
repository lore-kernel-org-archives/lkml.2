Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196Ab0HSVDv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 17:03:51 -0400
Received: from smtp1.it.da.ut.ee ([193.40.5.66]:51232 "EHLO smtp1.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750817Ab0HSVDt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 17:03:49 -0400
Date: Fri, 20 Aug 2010 00:03:47 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: Linux Kernel list <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
        linux-scsi@vger.kernel.org
Subject: qla4xxx compile failure on 32-bit PowerPC: missing readq and
 writeq
Message-ID: <alpine.SOC.1.00.1008192359310.19654@math.ut.ee>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is current 2.6.36-rc1+git on 32-bit PowerPC:

  CC [M]  drivers/scsi/qla4xxx/ql4_nx.o
drivers/scsi/qla4xxx/ql4_nx.c: In function 'qla4_8xxx_pci_mem_read_direct':
drivers/scsi/qla4xxx/ql4_nx.c:717: error: implicit declaration of function 'readq'
drivers/scsi/qla4xxx/ql4_nx.c: In function 'qla4_8xxx_pci_mem_write_direct':
drivers/scsi/qla4xxx/ql4_nx.c:788: error: implicit declaration of function 'writeq'

readq and writeq are defined in io.h but only when compiling for 64-bit 
kernel. Adding manual #include <linux/io.h> does not help here.

-- 
Meelis Roos (mroos@linux.ee)
