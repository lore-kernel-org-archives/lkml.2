Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753633Ab1FTULF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 16:11:05 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:53795 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736Ab1FTULB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 16:11:01 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] USB: ehci: use packed,aligned(4) instead of removing the packed attribute
Date: Mon, 20 Jun 2011 22:09:34 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc1nosema+; KDE/4.6.3; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Alexander Holler <holler@ahsoftware.de>, gregkh@suse.de,
        Nicolas Pitre <nico@fluxnic.net>, linux-usb@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>, Rabin Vincent <rabin@rab.in>
References: <Pine.LNX.4.44L0.1106201436430.2113-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1106201436430.2113-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106202209.35152.arnd@arndb.de>
X-Provags-ID: V02:K0:053sBDXy4IHbwAWSQPE+sk7HKXvDxuzJRhf9RVvZ7Px
 Rca70Vfzzc26rY8/ePkuhhHOP5sOIOLXOZDLFI83lNQTvCFtds
 1aSScnEQxkxhZZsFZAPBEXHG5mNM3E6kvYmbpApQe/Ox/pUtPH
 v1Y6qolNsi8sYfzCqu9lzEWVUzCDSTY7zLnNY1oVzZG0BOc1Rv
 tRPUdY1K0ph+yG6q22uUQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 20 June 2011 20:39:02 Alan Stern wrote:
> On Mon, 20 Jun 2011, Alexander Holler wrote:
> 
> > I see it that way: packed is needed to be sure that at least for struct 
> > ehci_regs there are no padding bytes inbetween the members.
> 
> But is it really needed?

No. When the structure is marked packed, it's broken because it relies
on undefined behavior. If it's not packed, there is no problem.

> > It might 
> > work without, but that depends on the compiler (-version, architecture, 
> > whatever).
> 
> Have there ever been any combinations of compiler, version, 
> architecture, whatever, that had unwanted padding bytes in this 
> structure?

Only on compilers that are not able to build Linux kernels anyway.

	Arnd
