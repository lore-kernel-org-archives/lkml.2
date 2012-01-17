Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936Ab2AQUwb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 15:52:31 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:56103 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755469Ab2AQUw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 15:52:28 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, x86@kernel.org, joseph.cihula@intel.com,
        linux-acpi@vger.kernel.org, tboot-devel@lists.sourceforge.net,
        len.brown@intel.com, rjw@sisk.pl, mingo@redhat.com
Subject: [PATCH] cleanups in ACPI - removing tboot_ calls for 3.4 (v1)
Date: Tue, 17 Jan 2012 15:50:06 -0500
Message-Id: <1326833408-23685-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.4
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4F15DF80.0030,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am not really sure if these patches should go through the ACPI or x86 tree.
I think they are more x86-ish related and earlier patches for tboot went through
tip.. Thoughts?

Theset two patches cleanup the ACPI code by removing the 'tboot_sleep'
function call within the ACPI call and instead use a function call.

The function call is set if Intel TXT is detected, otherwise we just skip over
and continue on in hwsleep.c.

Tested on AMD, Intel w/TXT and w/o TXT. Also compile tested on IA64 which has
some reference to tboot but does not use it.

The diff-stat:
 arch/x86/kernel/tboot.c       |    9 ++++++---
 drivers/acpi/acpica/hwsleep.c |   10 +++++++---
 drivers/acpi/osl.c            |   24 ++++++++++++++++++++++++
 include/acpi/acexcep.h        |    1 +
 include/linux/acpi.h          |   10 ++++++++++
 include/linux/tboot.h         |    1 -
 6 files changed, 48 insertions(+), 7 deletions(-)


The purpose of this cleanup is two-fold:
 1). Cleanup the call a bit - that 'tboot_sleep' in ACPICA, which is suppose to be
     OS-agnostic code looks odd.
 2). Piggy-back on the function call if running under Xen [https://lkml.org/lkml/2011/12/16/447].
     Those patches are still going through review, but the cleanup patches
     can be submitted as standalone.

Thanks! 
