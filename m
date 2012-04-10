Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932336Ab2DJCjE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 22:39:04 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:28787 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752329Ab2DJCi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 22:38:59 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: ming.m.lin@intel.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, lenb@kernel.org, linux-acpi@vger.kernel.org,
        konrad.r.wilk@gmail.com
Subject: [PATCH] gts and bfs fixes (v2).
Date: Mon,  9 Apr 2012 22:34:04 -0400
Message-Id: <1334025246-8811-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.5
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090204.4F839D40.0022,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please consider these the two fixes to how gts and bfs parameters
are handled in 3.4-rc2:

I had sent an earlier version of 
 [PATCH 1/2] ACPI: Convert wake_sleep_flags to a value instead of

to Lin and he had reviewed it, but I redid it a bit so a second
look will be required.

The:
 [PATCH 2/2] ACPI: Pass u8 flag to acpi_enter_sleep_state from

is a regression fix - as the wakeup flag was not passed from the
assembler code to the acpi_enter_sleep_ function.

 arch/x86/kernel/acpi/sleep.h     |    2 +
 arch/x86/kernel/acpi/wakeup_32.S |    5 +++-
 arch/x86/kernel/acpi/wakeup_64.S |    3 ++
 drivers/acpi/sleep.c             |   52 ++++++++++++++++++++-----------------
 4 files changed, 37 insertions(+), 25 deletions(-)

Konrad Rzeszutek Wilk (2):
      ACPI: Convert wake_sleep_flags to a value instead of function (v2)
      ACPI: Pass u8 flag to acpi_enter_sleep_state from lowlevel assembler.


