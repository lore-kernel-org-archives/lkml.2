Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384Ab0DIOVk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 10:21:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:33479 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753040Ab0DIOVg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 10:21:36 -0400
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: linux-kernel@vger.kernel.org, gpxe-devel@etherboot.org
Subject: [PATCH] Update iBFT to 1.03
Date: Fri,  9 Apr 2010 14:21:26 +0000
Message-Id: <1270822888-13192-1-git-send-email-konrad@kernel.org>
X-Mailer: git-send-email 1.7.0.4
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 09 Apr 2010 14:21:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch writen by Peter Jones and Mike Christie expands on the
iBFT firmware driver to support v1.03 of the spec. The spec in question is
available at:

ftp://ftp.software.ibm.com/systems/support/bladecenter/iscsi_boot_firmware_table_v1.03.pdf

Linux kernel has support for the iBFT 1.0 spec and this update to 1.03
adds three more things:
 - There is now a ACPI table either called 'iBFT' or 'IBFT' that should
   be parsed.
 - If running with UEFI, only look at the ACPI table.
 - If not found within ACPI tables, fall back to the old mechanism of scanning
   memory for the signature.

It has been tested with gPXE and also a real hardware (Mike, did I get that right?)

