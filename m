Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755646Ab1CHPVF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 10:21:05 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:56956 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755315Ab1CHPVC (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 8 Mar 2011 10:21:02 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Ian Campbell <Ian.Campbell@citrix.com>
Cc: xen-devel@lists.xensource.com, Konrad Rzeszutek Wilk <konrad@kernel.org>
Subject: [PATCH] fix racing bootup issue with hvc_console.
Date: Tue,  8 Mar 2011 10:20:15 -0500
Message-Id: <1299597616-20086-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4D764952.0027,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is for 2.6.32 and 2.6.39 tree.

This particular bug I see quite often (66% time) when using the 2.6.32.X pvops kernel.
When using the 2.6.38 I do not see it, but I still think it is worth up-porting.

Please take a look.

Konrad Rzeszutek Wilk (1):
      xen/hvc: Disable probe_irq_on/off from poking the hvc-console IRQ line.


 drivers/char/hvc_xen.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

