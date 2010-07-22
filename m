Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751427Ab0GVP6O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 11:58:14 -0400
Received: from vms173009pub.verizon.net ([206.46.173.9]:36059 "EHLO
	vms173009pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743Ab0GVP6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 11:58:13 -0400
Date: Thu, 22 Jul 2010 11:57:53 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Andi Kleen <andi@firstfloor.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, "Yu, Luming" <luming.yu@intel.com>,
        Philip Langdale <philipl@overt.org>, Jeff Garrett <jeff@jgarrett.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "venki@google.com" <venki@google.com>
Subject: Re: [PATCH] ACPI: make acpi_idle Nehalem-aware
In-reply-to: <20100722074750.GA22520@one.firstfloor.org>
Message-id: <alpine.LFD.2.00.1007221153120.3164@localhost.localdomain>
References: <20100427124703.GA16706@jgarrett.org>
 <alpine.LFD.2.00.1004301218280.2489@sony>
 <20100430174447.GA14889@srcf.ucam.org>
 <d7f2dd35a4361e5156079278543769a0@localhost>
 <alpine.LFD.2.00.1005250125590.20648@localhost.localdomain>
 <CE761E84DADF2947A4AF22FB8D97A4731E0366B5@shsmsx501.ccr.corp.intel.com>
 <20100525124325.GC7876@srcf.ucam.org>
 <alpine.LFD.2.00.1005251114420.4114@localhost.localdomain>
 <20100525185507.GA15997@srcf.ucam.org>
 <alpine.LFD.2.00.1007211729550.409@localhost.localdomain>
 <20100722074750.GA22520@one.firstfloor.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is kaput.

As detailed in the bug report
https://bugzilla.kernel.org/show_bug.cgi?id=15886
we should be able to fix some of these boxes
by paying attention to an ACPI flag we didn't
realize  existed until yesterday.

I'll follow-up with a new patch today.

However, we'll still have issues with systems
like the HP DL360 G6 which explicity set the
flag to ask for BM_STS checking and configure
the chipset such that BM_STS is active.
That may require a BIOS fix, or we may
have to run intel_idle on that box --
since intel_idle ignores BM_STS always
and instead relies on drivers to use pm_qos
to register device latency constraints.

thanks,
Len Brown, Intel Open Source Technology Center

