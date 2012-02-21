Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840Ab2BUALd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 19:11:33 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:22353 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754055Ab2BUALb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 19:11:31 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: pasik@iki.fi
Cc: xen-devel@lists.xensource.com, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, JBeulich@novell.com,
        kevin.tian@intel.com, ke.yu@intel.com
Subject: [RFC] follow-on patches to acpi processor and cpufreq harvester^H^H^Hpassthru (v4).
Date: Mon, 20 Feb 2012 19:07:45 -0500
Message-Id: <1329782868-1696-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.5
In-Reply-To: <20120214183006.GJ12984@reaktio.net>
References: <20120214183006.GJ12984@reaktio.net>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090209.4F42E124.0072,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I decided that passthru sounded much better so:
 [PATCH 1/3] xen/processor-passthru: Change the name to passthru

does the move to the new name, and then the next one implements the dom0_max_vcpu
support:
 [PATCH 2/3] xen/processor-passthru: Support vCPU != pCPU - aka

by enumerating the ACPI processor values directly and re-using the 'struct acpi_processor'
for the rest (the ones not enumerated by ACPI layer). I chatted with the Intel folks and
they said that it is safe to assume that the _PXX and _CXX values are the same across
all the CPUs. Not entirely sure about AMD so I need to chat with them.

The last one is just an fixup to make it easier to read:
 [PATCH 3/3] xen/processor-passthru: Remove the print_hex_dump - as

