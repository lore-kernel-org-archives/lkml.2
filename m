Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759602Ab0FJQ6i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 12:58:38 -0400
Received: from mail-yw0-f204.google.com ([209.85.211.204]:65014 "EHLO
	mail-yw0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752660Ab0FJQ6g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 12:58:36 -0400
MIME-Version: 1.0
In-Reply-To: <20100610095226.GI5333@pengutronix.de>
References: <20100610052102.16222.86662.stgit@angua> <20100610052232.16222.942.stgit@angua> 
	<20100610095226.GI5333@pengutronix.de>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 10 Jun 2010 10:58:15 -0600
X-Google-Sender-Auth: _SZeNgd3jVQ4uhb83JJUtZW6iro
Message-ID: <AANLkTikNDUUc7WODmtOYRf-vDzgWpWTI6kpneUEOPogz@mail.gmail.com>
Subject: Re: [PATCH 1/2] of/i2c: Generalize OF support
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, jeremy.kerr@canonical.com,
       devicetree-discuss@lists.ozlabs.org, ben-linux@fluff.org,
       linux-i2c@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 10, 2010 at 3:52 AM, Wolfram Sang <w.sang@pengutronix.de> wrote:
> Hi Grant,
>
> looks good to me in general. A few questions:
>
> On Wed, Jun 09, 2010 at 11:22:32PM -0600, Grant Likely wrote:
>> This patch cleans up the i2c OF support code to make it selectable by
>> all architectures and allow for automatic registration of i2c devices.
>>
>> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
>> ---
>>  drivers/i2c/busses/i2c-cpm.c     |    3 ++-
>>  drivers/i2c/busses/i2c-ibm_iic.c |    3 ++-
>>  drivers/i2c/busses/i2c-mpc.c     |    3 ++-
>>  drivers/of/Kconfig               |    2 +-
>>  drivers/of/of_i2c.c              |   44 ++++++++++++++++++++++++--------------
>>  include/linux/of_i2c.h           |   13 +++++++++--
>>  6 files changed, 45 insertions(+), 23 deletions(-)
>>

Hi Wolfram, thanks for the review.  Replies below.

>> @@ -49,10 +64,8 @@ void of_register_i2c_devices(struct i2c_adapter *adap,
>>
>>               result = i2c_new_device(adap, &info);
>>               if (result == NULL) {
>> -                     printk(KERN_ERR
>> -                            "of-i2c: Failed to load driver for %s\n",
>> -                            info.type);
>> -                     irq_dispose_mapping(info.irq);
>
> Why is the dispose removed?

Hmmm... That looks like a mistake.  I'll add it back.

>
>> +                     dev_err(&adap->dev, "of_i2c: Failure registering %s\n",
>> +                             node->full_name);
>>                       continue;
>>               }
>>
>> @@ -64,7 +77,7 @@ void of_register_i2c_devices(struct i2c_adapter *adap,
>>               of_node_get(node);
>>       }
>>  }
>> -EXPORT_SYMBOL(of_register_i2c_devices);
>> +EXPORT_SYMBOL(of_i2c_register_devices);
>>
>>  static int of_dev_node_match(struct device *dev, void *data)
>>  {
>> @@ -76,8 +89,7 @@ struct i2c_client *of_find_i2c_device_by_node(struct device_node *node)
>>  {
>>       struct device *dev;
>>
>> -     dev = bus_find_device(&i2c_bus_type, NULL, node,
>> -                                      of_dev_node_match);
>> +     dev = bus_find_device(&i2c_bus_type, NULL, node, of_dev_node_match);
>
> This change looks unrelated to me; where was this changed?

You're right; unrelated whitespace damage.  I'll remove.

g.
