Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757404Ab2DXTt2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 15:49:28 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:51384 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757112Ab2DXTt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 15:49:26 -0400
Message-ID: <4F9703C2.50002@wwwdotorg.org>
Date: Tue, 24 Apr 2012 13:49:22 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: balbi@ti.com
CC: Hiroshi DOYU <hdoyu@nvidia.com>, linux-tegra@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>, Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH v2 1/3] ARM: tegra: Add AHB driver
References: <1335269116-9578-1-git-send-email-hdoyu@nvidia.com> <20120424121619.GF8444@arwen.pp.htv.fi>
In-Reply-To: <20120424121619.GF8444@arwen.pp.htv.fi>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/2012 06:16 AM, Felipe Balbi wrote:
> On Tue, Apr 24, 2012 at 03:05:14PM +0300, Hiroshi DOYU wrote:
>> The AHB Bus conforms to the AMBA Specification (Rev 2.0) Advanced
>> High-performance Bus (AHB) architecture.
...
>> +static int __init tegra_ahb_init(void)
>> +{
>> +	return platform_driver_register(&tegra_ahb_driver);
>> +}
>> +postcore_initcall(tegra_ahb_init);
>> +
>> +static void __exit tegra_ahb_exit(void)
>> +{
>> +	platform_driver_unregister(&tegra_ahb_driver);
>> +}
>> +module_exit(tegra_ahb_exit);
> 
> please use module_platform_driver();

That won't work for a postcore_initcall.
