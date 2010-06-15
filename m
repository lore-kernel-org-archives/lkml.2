Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932103Ab0FONzX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 09:55:23 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:51948 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757575Ab0FONzV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 09:55:21 -0400
Subject: [RFC][PATCH 0/9] rework KVM mmu_shrink() code
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Tue, 15 Jun 2010 06:55:18 -0700
Message-Id: <20100615135518.BC244431@kernel.beaverton.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a big RFC for the moment.  These need a bunch more
runtime testing.

--

We've seen contention in the mmu_shrink() function.  This patch
set reworks it to hopefully be more scalable to large numbers
of CPUs, as well as large numbers of running VMs.

The patches are ordered with increasing invasiveness.

These seem to boot and run fine.  I'm running about 40 VMs at
once, while doing "echo 3 > /proc/sys/vm/drop_caches", and
killing/restarting VMs constantly.

Seems to be relatively stable, and seems to keep the numbers
of kvm_mmu_page_header objects down.
