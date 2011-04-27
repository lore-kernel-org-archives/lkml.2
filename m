Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760001Ab1D0UsU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 16:48:20 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:63120 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756824Ab1D0UsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 16:48:19 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC] ARM DMA mapping TODO, v1
Date: Wed, 27 Apr 2011 22:48:15 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.39-rc4+; KDE/4.5.1; x86_64; ; )
Cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org
References: <201104212129.17013.arnd@arndb.de> <201104272221.48601.arnd@arndb.de> <20110427202603.GY17290@n2100.arm.linux.org.uk>
In-Reply-To: <20110427202603.GY17290@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104272248.15969.arnd@arndb.de>
X-Provags-ID: V02:K0:K5UYYXSaru98u0R2yA4a3QedXVp4BK6u386IaU99gkn
 T8b2KMtBb22kg3W5x9Dn0SK75irMcKTbjOj6R6bcjoLAUKk3FF
 /X3+vpqqrZfk3p+hnN4OgTC0jtJEBzhQw/jXgqMMXSQ1+YIv8i
 Qr9XLsKmaI3LrY5RhUPIDNSicKApmZLXsDzaP4CMSJXbQx3bfd
 9BY7VPnhXZt7z+p7B+wWg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 April 2011 22:26:03 Russell King - ARM Linux wrote:
> Maybe something in asm/pci.h - but that invites having lots of bus
> specific header files in asm/.
> 
> A better solution imho would be to have an architecture callback for
> struct device which gets registered, which can inspect the type of
> the device, and set the flag depending on where it appears in the
> tree.

Ah, I was under the assumption that there was already a callback
for this. We have a dma_set_coherent_mask() implementation in
some pci hosts (ixp4xx and it8152), but that's not a proper
callback that can be override per host and it does not
actually do what we were talking about here. I guess the callback
should live in struct hw_pci in case of ARM, and set a new field
in struct device_dma_parameters.

Maybe we don't even need a new flag if we just set
device->coherent_dma_mask to zero.

	Arnd
