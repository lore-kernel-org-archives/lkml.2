Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754373Ab0F3BHK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 21:07:10 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:34478 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677Ab0F3BHI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 21:07:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=gh7xjXaThe/Q47ObBMSU8tIgwgd2PbqnzADaeyX5jPJaI7ivhJL277QM5httt7INUw
         hpK5KgrypcAPrn4Jt85Lhsh5O+gtgpD2v03ero55zxUMecvAV0Kc8yfVlB33tN5ylRbF
         x3H7IQB6tgkPC6rNBk//0jFNiWYSxp/7BtWUI=
MIME-Version: 1.0
In-Reply-To: <4C2A8879.8010000@intel.com>
References: <AANLkTinMqI7hmBYt4eN2oTLZt9_FkoNDHb-9ZF3Z7vls@mail.gmail.com>
	<4C29420D.2010406@intel.com>
	<AANLkTikJvUIcx744weazBmOfyZzEu8NgYZ4oaLP2TbZ0@mail.gmail.com>
	<4C2A8879.8010000@intel.com>
Date: Tue, 29 Jun 2010 18:07:06 -0700
X-Google-Sender-Auth: hMCK8k2ZQnVOI020ri8RxbD5DWs
Message-ID: <AANLkTinhbjuyDNYQ_meDpewacApahDoY2z6h956JE2Xj@mail.gmail.com>
Subject: Re: BUG in drivers/dma/ioat/dma_v2.c:314
From: Chris Li <lkml@chrisli.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 29, 2010 at 4:57 PM, Dan Williams <dan.j.williams@intel.com> wrote:
>> 0000:00:0f.0: ioat2_timer_event: Channel halted (10)
>
> This says that we got an invalid chain address error when trying to start
> the engine.  If there was a driver problem with init I would have expected
> to see reports from other systems.  The attached patch will print out what
> chain address we are setting.  The hardware expects a 64-byte aligned
> address which should be guaranteed by the use of pci_pool_alloc().

OK. I can't do this test remotely so I will get back to you tomorrow.

>
> However, if you are up for another experiment, I'd like to see what happens
> if you disable VT-d.  Maybe it is a misconfigured iommu table that is
> blocking the engine's access to memory?

You mean disable VT-d in kernel config or the BIOS?

BTW, I don't know how to disable VT-d in Mac BIOS. It use EFI, then simulate
a normal BIOS in the boot camp mode to boot Linux.

Another stab in the dark is that, it is Mac. It has some strange SMI interaction
like TSC drifting even after boot. I notice that in the past.

Chris
