Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933007Ab2KNRK7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 12:10:59 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:52644 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754259Ab2KNRK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 12:10:58 -0500
Message-ID: <50A3D09E.4030609@gmail.com>
Date: Wed, 14 Nov 2012 11:10:54 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: Sasha Levin <sasha.levin@oracle.com>, rob.herring@calxeda.com,
        srinivas.kandagatla@st.com, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] of/mdio: fix build errors when CONFIG_OF isn't set
References: <1349886683-26351-1-git-send-email-sasha.levin@oracle.com> <20121114161135.71E153E0B1E@localhost>
In-Reply-To: <20121114161135.71E153E0B1E@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/2012 10:11 AM, Grant Likely wrote:
> On Wed, 10 Oct 2012 12:31:23 -0400, Sasha Levin <sasha.levin@oracle.com> wrote:
>> Commit f9dc9ac5 ("of/mdio: Add dummy functions in of_mdio.h.") has added
>> empty stubs into of_mdio.h which were not static, this causes build errors
>> when these symbols were defined across several objects.
>>
>> Fix it by marking those stubs as 'static inline'.
>>
>> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
> 
> Acked-by: Grant Likely <grant.likely@secretlab.ca>
> 
> Rob, can you please pick up into your merge branch for device tree?
> 

This is already fixed:

commit 2a5cf8016c745191605f312a7cd7bd22e9be94a5
Author: Mark Brown <broonie@opensource.wolfsonmicro.com>
Date:   Tue Oct 9 18:33:38 2012 +0000

    of/mdio: Staticise !CONFIG_OF stubs

    The !CONFIG_OF stubs aren't static so if multiple files include the
    header with this configuration then the linker will see multiple
    definitions of the stubs.

    Reported-by: Fengguang Wu <fengguang.wu@intel.com>
    Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
    Acked-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
    Acked-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit f9dc9ac51610a35629c8211b6b8c9b0c65cf0e1d
Author: Srinivas Kandagatla <srinivas.kandagatla@st.com>
Date:   Fri Aug 24 01:58:59 2012 +0000

    of/mdio: Add dummy functions in of_mdio.h.

    This patch adds dummy functions in of_mdio.h, so that driver need not
    ifdef there code with CONFIG_OF.

    Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

Rob

> Thanks,
> g.
> 
>> ---
>>  include/linux/of_mdio.h | 10 +++++-----
>>  1 file changed, 5 insertions(+), 5 deletions(-)
>>
>> diff --git a/include/linux/of_mdio.h b/include/linux/of_mdio.h
>> index 6ef49b8..7f17b9c 100644
>> --- a/include/linux/of_mdio.h
>> +++ b/include/linux/of_mdio.h
>> @@ -26,17 +26,17 @@ extern struct phy_device *of_phy_connect_fixed_link(struct net_device *dev,
>>  extern struct mii_bus *of_mdio_find_bus(struct device_node *mdio_np);
>>  
>>  #else /* CONFIG_OF */
>> -int of_mdiobus_register(struct mii_bus *mdio, struct device_node *np)
>> +static inline int of_mdiobus_register(struct mii_bus *mdio, struct device_node *np)
>>  {
>>  	return -ENOSYS;
>>  }
>>  
>> -struct phy_device *of_phy_find_device(struct device_node *phy_np)
>> +static inline struct phy_device *of_phy_find_device(struct device_node *phy_np)
>>  {
>>  	return NULL;
>>  }
>>  
>> -struct phy_device *of_phy_connect(struct net_device *dev,
>> +static inline struct phy_device *of_phy_connect(struct net_device *dev,
>>  					 struct device_node *phy_np,
>>  					 void (*hndlr)(struct net_device *),
>>  					 u32 flags, phy_interface_t iface)
>> @@ -44,14 +44,14 @@ struct phy_device *of_phy_connect(struct net_device *dev,
>>  	return NULL;
>>  }
>>  
>> -struct phy_device *of_phy_connect_fixed_link(struct net_device *dev,
>> +static inline struct phy_device *of_phy_connect_fixed_link(struct net_device *dev,
>>  					 void (*hndlr)(struct net_device *),
>>  					 phy_interface_t iface)
>>  {
>>  	return NULL;
>>  }
>>  
>> -struct mii_bus *of_mdio_find_bus(struct device_node *mdio_np)
>> +static inline struct mii_bus *of_mdio_find_bus(struct device_node *mdio_np)
>>  {
>>  	return NULL;
>>  }
>> -- 
>> 1.7.12
>>
> 

