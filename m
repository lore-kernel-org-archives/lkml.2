Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755681Ab0I1Oxh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 10:53:37 -0400
Received: from eu1sys200aog118.obsmtp.com ([207.126.144.145]:48206 "EHLO
	eu1sys200aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753056Ab0I1Oxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 10:53:36 -0400
Message-ID: <4CA20158.5040700@stericsson.com>
Date: Tue, 28 Sep 2010 16:53:12 +0200
From: Linus Walleij <linus.walleij@stericsson.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Dan Williams <dan.j.williams@intel.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "yuanyabin1978@sina.com" <yuanyabin1978@sina.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/6] ARM: add PrimeCell generic DMA to PL022 v10
References: <1283354665-8673-1-git-send-email-linus.walleij@stericsson.com>	<1283354665-8673-2-git-send-email-linus.walleij@stericsson.com> <AANLkTinoGjwWjqHQx-+UB+9K+s97t9c0y5i5-rdw=UA4@mail.gmail.com>
In-Reply-To: <AANLkTinoGjwWjqHQx-+UB+9K+s97t9c0y5i5-rdw=UA4@mail.gmail.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Williams wrote:
> [Me]
>> As mentioned I have no clue to why this failed to compile for Grant,
>> please see if this tenth version is still problematic or if it was
>> something intermittent.
>>
>> Else I really need help in knowing what config to compile, this was
>> compiled for U300, U8500 and RealView with and without DMA enabled.
> 
> Maybe it makes more sense for these filter_id functions to be defined
> in the arch code rather than the dma driver.  Right now there seems to
> be a weird dependency of arch requires dma-driver, dma-driver requires
> arch, and slave-driver requires arch and dma-driver in order to
> dynamically select dma-driver with dma_request_channel().  It forces
> dma-driver and slave-driver to always be compiled in, if I am reading
> this correctly.

I think what happened was two things:

- First that I was switching on CONFIG_DMADEVICES rather than
  CONFIG_DMA_ENGINE which caused the immediate compile warnings

- Second I had no dummy filter function for COH901318 and ste_dma40
  in case the driver was not compiled in or available as
  module.

I actually think it is OK to request that DMA drivers always be
compiled in for slave transfer support, they are *really* infrastructure
IMO.

And that is why "my" drivers are Kconfig:ed bool.

Yours,
Linus Walleij
