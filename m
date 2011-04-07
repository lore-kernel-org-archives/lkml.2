Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756216Ab1DGWcA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 18:32:00 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51825
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755867Ab1DGWb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 18:31:58 -0400
Date: Thu, 07 Apr 2011 15:31:21 -0700 (PDT)
Message-Id: <20110407.153121.115952367.davem@davemloft.net>
To: benh@kernel.crashing.org
Cc: linux-pci@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, bheglaas@google.com, monstr@monstr.eu,
        tglx@linuxtronix.de, bigeasy@linuxtronix.de
Subject: Re: [PATCH 1/5] pci/of: Match PCI devices to OF nodes dynamically
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110407.152937.59699180.davem@davemloft.net>
References: <1302146796-26825-2-git-send-email-benh@kernel.crashing.org>
	<20110407.152707.39195948.davem@davemloft.net>
	<20110407.152937.59699180.davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p37MW6jS010571

From: David Miller <davem@davemloft.net>
Date: Thu, 07 Apr 2011 15:29:37 -0700 (PDT)

> From: David Miller <davem@davemloft.net>
> Date: Thu, 07 Apr 2011 15:27:07 -0700 (PDT)
> 
>> However, of_pci_find_child_device() lives in drivers/of/of_pci.c which is not
>> built into the tree because you haven't provided the necessary changes to
>> drivers/of/Makefile in this patch.
> 
> Oh I see, it exists already but it's only built into the tree for
> microblaze, x86, and ppc.
> 
> There's a lot of stuff in there which is superfluous and will never
> be used on sparc.
> 
> Everything in there except the new of_pci_find_child_device() function
> will be never ever used on sparc and therefore dead code.

Furthermore it will never build on sparc even if we wanted to do so
temporarily because it references interfaces sparc doesn't provide:

drivers/of/of_pci.c: In function ¡of_irq_map_pci¢:
drivers/of/of_pci.c:32:3: error: implicit declaration of function ¡of_irq_map_one¢ [-Werror=implicit-function-declaration]
drivers/of/of_pci.c:56:4: error: implicit declaration of function ¡pci_bus_to_OF_node¢ [-Werror=implicit-function-declaration]
drivers/of/of_pci.c:56:11: warning: assignment makes pointer from integer without a cast [enabled by default]
drivers/of/of_pci.c:90:2: error: implicit declaration of function ¡of_irq_map_raw¢ [-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors

I don't think it's a good idea to mix the things you're trying to do
with all of the existing stuff in of_pci.c, why not create a new file
for the stuff you're trying to consolidate?
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
