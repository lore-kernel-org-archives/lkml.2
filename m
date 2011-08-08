Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752993Ab1HHRw3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 13:52:29 -0400
Received: from www17.your-server.de ([213.133.104.17]:56883 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773Ab1HHRw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 13:52:28 -0400
Subject: Missing put_cpu() in arch/s390/oprofile/hwsampler.c?
From: Thomas Meyer <thomas@m3y3r.de>
To: robert.richter@amd.com, schwidefsky@de.ibm.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Julia Lawall <julia@diku.dk>
Date: Mon, 08 Aug 2011 19:51:53 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1312825916.5589.150.camel@localhost.localdomain>
Mime-Version: 1.0
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function hws_oom_callback() seems to miss a corresponding put_cpu().

Or is this done in another function? I didn't find it.

thomas

---

 Check for get/put_cpu() imbalances

 The simplified semantic patch that makes this report is:

* get_cpu()
... when != put_cpu()
? get_cpu()

drivers/crypto/n2_core.c:986:25-26: WARNING: Possible missing put_cpu()!
drivers/crypto/n2_core.c:1041:25-26: WARNING: Possible missing put_cpu()!
drivers/scsi/fcoe/fcoe.c:1163:29-30: WARNING: Possible missing put_cpu()!
drivers/scsi/fcoe/fcoe.c:1630:47-48: WARNING: Possible missing put_cpu()!
arch/um/sys-i386/ldt.c:53:17-18: WARNING: Possible missing put_cpu()!
arch/powerpc/kernel/machine_kexec_64.c:188:18-19: WARNING: Possible missing put_cpu()!
arch/ia64/sn/kernel/sn2/sn_hwperf.c:618:52-53: WARNING: Possible missing put_cpu()!
arch/s390/oprofile/hwsampler.c:553:16-17: WARNING: Possible missing put_cpu()!
arch/s390/kernel/vtime.c:430:22-23: WARNING: Possible missing put_cpu()!
arch/s390/kernel/vtime.c:473:15-16: WARNING: Possible missing put_cpu()!
arch/blackfin/kernel/cplbinfo.c:89:9-10: WARNING: Possible missing put_cpu()!

This list contains some false positives.

Thanks to Julia for the semantic patch to find these kind of errors!

