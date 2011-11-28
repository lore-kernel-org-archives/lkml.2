Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956Ab1K1RVT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 12:21:19 -0500
Received: from smarthost3.mail.uk.easynet.net ([212.135.6.13]:47415 "EHLO
	smarthost3.mail.uk.easynet.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753120Ab1K1RVS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 12:21:18 -0500
X-Greylist: delayed 3727 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Nov 2011 12:21:18 EST
Subject: MFD: core assumes that all children are platform devices
Content-Transfer-Encoding: 8BIT
From: =?iso-8859-1?Q?Jean-Fran=E7ois_Dagenais?= <dagenaisj@sonatest.com>
Content-Type: text/plain; charset=us-ascii
Message-Id: <2F9D884C-6B95-4F81-8445-8056676B28D8@sonatest.com>
Date: Mon, 28 Nov 2011 11:23:00 -0500
Cc: open list <linux-kernel@vger.kernel.org>
To: Samuel Ortiz <sameo@linux.intel.com>
Mime-Version: 1.0 (Apple Message framework v1084)
X-Mailer: Apple Mail (2.1084)
X-OriginalArrivalTime: 28 Nov 2011 16:22:54.0868 (UTC) FILETIME=[FBB2B540:01CCADE9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have a pci driver that registers with UIO for it's operations. As a consequence, the pci device
instance has a child device of class uio.

My driver also declares a ds1wm instance that has it's register interface at an offset in BAR0
of the pci device, as an MFD cell.

When I call mfd_remove_devices, MFD proceeds to enumerate ALL the parent device's chilren
and assumes that they are MFD cells, and thus platform_device, which is not true in my case.
(...uio is a child of the parent pci device)

I had (luckily or unluckily) not seen signs of this broken assumption on certain setups I have
used, but in my current setup, this page-faults every time now.

This is a major thing and I have not found the assumption documented anywhere.

I could first declare a new child device on my pci device and then declare it as the parent to
the mfd cells...

Or, is there a way for the mfd-core, as it's doing the "for each child device", to recognize
non-MFD-cell children and skip them?

/jfd