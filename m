Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756385Ab0FQB30 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 21:29:26 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:46551 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754541Ab0FQB3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 21:29:25 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4C197A49.6020400@jp.fujitsu.com>
Date: Thu, 17 Jun 2010 10:28:41 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org
CC: linux-pci@vger.kernel.org, macro@linux-mips.org,
       kamezawa.hiroyu@jp.fujitsu.com, eike-kernel@sf-tec.de
Subject: [BUG][PATCH 0/2 (v.2)] x86: ioremap() problem in X86_32 PAE
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is a updated version (v.2) of patchset to fix ioremap() problem
found in x86_32 PAE mode. The problem is that ioremap() maps wrong
address for the devices to which phisical addresses higer than 32-bit
are assigned (ioat device in my case).

Changelog
----
v.1 => v.2:
Thanks to the feedbacks, I found that some of my v.1 patches are totally
wrong because they were based on my mis-understanding about architectural
limit and linux memory management limit of physical address. In addition,
it turned out that there are bugs that handles physical address improperly
(higher 32-bits are cleared unexpectedly) also in the other places in the
ioremap() code path. Major changes are
- Removed wrong changes against phys_addr_valid() ([PATCH 2/4] in v.1).
- Removed wrong changes against wraning message in ioremap() ([PATCH 3/4]
  in v.1)
- Changed not to use PHYSICAL_PAGE_MASK because the PHYSICAL_PAGE_MASK
  would not work for physical address higher than 44-bit.
- Added fixes for remaining bugs of physical address handling in ioremap()
  code path according to the feedbacks.
- Added a fix for s_show() in vmalloc.c to show high physical address properly.
----

I also found the bug in PCI MSI-X code that handles physical address
improperly, which causes the problem MSI-X doesn't work on my devices. I'll
send a patch for this to PCI mail list separately.

The v.2 patches are:

- [PATCH 1/2] x86: ioremap: fix wrong physical address handling
- [PATCH 2/2] x86: ioremap: fix normal ram range check

Thanks,
Kenji Kaneshige

