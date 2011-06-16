Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758066Ab1FPOCm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 10:02:42 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:57172 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752722Ab1FPOCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 10:02:40 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mark Salter <msalter@redhat.com>
Subject: Re: [PATCH] arch/c6x: new architecture port for linux
Date: Thu, 16 Jun 2011 16:02:33 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <1305144843-5058-1-git-send-email-msalter@redhat.com> <201105211910.26025.arnd@arndb.de> <1308228871.2153.109.camel@deneb.redhat.com>
In-Reply-To: <1308228871.2153.109.camel@deneb.redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201106161602.33485.arnd@arndb.de>
X-Provags-ID: V02:K0:PwFyOI2J0dgpMt++5tRjcvpg7cC2wMcbWYVQjR/EBJ7
 xjxcrFTx6+QCEnI0qPCGsB8zXbSRfTffJqfZIrgj8vp+cHq26Y
 JuFIwCsq/n9+7HC/+tCODZxuvT1XhSjy2zKGfkvnBwCFN4uKWJ
 HuivioBCFOqgPKkRn7KFI0bWp/GAb2KF8Pz/vhh/Nd/xyCduCF
 G9uxXBIgDJO6ME7329Qng==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 16 June 2011, Mark Salter wrote:
> On Sat, 2011-05-21 at 19:10 +0200, Arnd Bergmann wrote:
> > - Do not use __raw_readl/__raw_writel.
> > 
> > - Remove your IO_ADDRESS(), __REG, VULP, __SYSREG and __SYSREGA.
> >   Replace them with proper use of ioremap().
> 
> If not __raw_readl/__raw_writel, what is the best way to access memory
> mapped device registers on a bus that does the endian conversion in
> hardware? I still need the endian conversion for devices on PCI bus.

The best option is to define a bus specific set of accessors that you
can use in the device drivers for that bus and that have well-defined
semantics regarding ordering and endianess.

Typically what happens is that at some point some hardware developer
decides to reuse a piece of logic with the opposite endianess (e.g.
when the same logic is connected to multiple CPUs), so better define
the endianess of the bus independent of the CPU and have a separate
Kconfig option for that.

	Arnd
