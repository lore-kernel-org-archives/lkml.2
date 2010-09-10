Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757028Ab0IJBjZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 21:39:25 -0400
Received: from hapkido.dreamhost.com ([66.33.216.122]:39586 "EHLO
	hapkido.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756838Ab0IJBjX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 21:39:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=fl-eng.com; h=message-id:date
	:subject:from:to:reply-to:mime-version:content-type:
	content-transfer-encoding; q=dns; s=fl-eng.com; b=OM5n2Fi0D006OA
	/BculI6W6eLcpHAo/1zbr9pxo0x74zob2MCEIBupp2uRLj7J6RvgGEivMDUzQXFK
	ovAaJ9vftBhz/wAuXYKP7GsZIlWBK8876pJEJbSdd7y33M77Fqv1IlunQSu6Kr80
	efQorMOcUh/3q9YYNKlCaQTUlwGGE=
Message-ID: <234ad71a39aa28e71c3fccd1f16fd1f3.squirrel@webmail.fl-eng.com>
Date: Thu, 9 Sep 2010 21:38:39 -0400
Subject: ### DMA_ALLOC_COHERENT question
From: "steve spano" <steve@fl-eng.com>
To: linux-kernel@vger.kernel.org
Reply-To: steve@fl-eng.com
User-Agent: SquirrelMail/1.4.21
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Folks,

I probably have a simple question and I hope someone can point me in the
right direction.

I have a 2.6.30.2 kernel running with a custom device driver for a
multi-channel sound card via PCI-Express. Interrupts,DMA, everything is
working fine.

We allocate a very small 64KB buffer for our DMA actions using
dma_alloc_coherent.

Tripped across an issue with larger amounts of memory on the motherboard.
This is an x86 ATOM motherboard.

At 256MB of ram, dma_alloc_coherent gets us an address within the first
128MB of ram, near the upper 1/2 of the 256MB actually.

Then at 1GB, we get an address near the upper 1/2 again (512MB)
Then at 2GB, we get an address near the upper 1/2 again (1GB)

This causes a problem on the sound card board because we need to then map
in nearly all 2GB of address space across the PCI bar registers so we can
access our tiny 64KB dma address range sitting up near the 1GB boundary.

This seems like we are doing something not right?

Ideally, we would get a non-cached block of ram that we can DMA to and the
processor can access. This block would ideally always be located near the
base of ram (maybe right after the kernel?). That way we can open a 128MB
window into the system ram from PCI-Express and always be sure to be able
to access our DMA buffer.

Can someone provide some insight in how to do this?
Is there a differnet dma allocation procedure we should use?
Should we just put an "unsigned char []" of 64k in the driver? Can we make
that also non cache?
Or do we have to hack the kernel allocation process?

Im sure there is something simple we can do.

Thanks again

Steve Spano
FLE

