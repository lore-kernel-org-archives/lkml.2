Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068Ab0DJBNp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 21:13:45 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:22117 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683Ab0DJBNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 21:13:43 -0400
Message-ID: <4BBFD019.9040405@oracle.com>
Date: Fri, 09 Apr 2010 18:10:49 -0700
From: Yinghai <yinghai.lu@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Andy Isaacson <adi@hexapodia.org>
CC: guenter.roeck@ericsson.com, "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Renninger <trenn@suse.de>
Subject: Re: [PATCH] x86: Reserve legacy VGA MMIO area for x86_64 as well
 as x86_32
References: <201004091004.39857.bjorn.helgaas@hp.com> <4BBF5987.3010100@zytor.com> <4BBF626A.3060800@oracle.com> <4BBF70BC.3080809@zytor.com> <1270839357.1477.758.camel@groeck-laptop> <4BBF863B.1060806@oracle.com> <20100409222103.GA11130@hexapodia.org> <4BBFA9BF.60608@oracle.com> <20100409223532.GC11130@hexapodia.org> <4BBFB1D8.6090802@oracle.com> <20100410000030.GE11130@hexapodia.org>
In-Reply-To: <20100410000030.GE11130@hexapodia.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4BBFD09D.007C:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

in addition to -v2 patch

please apply this patch too

also please boot with "debug" in boot command line.

Thanks

Yinghai

[PATCH] x86,acpi: use request_resource instead of instead of insert_resource

So make pci root resouce from _CRS honor the one We reserve in e820 below 1M

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/pci/acpi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/arch/x86/pci/acpi.c
===================================================================
--- linux-2.6.orig/arch/x86/pci/acpi.c
+++ linux-2.6/arch/x86/pci/acpi.c
@@ -168,7 +168,7 @@ setup_resource(struct acpi_resource *acp
 		return AE_OK;
 	}
 
-	conflict = insert_resource_conflict(root, res);
+	conflict = request_resource_conflict(root, res);
 	if (conflict) {
 		dev_err(&info->bridge->dev,
 			"address space collision: host bridge window %pR "
