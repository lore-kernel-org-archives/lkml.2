Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757396Ab1DMUK5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 16:10:57 -0400
Received: from oproxy2-pub.bluehost.com ([67.222.39.60]:35485 "HELO
	oproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751096Ab1DMUK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 16:10:56 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=heK3y2pFaIgGOKUck43nl6/vnWHrEgzXBkhSntsH/Sid3rDZKK9wS9H/m+o39+j7jFUVA4a9wuVJcx64Kx48gdpbaCOfjfimyjFMqG0bkihO87tLvIm6WxUey+vYXvHQ;
Date: Wed, 13 Apr 2011 13:10:54 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Xianghua Xiao <xiaoxianghua@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Disable PCI while CONFIG_PCI=y
Message-Id: <20110413131054.8771d855.rdunlap@xenotime.net>
In-Reply-To: <BANLkTikAqz5xBRfpxBuwxVujE--Qam2FsQ@mail.gmail.com>
References: <BANLkTikAqz5xBRfpxBuwxVujE--Qam2FsQ@mail.gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Apr 2011 15:05:59 -0500 Xianghua Xiao wrote:

> Is it possible to do something like 'pci=off' to have the same effect
> as turning of CONFIG_PCI during menuconfig?
> I want to build one image for both PCIE RC and PCIE EP(endpoint), for
> EP I do not need PCI to be enabled at all.
> 
> looking at drivers/pci/pci.c I don't see such option exists, am I
> missing something?

Hm. Documentation/kernel-parameters.txt says:


	pci=option[,option...]	[PCI] various PCI subsystem options:
		earlydump	[X86] dump PCI config space before the kernel
			        changes anything
		off		[X86] don't probe for the PCI bus

What $ARCH are you using?

See arch/x86/pci/common.c::pcibios_setup() for code that handles
	pci=off

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
