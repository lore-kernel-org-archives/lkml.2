Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758063Ab0FUTDn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 15:03:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39654 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757893Ab0FUTDm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 15:03:42 -0400
Message-ID: <4C1FB70A.8050402@zytor.com>
Date: Mon, 21 Jun 2010 12:01:30 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>, Alan Cox <alan@linux.intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Moblin Kernel <moblin-kernel@linux.intel.com>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH] x86/mrst/pci: avoid enabling intx for msi capable devices
References: <1277145055-20566-1-git-send-email-jacob.jun.pan@linux.intel.com>
In-Reply-To: <1277145055-20566-1-git-send-email-jacob.jun.pan@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse: are you taking this or should I?

	-hpa

On 06/21/2010 11:30 AM, Jacob Pan wrote:
> On Moorestown platform, true PCI devices with MSI capabilities do not support
> INTx mode. IRQ line# for those devices are zeros in the PCI shim, an attempt
> to enable INTx on these MSI capable devices will cause conflict in the system
> such as IRQ0 for the system timers.
> If the device driver probes/enables MSI before pci_enable_device(), the conflict
> is not shown since INTx will be disabled. But if the driver tries to enable INTx
> before MSI, the conflict will cause system timer IRQ0 to break.
> 
> This patch will ensure the ordering of INTx and MSI setup by the driver is
> not relavent to INTx conflict. We will always skip INTx setup for MSI capable
> devices on Moorestown.
