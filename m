Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752393Ab1FLLOd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 07:14:33 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:60732 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986Ab1FLLOc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 07:14:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:message-id;
        b=hb1GjFAsS1rJvMPvn2n6ol20M9thzJXak0qTpkweDbLWxLuOYsqxWgzL49AFTJatlC
         jkkOtPLxLJoOcfhyhSc+7ynTDsVN2SrCNi9G5M0y/w2nxvQKxOWs4CIKv0s6lLXGZO4E
         +olzcMeTkqObS2rvkzg9wk1BE0PQnbyCsPqC0=
From: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
To: Oren Weil <oren.jer.weil@intel.com>
Subject: mei driver breaks suspend on 3.0git
Date: Sun, 12 Jun 2011 13:14:26 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.38.6; KDE/4.6.3; x86_64; ; )
Cc: Tomas Winkler <tomas.winkler@intel.com>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201106121314.26394.a.miskiewicz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

When trying suspend to ram on 3.0git (b99ca60c83a631adaba9c2fff8f2dd14d3517a61)
I'm getting mei suspend failure:

Jun 11 23:39:26 localhost kernel: [10291.673881] uhci_hcd 0000:00:1a.1: PCI INT B disabled
Jun 11 23:39:26 localhost kernel: [10291.673898] uhci_hcd 0000:00:1a.0: PCI INT A disabled
Jun 11 23:39:26 localhost kernel: [10291.674121] pci_pm_suspend(): mei_pci_suspend+0x0/0x8b [mei] returns 2500
Jun 11 23:39:26 localhost kernel: [10291.674135] pm_op(): pci_pm_suspend+0x0/0xf1 returns 2500
Jun 11 23:39:26 localhost kernel: [10291.674141] PM: Device 0000:00:03.0 failed to suspend async: error 2500
Jun 11 23:39:26 localhost kernel: [10291.680109] ACPI handle has no context!
Jun 11 23:39:26 localhost kernel: [10291.766609] e1000e 0000:00:19.0: PCI INT A disabled
Jun 11 23:39:26 localhost kernel: [10291.766624] e1000e 0000:00:19.0: PME# enabled
Jun 11 23:39:26 localhost kernel: [10291.766642] e1000e 0000:00:19.0: wake-up capability enabled by ACPI
Jun 11 23:39:26 localhost kernel: [10291.780061] PM: Some devices failed to suspend
Jun 11 23:39:26 localhost kernel: [10291.780106] i915 0000:00:02.0: setting latency timer to 64

It's thinkpad t400 with
00:03.0 Communication controller [0780]: Intel Corporation Mobile 4 Series Chipset MEI Controller [8086:2a44] (rev 07)

-- 
Arkadiusz Miśkiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
