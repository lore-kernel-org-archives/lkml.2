Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756452Ab1ENR5m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 13:57:42 -0400
Received: from relay03.digicable.hu ([92.249.128.185]:53093 "EHLO
	relay03.digicable.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755099Ab1ENR5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 13:57:40 -0400
X-Greylist: delayed 3240 seconds by postgrey-1.27 at vger.kernel.org; Sat, 14 May 2011 13:57:40 EDT
Message-ID: <4DCEB5BB.1080202@freemail.hu>
Date: Sat, 14 May 2011 19:02:51 +0200
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        linux-ia64@vger.kernel.org
CC: Julia Lawall <julia@diku.dk>, LKML <linux-kernel@vger.kernel.org>
Subject: incompatible struct pci_root_info?
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Original: 178.164.219.74
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have found struct pci_root_info declaration at three different places in Linux
kernel 2.6.39-rc6. Two of them are in arch/x86 and one of them is in arch/ia64.

arch/x86/pci/bus_numa.h:8:

	struct pci_root_info {
		char name[12];
		unsigned int res_num;
		struct resource res[RES_NUM];
		int bus_min;
		int bus_max;
		int node;
		int link;
	};

arch/x86/pci/acpi.c:10:

	struct pci_root_info {
		struct acpi_device *bridge;
		char *name;
		unsigned int res_num;
		struct resource *res;
		struct pci_bus *bus;
		int busnum;
	};

arch/ia64/pci/pci.c:133:

	struct pci_root_info {
		struct acpi_device *bridge;
		struct pci_controller *controller;
		char *name;
	};

As far as I know it is OK to have different types on different architectures
with the same name. Is there any reason behind having two struct pci_root_info
delcaration in arch/x86?

Regards,

	Márton Németh
