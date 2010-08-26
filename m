Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751857Ab0HZRsS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 13:48:18 -0400
Received: from vms173011pub.verizon.net ([206.46.173.11]:41730 "EHLO
	vms173011pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157Ab0HZRsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 13:48:17 -0400
Date: Thu, 26 Aug 2010 13:47:55 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Jack Steiner <steiner@sgi.com>
Cc: mingo@elte.hu, tglx@linutronix.de, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] - Mapping ACPI tables as CACHED
In-reply-to: <20100817155939.GA4354@sgi.com>
Message-id: <alpine.LFD.2.00.1008261338230.2062@localhost.localdomain>
References: <20100722152220.GA18290@sgi.com> <20100817155939.GA4354@sgi.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Aug 2010, Jack Steiner wrote:

> On EFI-enabled systems (like UV), the ACPI tables are already mapped as
> WB memory. This is done in the EFI function efi_enter_virtual_mode().
> 
> The E820_ACPI & E820_NVS regions will be mapped as WB memory if the BIOS
> sets the WB attribute in the EFI memmap entry for the chunk of memory.
> 
> The ACPI code in acpi_os_map_memory() is not currently aware of the EFI mapping
> & currently maps the memory as UC. This seems like a bug.
> 
> In order to prevent attribute aliasing, I think the ACPI mapping needs to
> be consistent with the EFI mapping.  Otherwise, we will have the OS
> referencing the memory as UC at the same time BIOS is referencing it as WB.

When would the firmware touch those tables after booting the OS?

We once found a Toshiba laptop where the BIOS
scribbles on the DSDT at run-time.
We presumed from this that Windows
must snapshot the tables at boot and run from a copy.

We decided not to copy the tables, but to use them in-place.
So we added a check for run-time corruption of the tables
and we've seen it fire only on that one Toshiba box
(which now boots with "acpi=copy_dsdt").

thanks,
Len Brown, Intel Open Source Technology Center



