Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756822Ab2IJPLj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 11:11:39 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:33800 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752593Ab2IJPLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 11:11:38 -0400
MIME-Version: 1.0
In-Reply-To: <CAN1soZzTnzD-X+jZqBW6efY9uP+puZ0qX_=EWuBzDeFhmO9vCw@mail.gmail.com>
References: <1344364969-32489-1-git-send-email-broonie@opensource.wolfsonmicro.com>
	<201208071946.52211.arnd@arndb.de>
	<CAN1soZzTnzD-X+jZqBW6efY9uP+puZ0qX_=EWuBzDeFhmO9vCw@mail.gmail.com>
Date: Mon, 10 Sep 2012 23:11:37 +0800
Message-ID: <CAN1soZz250zdGXoXKbQU1VsMWkmcVwWa7qowwCbF-QTSfabBZg@mail.gmail.com>
Subject: Re: [PATCH 1/7] mfd: max8925: Move _IO resources out of ioport_ioresource
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Russell King <rmk@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 8, 2012 at 11:20 PM, Haojian Zhuang
<haojian.zhuang@gmail.com> wrote:
> On Wed, Aug 8, 2012 at 3:46 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>> On Tuesday 07 August 2012, Mark Brown wrote:
>>> The removal of mach/io.h from most ARM platforms also set the range of
>>> valid IO ports to be empty for most platforms when previously any 32
>>> bit integer had been valid. This makes it impossible to add IO resources
>>> as the added range is smaller than that of the root resource for IO ports.
>>>
>>> Since we're not really using IO memory at all fix this by defining our
>>> own root resource outside the normal tree and make that the parent of
>>> all IO resources. This also ensures we won't conflict with read IO ports
>>> if we ever run on a platform which happens to use them.
>>>
>>> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
>>> Cc: stable@vger.kernel.org (v3.4+)
>>
>> (whole series)
>>
>> Acked-by: Arnd Bergmann <arnd@arndb.de>
>>
> Acked-by: Haojian Zhuang <haojian.zhuang@gmail.com>
> Tested-by: Haojian Zhuang <haojian.zhuang@gmail.com>
>
> And I also attached my 3 patches for 88pm860x since the old self-defined
> IORESOURCE_IO should be changed to register offset (IORESOURCE_REG).
> Otherwise, it still fails in my platform.
>
> Regards
> Haojian

Hi Samuel,

Is it OK to merge Mark's patch and my patch into your MFD tree for v3.7?

You can also find those patches in git://github.com/hzhuang1/linux.git
mfd_pmic branch

Best Regards
Haojian
