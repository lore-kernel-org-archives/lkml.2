Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143Ab2DWSAT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 14:00:19 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:52156 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488Ab2DWSAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 14:00:17 -0400
Message-ID: <4F9598AD.2030308@wwwdotorg.org>
Date: Mon, 23 Apr 2012 12:00:13 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Hiroshi DOYU <hdoyu@nvidia.com>, linux-tegra@vger.kernel.org,
        Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] ARM: tegra: Add AHB driver
References: <1335181043-15348-1-git-send-email-hdoyu@nvidia.com> <201204231233.09423.arnd@arndb.de>
In-Reply-To: <201204231233.09423.arnd@arndb.de>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2012 06:33 AM, Arnd Bergmann wrote:
> On Monday 23 April 2012, Hiroshi DOYU wrote:
>> The AHB Bus conforms to the AMBA Specification (Rev 2.0) Advanced
>> High-performance Bus (AHB) architecture.
...
>> @@ -122,6 +123,7 @@ void __init tegra20_init_early(void)
>>  	tegra_init_cache(0x331, 0x441);
>>  	tegra_pmc_init();
>>  	tegra_powergate_init();
>> +	tegra_ahb_gizmo_init();
>>  }
>>  #endif
>>  #ifdef CONFIG_ARCH_TEGRA_3x_SOC
>> @@ -132,5 +134,6 @@ void __init tegra30_init_early(void)
>>  	tegra_init_cache(0x441, 0x551);
>>  	tegra_pmc_init();
>>  	tegra_powergate_init();
>> +	tegra_ahb_gizmo_init();
>>  }
>>  #endif
> 
> Does it really have to be "early", rather than an initcall? Why?

I don't know whether it has to be early, but if this driver isn't going
to be instantiated from device tree, I'd prefer it to be initialized by
an explicit function call from the boards or common code rather than an
initcall. It seems a lot easier to keep track of all the initialization
by doing it explicitly. That said, it's quite possible this API couuld
be called from say init_machine instead of init_early though.
