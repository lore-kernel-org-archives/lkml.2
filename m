Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755379Ab2GAJxr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 05:53:47 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:59367 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145Ab2GAJxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 05:53:46 -0400
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <20120701073641.GA17790@avionic-0098.adnet.avionic-design.de>
References: <1341102443.3712.0.camel@phoenix> <1341102507.3712.1.camel@phoenix>
 <20120701073641.GA17790@avionic-0098.adnet.avionic-design.de>
From: Axel Lin <axel.lin@gmail.com>
Date: Sun, 1 Jul 2012 17:53:25 +0800
Message-ID: <CAF+7xWnj1cEaUw8HgJ7vf35Ny-aAmoFpj9Q2rOxJ3VnPue0PPg@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] pwm: Convert pwm-pxa to use devm_* APIs
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: linux-kernel@vger.kernel.org, Eric Miao <eric.y.miao@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> -     pwmchip_remove(&chip->chip);
>> -
>> -     iounmap(chip->mmio_base);
>> -
>> -     r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> -     release_mem_region(r->start, resource_size(r));
>> -
>> -     clk_put(chip->clk);
>> -     kfree(chip);
>> -     return 0;
>> +     return pwmchip_remove(&chip->chip);
>
> What I meant was that this driver didn't return an error on failure of
> pwmchip_remove() before so incorporating this change is unrelated to
> this patch. Either make it a separate patch (preferably) or at least
> mention it in the commit message.
Oh. I just thought it is a trivial change and it probably ok to do so.
Anyway, Since you prefer having this change in a separate patch,
I'd send a v3 that leave this part unchanged.

Regards,
Axel

>
> Thierry
