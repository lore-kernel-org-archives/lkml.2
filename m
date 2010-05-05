Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755625Ab0EEXua (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 19:50:30 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48151 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752324Ab0EEXu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 19:50:28 -0400
Date: Thu, 6 May 2010 00:55:57 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, gregkh@suse.de,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       devel@driverdev.osuosl.org
Subject: Re: [PATCH -next] staging/rar_register: depends on PCI
Message-ID: <20100506005557.7d458c7b@lxorguk.ukuu.org.uk>
In-Reply-To: <20100505154522.c3d7807c.randy.dunlap@oracle.com>
References: <20100505123409.ed5678a2.sfr@canb.auug.org.au>
	<20100505154522.c3d7807c.randy.dunlap@oracle.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 May 2010 15:45:22 -0700
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> rar_register driver uses PCI interfaces and PCI devices, so it
> should depend on PCI.
> 
> Also format the Kconfig help text as normally done.
> 
> drivers/staging/rar_register/rar_register.c:623: error: implicit declaration of function 'pci_dev_get'
> drivers/staging/rar_register/rar_register.c:623: warning: assignment makes pointer from integer without a cast
> 
> Note:  The memrar driver selects this driver's Kconfig symbol, even when
> PCI is not enabled.  That select could be changed to
> 	select RAR_REGISTER if PCI
> but that would still result in build errors when PCI is not enabled, namely:
> drivers/built-in.o: In function `memrar_fini_rar_resources':
> memrar_handler.c:(.text+0x2391b7): undefined reference to `unregister_rar'
> drivers/built-in.o: In function `memrar_registration_callback':
> memrar_handler.c:(.text+0x23925a): undefined reference to `rar_get_address'
> drivers/built-in.o: In function `memrar_init':
> memrar_handler.c:(.init.text+0x12c7b): undefined reference to `register_rar'
> memrar_handler.c:(.init.text+0x12c97): undefined reference to `register_rar'
> 
> Does anyone have suggestions for this?

Yes - memrar should depend upon the RAR_REGISTER

> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

Acked-by: Alan Cox <alan@linux.intel.com>
