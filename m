Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858Ab1CJUhV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 15:37:21 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:24305 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295Ab1CJUhS (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 10 Mar 2011 15:37:18 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Ian Campbell <Ian.Campbell@citrix.com>
Cc: xen-devel@lists.xensource.com, Konrad Rzeszutek Wilk <konrad@kernel.org>
Subject: [PATCH] small bug-fixes
Date: Thu, 10 Mar 2011 15:36:43 -0500
Message-Id: <1299789405-30802-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4D79366F.00A1,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During testing (git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git #linux-next)

I found that ballooning of PV guests stopped working and traced it down to
2f14ddc3a7146ea4cd5a3d1ecd993f85f2e4f948
"xen/setup: Inhibit resource API from using System RAM E820 gaps as PCI mem gaps"
which is correct for the initial domain, but not for true PV guests. This patch:

 "xen/e820: Don't mark balloon memory as E820_UNUSABLE when running as guest."
   fixes that.

The second I found when running 2.6.32 pvops tree when we swapped over from
using level_irq handler for VIRQ to percpu irq handler. There is a race window
that I was able to hit 66% of time. With 2.6.38 I can't seem to hit this and I am
not sure why - but it still makes sense to add this patch in. The patch in
question is:

 xen/hvc: Disable probe_irq_on/off from poking the hvc-console IRQ line.

