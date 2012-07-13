Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757059Ab2GMJsD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 05:48:03 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:43814 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756965Ab2GMJsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 05:48:01 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Fri, 13 Jul 2012 11:47:59 +0200
Message-ID: <CA+icZUVorJNMQ3wyz8WuZop_fwwOuBo38wZg9s9RJizhM0yc-w@mail.gmail.com>
Subject: [3.5-rc6+] mei: irq: request_threaded_irq is missing the IRQF_ONESHOT flag
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Roland Dreier <roland@purestorage.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

while dealing with [1], I saw this mei-related infos in dmesg when
doing a suspend + resume (see [1] for more logs):

[17046.348467]  [<ffffffffa00554d8>] mei_pci_suspend+0x78/0xd0 [mei]
[17047.460315] mei 0000:00:16.0: irq 47 for MSI/MSI-X
[17047.460512] mei 0000:00:16.0: request_threaded_irq failed: irq = 47.

I am not sure whom to address with the issue - so I just asked on
#linux-rt and Thomas responded:

[ 13-Jul-2012: German local-time (UTC+2) ]
...
[11:03:40] <tglx> request_threaded_irq is missing the IRQF_ONESHOT flag
...
[11:24:18] <tglx> anyone can fix it by sending a patch which adds the flag :)

Futhermore, I found those commits, so I added folks from there to this BR:

16a50b1 mei: pci_resume: set IRQF_ONESHOT for msi request_threaded_irq
aa189ec misc: mei: set IRQF_ONESHOT for msi request_threaded_irq

If you need more infos and/or logs, please let me know.

Feel free to add:

     Reported-by: Sedat Dilek <sedat.dilek@gmail.com>

Kind Regards,
- Sedat (dileks on IRC) -

[1] http://marc.info/?l=linux-kernel&m=134216822724119&w=2
