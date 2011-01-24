Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327Ab1AXXdQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 18:33:16 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:35673 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752618Ab1AXXdN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 18:33:13 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: [PATCH 0/8] ACPI: Fixes and cleanups related to iomaps management (v2)
Date: Tue, 25 Jan 2011 00:25:10 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc1+; KDE/4.4.4; x86_64; ; )
Cc: Jeff Chua <jeff.chua.linux@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>
References: <201101201226.41021.rjw@sisk.pl>
In-Reply-To: <201101201226.41021.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201101250025.10817.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Len,

The following series of patches implements some fixes of the ACPI iomaps
management.  I found the problems trying to resolve the issue of creating
iomaps of regions that have been mapped already when we save the NVS region.

To me, they are not extremely urgent, because the related issues are generally
long-standing, but some bugs addressed by them (especially [1/9]) may be
actively hurting people right now, so they look suitable for .38 as well.
This is your call, though.
 
[1/8] - Fix routines for reading and writing iomem (RCU bug; new version of the
        patch).

[2/8] - (cleanup) Do not export local functions in osl.c (this one is the same
        as https://patchwork.kernel.org/patch/491551/).

[3/8] - Use a mutex (instead of a spinlock) for the locking of iomap
        manipulations in osl.c (same as
        https://patchwork.kernel.org/patch/491751/).

[4/8] - Avoid unnecessary walks of the list of iomaps in osl.c (same as
        https://patchwork.kernel.org/patch/491671/).

[5/8] - Avoid creating iomaps for regions that have been mapped already (same
         as https://patchwork.kernel.org/patch/491741/).

[6/8] - Replace krefs used for iomap refcounting with simple reference
        counters (they are manipulated under a lock anyway; same as
        https://patchwork.kernel.org/patch/491681/).

[7/8] - Introduce function for getting a reference to an ACPI iomap (to be
        used by the NVS save/restore code; same as
        https://patchwork.kernel.org/patch/491701/).

[8/8] - Make the NVS code use existing iomaps if possible (new version).

The patches have been tested on HP nx6325, Toshiba Portege R500 and Acer
Ferrari One without causing any visible problems to happen.
 
Thanks,
Rafael

