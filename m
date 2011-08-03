Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753655Ab1HCPr2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 11:47:28 -0400
Received: from DMZ-MAILSEC-SCANNER-7.MIT.EDU ([18.7.68.36]:62469 "EHLO
	dmz-mailsec-scanner-7.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751934Ab1HCPrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 11:47:24 -0400
X-AuditID: 12074424-b7b0fae000000a08-98-4e396da4f568
From: Andy Lutomirski <luto@MIT.EDU>
To: x86@kernel.org, linux-kernel@vger.kernel.org
Cc: Fenghua Yu <fenghua.yu@intel.com>, Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH 0/2] Forcibly enable some MISC_ENABLE features on Intel
Date: Wed,  3 Aug 2011 11:47:15 -0400
Message-Id: <cover.1312386029.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNIsWRmVeSWpSXmKPExsUixG6norsk19LP4NEdFYu+K0fZLdqmOVpc
	3jWHzeLHhsesDiweO2fdZfdYvOclk8emVZ1sHp83yQWwRHHZpKTmZJalFunbJXBlHHl/nq3g
	KmvF623n2BsYD7J0MXJySAiYSOxt/8EEYYtJXLi3nq2LkYtDSGAfo8T3OVMZIZz1jBLzzuyA
	cp4ySeyfN5EVpIVNQEWiY+kDsHYRAQOJLStfgMWZBVwlDmx7yghiCwu4S6w5uY8dxGYRUJV4
	f2QVWD2vgL7ExI1Poc6Qkzhy+TnTBEaeBYwMqxhlU3KrdHMTM3OKU5N1i5MT8/JSi3TN9XIz
	S/RSU0o3MYLDxEVlB2PzIaVDjAIcjEo8vOVJln5CrIllxZW5hxglOZiURHn3ZQOF+JLyUyoz
	Eosz4otKc1KLDzFKcDArifC28wLleFMSK6tSi/JhUtIcLErivKXe/32FBNITS1KzU1MLUotg
	sjIcHEoSvB9zgBoFi1LTUyvSMnNKENJMHJwgw3mAhm8CqeEtLkjMLc5Mh8ifYlSUEuc9D5IQ
	AElklObB9cLi+BWjONArwrybQap4gCkArvsV0GAmoMH/31uADC5JREhJNTCmLQu9HcFq/8Q4
	e9m1KvvdiWv85p+8ncXmEn5m6ruyDINj6oe7U72vMk6IPFMjMu11vpbzAe8TKXe8RR6/+VLg
	cFJuVfPMwMboWzKJF8RmPg8993yT72nHe2YtHLUNsl8bfxa+69+Zycwi9EXXpZBl88m2E6KJ
	Fabe1cVnDB6+buGa0viE+bMSS3FGoqEWc1FxIgDZ8k4BvgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Intel allows BIOS or the OS to enable or disable some CPU fueatures via
IA32_MISC_ENABLE.  I have machines that don't enable fast strings or
monitor/mwait in BIOS, so do it on bootup instead.

The Intel SDM volume 3, appendix B.1 says that the OS should not touch
the monitor enable bit if SSE3 is not present, which presumably means
that the OS may touch that bit if SSE3 is present.  In any case, these
patches seem to work.

Andy Lutomirski (2):
  x86: Enable fast strings on Intel if BIOS hasn't already
  x86: Enable monitor/mwait on Intel if BIOS hasn't already

 arch/x86/kernel/cpu/intel.c |   37 +++++++++++++++++++++++++++++++++++--
 1 files changed, 35 insertions(+), 2 deletions(-)

-- 
1.7.6

