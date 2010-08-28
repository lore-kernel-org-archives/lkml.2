Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436Ab0H1Mwl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 08:52:41 -0400
Received: from smtp-04.mandic.com.br ([200.225.81.151]:51144 "EHLO
	smtp-04.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753192Ab0H1Mwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 08:52:40 -0400
Message-ID: <4C790693.1060908@cesarb.net>
Date: Sat, 28 Aug 2010 09:52:35 -0300
From: Cesar Eduardo Barros <cesarb@cesarb.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Thunderbird/3.1.2
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>, Matthew.Garrett@rpx.1wt.eu,
        mjg@redhat.com, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Illegal-Object: Syntax error in CC: address found on vger.kernel.org:
	CC:	Matthew Garrett
			^-extraneous tokens in address
Subject: Re: [PATCH] intel_ips: quieten "power or thermal limit exceeded"
 messages
References: <Pine.LNX.4.30.1008261631410.13713-100000@mail.perches.com>	 <4C770299.6000708@cesarb.net> <1282869660.1836.5.camel@Joe-Laptop>	 <4C77171E.6060008@cesarb.net> <1282894751.1836.41.camel@Joe-Laptop>	 <4C784650.2030200@cesarb.net> <1282962104.1946.179.camel@Joe-Laptop>	 <4C78E8EF.1000009@cesarb.net> <1282994116.1946.226.camel@Joe-Laptop>
In-Reply-To: <1282994116.1946.226.camel@Joe-Laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

You seem to have dropped the CC list by accident, adding it back.

Em 28-08-2010 08:15, Joe Perches escreveu:
> On Sat, 2010-08-28 at 07:46 -0300, Cesar Eduardo Barros wrote:
>> If I read the code with your previous patch correctly, show_turbo_limits
>> will never be called if poll_turbo_status is false but no interrupt
>> happens. And we know no interrupt happened (at least not with nonzero
>> register values), because the interrupt handler does two dev_info()
>> right at the beginning. So the limits could still be the ones initially
>> set at ips_probe().
>>
>> I will try to enable dev_dbg() later and see what it prints.
>
> or add:
>
> diff --git a/drivers/platform/x86/intel_ips.c b/drivers/platform/x86/intel_ips.c
> index 9024480..450ea44 100644
> --- a/drivers/platform/x86/intel_ips.c
> +++ b/drivers/platform/x86/intel_ips.c
> @@ -1600,6 +1600,7 @@ static int ips_probe(struct pci_dev *dev, const struct pci_device_id *id)
>   		ips->second_cpu = true;
>
>   	update_turbo_limits(ips);
> +	show_turbo_limits(ips, __func__);
>   	dev_dbg(&dev->dev, "max cpu power clamp: %dW\n",
>   		ips->mcp_power_limit / 10);
>   	dev_dbg(&dev->dev, "max core power clamp: %dW\n",

Here it is:

intel ips 0000:00:1f.6: Warning: CPU TDP doesn't match expected value 
(found 25, expected 35)
intel ips 0000:00:1f.6: PCI INT C -> GSI 18 (level, low) -> IRQ 18
intel ips 0000:00:1f.6: show_turbo_limits:ips_probe cte:1 gte:1 cpt:0 
mpl:65535 mtl:65535 mpl:65535
intel ips 0000:00:1f.6: IPS driver initialized, MCP temp limit 65535
intel ips 0000:00:1f.6: MCP power limit 65535 exceeded: cpu:8004 + 
mch:25353039
intel ips 0000:00:1f.6: CPU power limit 0 exceeded: 4841
intel ips 0000:00:1f.6: CPU power limit 0 exceeded: 5283
intel ips 0000:00:1f.6: CPU power limit 0 exceeded: 5586
intel ips 0000:00:1f.6: CPU power limit 0 exceeded: 6077
intel ips 0000:00:1f.6: MCP power limit 65535 exceeded: cpu:5871 + mch:64538
intel ips 0000:00:1f.6: CPU power limit 0 exceeded: 5466
intel ips 0000:00:1f.6: CPU power limit 0 exceeded: 8589
intel ips 0000:00:1f.6: CPU power limit 0 exceeded: 5744
intel ips 0000:00:1f.6: CPU power limit 0 exceeded: 4859
intel ips 0000:00:1f.6: MCP power limit 65535 exceeded: cpu:4834 + mch:62385
intel ips 0000:00:1f.6: CPU power limit 0 exceeded: 4874
intel ips 0000:00:1f.6: CPU power limit 0 exceeded: 5356
intel ips 0000:00:1f.6: CPU power limit 0 exceeded: 6557
intel ips 0000:00:1f.6: MCP power limit 65535 exceeded: cpu:7589 + mch:59343
intel ips 0000:00:1f.6: MCP power limit 65535 exceeded: cpu:5536 + mch:60020
intel ips 0000:00:1f.6: CPU power limit 0 exceeded: 6676
intel ips 0000:00:1f.6: CPU power limit 0 exceeded: 4401
intel ips 0000:00:1f.6: CPU power limit 0 exceeded: 5634
intel ips 0000:00:1f.6: CPU power limit 0 exceeded: 4038
intel ips 0000:00:1f.6: CPU power limit 0 exceeded: 4700
intel ips 0000:00:1f.6: CPU power limit 0 exceeded: 5086
intel ips 0000:00:1f.6: CPU power limit 0 exceeded: 4930
intel ips 0000:00:1f.6: CPU power limit 0 exceeded: 4697
intel ips 0000:00:1f.6: CPU power limit 0 exceeded: 5034
intel ips 0000:00:1f.6: CPU power limit 0 exceeded: 5381
intel ips 0000:00:1f.6: CPU power limit 0 exceeded: 4417
intel ips 0000:00:1f.6: CPU power limit 0 exceeded: 6839
intel ips 0000:00:1f.6: CPU power limit 0 exceeded: 4787

-- 
Cesar Eduardo Barros
cesarb@cesarb.net
cesar.barros@gmail.com
