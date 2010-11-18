Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759981Ab0KRRk7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 12:40:59 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:12835 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759969Ab0KRRk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 12:40:58 -0500
Message-ID: <4CE5652A.7060508@caviumnetworks.com>
Date: Thu, 18 Nov 2010 09:40:58 -0800
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Milton Miller <miltonm@bga.com>
CC: devicetree-discuss@lists.ozlabs.org, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org,
        "netdev@vger.kernel.org Cyril Chemparathy" <cyril@ti.com>,
        Arnaud Patard <arnaud.patard@rtp-net.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [1/2] of/phylib: Use device tree properties to initialize Marvell
 PHYs.
References: <1290038071-13296-2-git-send-email-ddaney@caviumnetworks.com> <marvell-phy@mdm.bga.com>
In-Reply-To: <marvell-phy@mdm.bga.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Nov 2010 17:41:48.0226 (UTC) FILETIME=[E0179220:01CB8747]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/17/2010 09:38 PM, Milton Miller wrote:
[...]
>> +static int marvell_of_reg_init(struct phy_device *phydev)
>> +{
>> +	const __be32 *paddr;
>> +	int len, i, saved_page, current_page, page_changed, ret;
>> +
>> +	if (!phydev->dev.of_node)
>> +		return 0;
>> +
>> +	paddr = of_get_property(phydev->dev.of_node, "marvell,reg-init",&len);
>> +	if (!paddr || len<  (2 * sizeof(u32)))
>> +		return 0;
>> +
>> +	saved_page = phy_read(phydev, 22);
>> +	if (saved_page<  0)
>> +		return saved_page;
>> +	page_changed = 0;
>> +	current_page = saved_page;
>> +
>> +	ret = 0;
>> +	len /= sizeof(u32);
>> +	for (i = 0; i<  len / 2; i += 2) {
>
> i<  len - 1 would execute all the register inits specified in the property.
>

Right, a bit of a snafu I think.  I will fix it.


>> +		u32 reg_spec =  be32_to_cpup(&paddr[i]);
>> +		u32 val_spec =  be32_to_cpup(&paddr[i + 1]);
>> +		u16 reg = reg_spec&  0xffff;
>> +		u16 reg_page = reg_spec>>  16;
>> +		u16 val_bits = val_spec&  0xffff;
>> +		u16 mask = val_spec>>  16;
>> +		int val;
>> +
>
> While the outcome is the same, this code also mixes sizeof(u32)
> with __be32 pointer math.

I will think about how to make it more consistent.

Thank you for looking at it,
David Daney
