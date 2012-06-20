Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756988Ab2FTRLs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 13:11:48 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:64643 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754265Ab2FTRLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 13:11:47 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQVDnS9n28GQrKVVTU7GiMtJZLFN1T9vmOm5oSysvMEVhQ@mail.gmail.com>
References: <CAOPLpQfUm-2ENkbnYfXEn1nf9FHnaRk3aqQTSTBWb-CsfCUCFA@mail.gmail.com>
 <CAE9FiQU=Uvj_OFYQLdddf8j59vE7D0aE9cdNZv7P8_Rn7=MmUQ@mail.gmail.com>
 <CAErSpo57H_ZD_-Z8z9vD3c50My4Rejtc9gXXrxGxDtQomYmrSA@mail.gmail.com>
 <CAOPLpQeJTfB2UNy3O9FgRCyZb=LyMqd0SOsz7qDM0Ur_sfeNhg@mail.gmail.com>
 <CAE9FiQVzKr+nyBh=8-v+HEDF=7JqN2CqdTNx1=LHTq=c_OyZvg@mail.gmail.com>
 <CAErSpo40SDii6PTNisAnsn6SoB7SzPUGztWAg9vaZZv+ByQsPw@mail.gmail.com> <CAE9FiQVDnS9n28GQrKVVTU7GiMtJZLFN1T9vmOm5oSysvMEVhQ@mail.gmail.com>
From: Ulrich Drepper <drepper@gmail.com>
Date: Wed, 20 Jun 2012 13:11:26 -0400
Message-ID: <CAOPLpQe+PE0NLuDuPZ1JuF+8ivr1Y+xF8dNN4y-DXV7endYtFg@mail.gmail.com>
Subject: Re: SNB PCI root information
To: Yinghai Lu <yinghai@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, jbarnes@virtuousgeek.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        lenb@kernel.org, x86@kernel.org, linux-pci@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2012 at 2:20 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> If the BIOS provide wrong _PXM, that BIOS really should be fixed at first.

Let's go there when we see BIOSes with the information...

In the meantime I tested the patch.  It needs the small modification
below (iinterdiff-generated).  The problem is the pci= parameter
handling uses ',' to separate parameters and therefore the second PCI
root information, separated by a comma, is interpreted as a new pci=
parameter.  The patch below changes the separator to ';'.  With that I
get the correct information after boot up.


Signed-off-by: Ulrich Drepper <drepper@gmail.com>

diff -u b/Documentation/kernel-parameters.txt
b/Documentation/kernel-parameters.txt
--- b/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2192,7 +2192,7 @@
 		realloc		same as realloc=on
 		busnum_node=
 				Format:
-				<bus>:<node>[, ...]
+				<bus>:<node>[;...]
 				Specifies node for bus
 		noari		do not use PCIe ARI.
 		pcie_scan_all	Scan all possible PCIe devices.  Otherwise we
diff -u b/arch/x86/pci/common.c b/arch/x86/pci/common.c
--- b/arch/x86/pci/common.c
+++ b/arch/x86/pci/common.c
@@ -509,7 +509,7 @@
 		}
 		set_mp_bus_to_node(bus, node);
 		p += count;
-		if (*p != ',')
+		if (*p != ';')
 			break;
 		p++;
 	}
