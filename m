Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756537Ab2HUTaX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 15:30:23 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52257 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754049Ab2HUTaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 15:30:20 -0400
Message-ID: <5033E1CA.8050107@gmail.com>
Date: Tue, 21 Aug 2012 12:30:18 -0700
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: devicetree-discuss@lists.ozlabs.org, Rob Herring <rob.herring@calxeda.com>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-mips@linux-mips.org, David Daney <david.daney@cavium.com>
Subject: Re: [PATCH 2/2] spi: Add SPI master controller for OCTEON SOCs.
References: <1336772086-17248-1-git-send-email-ddaney.cavm@gmail.com> <1336772086-17248-3-git-send-email-ddaney.cavm@gmail.com> <20120520054657.091DA3E03B8@localhost>
In-Reply-To: <20120520054657.091DA3E03B8@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/19/2012 10:46 PM, Grant Likely wrote:
> On Fri, 11 May 2012 14:34:46 -0700, David Daney <ddaney.cavm@gmail.com> wrote:
>> From: David Daney <david.daney@cavium.com>
>>
>> Add the driver, link it into the kbuild system and provide device tree
>> binding documentation.
>>
>> Signed-off-by: David Daney <david.daney@cavium.com>
>
> Some comments below, but you can add my a-b:
>
> Acked-by: Grant Likely <grant.likely@secretlab.ca>
>
[...]
>> +	p->register_base = (u64)devm_ioremap(&pdev->dev, res_mem->start,
>> +					     resource_size(res_mem));
>
> Nasty cast.  p->register_base needs to be an __iomem pointer
> variable.

No, it is only ever used as an argument to cvmx_{read,write}_csr(),
which want the u64 type.

>  The fact taht cvmx_read_csr accepts a uint64_t instead of
> an __iomem pointer looks really wrong.  Why is it written that way?


Register addresses on OCTEON are 64-bits wide.  In a 32-bit kernel,
pointers are only 32-bits wide.  Thus was born the cvmx_read_csr()
function that takes a u64 address.

We no longer support 32-bit kernels, but the legacy of the interface
lives on.

David Daney

