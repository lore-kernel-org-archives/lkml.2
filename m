Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758051Ab0FUTOn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 15:14:43 -0400
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:48588 "HELO
	cpoproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755779Ab0FUTOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 15:14:41 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=S//fgIwWvR+lUvG17Fc0MTL+ntpCazogA2jOSwof/t4xbMp3b7kxKOpx9CcTvaFNonvWsoOHqqatxySf7Ho5d+kyp5Y1qRJWEvsuXMLiFHL0+UNpKgvKj8UTxDABNtqc;
Date: Mon, 21 Jun 2010 12:12:53 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>, Alan Cox <alan@linux.intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Moblin Kernel <moblin-kernel@linux.intel.com>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH] x86/mrst/pci: avoid enabling intx for msi capable
 devices
Message-ID: <20100621121253.478dfffc@virtuousgeek.org>
In-Reply-To: <4C1FB70A.8050402@zytor.com>
References: <1277145055-20566-1-git-send-email-jacob.jun.pan@linux.intel.com>
	<4C1FB70A.8050402@zytor.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Jun 2010 12:01:30 -0700
"H. Peter Anvin" <hpa@zytor.com> wrote:

> Jesse: are you taking this or should I?
> 
> 	-hpa
> 
> On 06/21/2010 11:30 AM, Jacob Pan wrote:
> > On Moorestown platform, true PCI devices with MSI capabilities do not support
> > INTx mode. IRQ line# for those devices are zeros in the PCI shim, an attempt
> > to enable INTx on these MSI capable devices will cause conflict in the system
> > such as IRQ0 for the system timers.
> > If the device driver probes/enables MSI before pci_enable_device(), the conflict
> > is not shown since INTx will be disabled. But if the driver tries to enable INTx
> > before MSI, the conflict will cause system timer IRQ0 to break.
> > 
> > This patch will ensure the ordering of INTx and MSI setup by the driver is
> > not relavent to INTx conflict. We will always skip INTx setup for MSI capable
> > devices on Moorestown.

You go ahead.  You can add my:

Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
