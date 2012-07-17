Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086Ab2GQFAn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 01:00:43 -0400
Received: from ozlabs.org ([203.10.76.45]:60834 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752207Ab2GQFAk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 01:00:40 -0400
From: Michael Ellerman <michael@ellerman.id.au>
To: <kvm@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, <matt@ozlabs.org>, <penberg@kernel.org>,
        <kvm-ppc@vger.kernel.org>, <prerna@linux.vnet.ibm.com>,
        David Gibson <david@gibson.dropbear.id.au>
Subject: [RFC/PATCH] Use kernel supplied MMU info for kvm tool
Date: Tue, 17 Jul 2012 15:00:10 +1000
Message-Id: <1342501220-10209-1-git-send-email-michael@ellerman.id.au>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

This is a series for kvmtool that uses a newish kernel API to get
MMU info, which is then fed to the guest.

Currently we just make a good guess based on the PVR, but that is
potentially flakey in a few ways. The most notable is that if you don't
specify hugepages we don't boot - because the guest is told we support
16M pages, but we don't really (on HV).

I've tested this with 4K/64K host page size, and with hugepages, on
both 3.4 and 3.5 based host kernels. I've also given it a quick smoke
test with PR KVM, and it seems to work.

I'm seeing a guest crash with a 4K host kernel, but I think that is
unrelated, and happens with or without this patch series.

cheers

