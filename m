Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108Ab2HCXvX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 19:51:23 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:63355 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753985Ab2HCXvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 19:51:21 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1208032349500.9164@bwv190.internetdsl.tpnet.pl>
References: <Pine.LNX.4.64.1208031728120.9164@bwv190.internetdsl.tpnet.pl>
	<CAE9FiQXzyxSNiPW96mqcN-Ki2RYZeKyYMJ39R50yjkgHnLMnYQ@mail.gmail.com>
	<Pine.LNX.4.64.1208032349500.9164@bwv190.internetdsl.tpnet.pl>
Date: Fri, 3 Aug 2012 16:51:20 -0700
X-Google-Sender-Auth: AKyqufhcCMS-JActXduYuBulPQg
Message-ID: <CAE9FiQVhDbW1_58BZ3fHcmMq6nCdUJ_9yKV=w077fG2JENRdZw@mail.gmail.com>
Subject: Re: bisected pcmcia bug - unable to map card memory on old laptops
From: Yinghai Lu <yinghai@kernel.org>
To: Piotr Gluszenia Slawinski <curious@bwv190.internetdsl.tpnet.pl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Bjorn Helgaas <bhelgaas@google.com>,
        linux-kernel@vger.kernel.org, linux-pcmcia@lists.infradead.org,
        linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 3, 2012 at 2:53 PM, Piotr Gluszenia Slawinski
<curious@bwv190.internetdsl.tpnet.pl> wrote:
>>> bug is present in all kernels since late 2.6.36
>>
>>
>> can you send the boot log with working and not working kernel?
>> Please make sure you have PCI_DEBUG set in your config.
>
>
> system is ISA based :) but i've enabled it for sake of clarity.

Good.

>
> logs are attached both systems are 3.5 kernel, working is one where i've
> simply commented out the code preventing low mem allocation in resource.c
>
> btw. note that if i would enable pci support in older kernels
> bug would most likely resurface even there.

pcmcia :: nonstatic_find_mem_region
do try to allocate mem under 1M.

should replace
arch_remove_reservations()

with reserve resource in iomem resource tree if needed for some platform.

current arch_remove_reservations keep clip the with e820 table.

also there are two local resource_clip have different meaning. one is
"include" and another one is "exclude"

Yinghai
