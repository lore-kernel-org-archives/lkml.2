Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759360Ab2EUVtS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 17:49:18 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:45663 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754260Ab2EUVtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 17:49:17 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, david.vrabel@citrix.com
Cc: xen-devel@lists.xensource.com
Subject: [PATCH] fixes to stable/for-linus-3.5
Date: Mon, 21 May 2012 17:42:40 -0400
Message-Id: <1337636562-9579-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.5
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two fixes for the patches that are going for 3.5.

The autoballoon one would try to balloon up to E820_MAX when
there were no dom0_mem=.. argument. The patch fixes it, and
is also makes the dom0_mem=1G case work better (I think?). The
other solution would be to use the current_reservation patch
I posted a while back to work-around when no dom0_mem= argument
is used.

The APIC irqworker is a little easier - it did not unbind when
unplugging vCPUs leaving an orphan IRQ behind.

