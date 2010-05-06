Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932555Ab0EFUiK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 16:38:10 -0400
Received: from vms173015pub.verizon.net ([206.46.173.15]:43609 "EHLO
	vms173015pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932239Ab0EFUiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 16:38:08 -0400
Date: Thu, 06 May 2010 16:37:46 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, David Airlie <airlied@linux.ie>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       dri-devel@lists.freedesktop.org
Subject: Re: linux-next: Tree for May 6 (nouveau)
In-reply-to: <20100506111856.ae15cd03.randy.dunlap@oracle.com>
Message-id: <alpine.LFD.2.00.1005061636220.12696@localhost.localdomain>
References: <20100506151502.f97afe54.sfr@canb.auug.org.au>
 <20100506111856.ae15cd03.randy.dunlap@oracle.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> When CONFIG_ACPI_BUTTON=m:
> 
> drivers/built-in.o: In function `nouveau_connector_detect':
> nouveau_connector.c:(.text+0x1d81cf): undefined reference to `acpi_lid_open'
> 
> 
> #ifdef CONFIG_ACPI
> 		if (!nouveau_ignorelid && !acpi_lid_open())
> 			status = connector_status_unknown;
> #endif
> 
> 
> Do you want that to be
> #ifdef CONFIG_ACPI_BUTTON
> ?
> That will still only be built when CONFIG_ACPI_BUTTON=y (not =m).
> 

intel_lvds.c seems to handle this issue without #ifdefs
by including acpi/button.h

cheers,
Len Brown, Intel Open Source Technology Center

