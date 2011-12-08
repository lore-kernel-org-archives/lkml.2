Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482Ab1LHOJO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 09:09:14 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:43613 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927Ab1LHOJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 09:09:09 -0500
From: Borislav Petkov <bp@amd64.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Tony Luck <tony.luck@intel.com>, X86-ML <x86@kernel.org>,
        EDAC devel <linux-edac@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 0/2] x86, MCE: Catch the early worm
Date: Thu,  8 Dec 2011 15:08:50 +0100
Message-Id: <1323353332-5671-1-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.8.rc0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Currently, we don't decode MCEs which are being detected during MCA
initialization and before registration of the decoders on the decoding
notifier chain. These two patches add the functionality to drain the
mcelog buffer right after we've registered a decoder.

With it, early MCEs get caught and decoded into the dmesg:

...
[    0.068003] ... generic registers:      6
[    0.068003] ... value mask:             0000ffffffffffff
[    0.068003] ... max period:             00007fffffffffff
[    0.068003] ... fixed-purpose events:   0
[    0.068003] ... event mask:             000000000000003f
[    0.068003] MCE: In-kernel MCE decoding enabled.
[    0.068003] [Hardware Error]: CPU:0  MC0_STATUS[-|UE|MiscV|-|AddrV|-|-]: 0xac80000000000833
[    0.068003] [Hardware Error]:        MC0_ADDR: 0x00000000f8080000
[    0.068003] [Hardware Error]: Data Cache Error: System Read Data Error.
[    0.068003] [Hardware Error]: cache level: L3/GEN, mem/io: MEM, mem-tx: DRD, part-proc: SRC (no timeout)
[    0.068069] Booting Node   0, Processors  #1
[    0.068276] smpboot cpu 1: start_ip = 88000
[    0.160077]  #2
[    0.160206] smpboot cpu 2: start_ip = 88000
[    0.252073]  #3 Ok.
...

Comments and suggestions are welcome, as always.

Thanks.
