Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932586Ab0EFUnq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 16:43:46 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:37621 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932544Ab0EFUnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 16:43:43 -0400
Date: Thu, 6 May 2010 13:42:11 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Len Brown <lenb@kernel.org>, James Morris <jmorris@namei.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-acpi@vger.kernel.org,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for May 6 (acpi: PCI=n)
Message-Id: <20100506134211.e08c795a.randy.dunlap@oracle.com>
In-Reply-To: <alpine.LFD.2.00.1005061628070.12696@localhost.localdomain>
References: <20100506151502.f97afe54.sfr@canb.auug.org.au>
	<20100506080722.3b724475.randy.dunlap@oracle.com>
	<alpine.LFD.2.00.1005061628070.12696@localhost.localdomain>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-CT-RefId: str=0001.0A090202.4BE329CE.0172:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 06 May 2010 16:29:42 -0400 (EDT) Len Brown wrote:

> > When CONFIG_PCI is not enabled:
> > 
> > arch/x86/kernel/acpi/boot.c:1034: error: 'pci_bus_type' undeclared
> > 
> > drivers/acpi/reboot.c:30: error:implicit declaration of function 'pci_find_bus'
> > drivers/acpi/reboot.c:30: warning: assignment makes pointer from integer without a cast
> > drivers/acpi/reboot.c:38: error:implicit declaration of function 'pci_bus_write_config_byte'
> 
> CONFIG_ACPI depends on CONFIG_PCI, so this file should not be build with 
> CONFIG_PCI=n.
> 
> Please let me know how you were able to generate this illegal 
> configuration.


Same TPM kconfig that selects ACPI without any other qualifications.

In 50 randconfig builds, 12 build failures were due to that one bad kconfig.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
