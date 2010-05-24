Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755709Ab0EXB7Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 21:59:25 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:60693 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753628Ab0EXB7X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 21:59:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ShJ6WjXoMLToi7llpPaCHTTHvxDUmB0K6m7KjMsSEj9WYmRSnC2lgbQ6U7DdrnLGL3
         dltoqFXTbxxnKWmU3CSbQ9W83bfnG6cz5HPp5AasYqGBlipDgiOPYqR82LMODYAhGipI
         1f/s9MShec9Jibn1DyuGR++sSdoRa6L1r2cNs=
MIME-Version: 1.0
In-Reply-To: <20100524112405.3c62d22b.sfr@canb.auug.org.au>
References: <20100524112405.3c62d22b.sfr@canb.auug.org.au>
Date: Mon, 24 May 2010 10:59:22 +0900
Message-ID: <AANLkTilGB0xf7qSDAdFTlaRgcqmf0PexkfczaKCFG06C@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the async_tx tree
From: Jassi Brar <jassisinghbrar@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jassi Brar <jassi.brar@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 24, 2010 at 10:24 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:

.....

> Caused by commit 0376653c268fce662831fbd109ce9811b25c16c2 ("DMA: PL330:
> Add dma api driver").  Maybe this depends on a particular architecture?

This driver is for any platform that has the ARM's Primcell DMAC
PL330. So there is no dependency on ARCH_xxxx
Any platform with such a DMAC should select PL330 and this driver
had better be build depending upon PL330 rather than selecting  PL330.

Something like...

config PL330_DMA
       tristate "DMA API Driver for PL330"
       select DMA_ENGINE
-       select PL330
+      depends on PL330
       help
         Select if your platform has one or more PL330 DMACs.
         You need to provide platform specific settings via
         platform_data for a dma-pl330 device.

I am not aware of how such issues are fixed at this stage, please
let me know what is expected of me.

Regards.
