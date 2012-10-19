Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945928Ab2JSP7K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 11:59:10 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:56918 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945913Ab2JSP7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 11:59:09 -0400
Message-ID: <508178C9.9090504@wwwdotorg.org>
Date: Fri, 19 Oct 2012 09:59:05 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/5] ARM: tegra: fix clock entry of slink controller
References: <1350557795-31487-1-git-send-email-ldewangan@nvidia.com> <1350557795-31487-4-git-send-email-ldewangan@nvidia.com> <5080862C.9030203@wwwdotorg.org> <508119CE.9070408@nvidia.com>
In-Reply-To: <508119CE.9070408@nvidia.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/2012 03:13 AM, Laxman Dewangan wrote:
> On Friday 19 October 2012 04:13 AM, Stephen Warren wrote:

>>> +    OF_DEV_AUXDATA("nvidia,tegra20-slink", TEGRA_SLINK1_BASE,
>>> "spi-tegra-slink.0", NULL),
>> Here, can't we just use the existing device names in the clock files...
>>
>> So we can completely drop the changes to these two files:
>
> I want to name the driver as spi-tegra-slink. When we add the sflash spi
> driver for tegra20, the driver name will be spi-tegra-sflash.
> Also current name is "spi_tegra" I do not want to name with "_". So it
> is require to convert as "-".

The driver name is whatever you put into the driver file. The AUXDATA
only affects the device name. There should be no conflict with the
"sflash" driver, since that clock is set up to expect driver name "spi"
which doesn't conflict with "spi_tegra.*".

So, there's really no point in churning the clock names any more,
especially since it's temporary. If you feel strongly about this, the
best thing to do is help push Tegra's support of DT clock bindings forward.
