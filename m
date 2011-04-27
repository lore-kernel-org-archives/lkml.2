Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759282Ab1D0N01 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 09:26:27 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:38281 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759247Ab1D0N0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 09:26:25 -0400
X-Auth-Info: Q+4mccLKPEuFo263ZbfNtXwmcjxgwaKJ7nseg3QgYmc=
Message-ID: <4DB81A12.1000006@grandegger.com>
Date: Wed, 27 Apr 2011 15:28:50 +0200
From: Wolfgang Grandegger <wg@grandegger.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: Subhasish Ghosh <subhasish@mistralsolutions.com>
CC: Marc Kleine-Budde <mkl@pengutronix.de>, sachi@mistralsolutions.com,
        davinci-linux-open-source@linux.davincidsp.com, Netdev@vger.kernel.org,
        nsekhar@ti.com, open list <linux-kernel@vger.kernel.org>,
        CAN NETWORK DRIVERS <socketcan-core@lists.berlios.de>,
        m-watkins@ti.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 1/1] can: add pruss CAN driver.
References: <1303474267-6344-1-git-send-email-subhasish@mistralsolutions.com>	<1303474267-6344-2-git-send-email-subhasish@mistralsolutions.com> <4DB1A3B7.7060300@pengutronix.de> <4DB5D452.9050500@grandegger.com> <46D523E49EFF489F9B088AE7B9CD7286@subhasishg>
In-Reply-To: <46D523E49EFF489F9B088AE7B9CD7286@subhasishg>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27/2011 03:08 PM, Subhasish Ghosh wrote:
>>
>> - Use just *one* value per sysfs file
> 
> SG - I felt adding entry for each mbx_id will clutter the sysfs.
>        Is it ok to do that.

No, see:

http://lxr.linux.no/#linux+v2.6.38/Documentation/filesystems/sysfs.txt#L56

>>>> +static u32 pruss_intc_init[19][3] = {
>>>> + {PRUSS_INTC_POLARITY0, PRU_INTC_REGMAP_MASK, 0xFFFFFFFF},
>>>> + {PRUSS_INTC_POLARITY1, PRU_INTC_REGMAP_MASK, 0xFFFFFFFF},
>>>> + {PRUSS_INTC_TYPE0, PRU_INTC_REGMAP_MASK, 0x1C000000},
>>>> + {PRUSS_INTC_TYPE1, PRU_INTC_REGMAP_MASK, 0},
>>>> + {PRUSS_INTC_GLBLEN, 0, 1},
>>>> + {PRUSS_INTC_HOSTMAP0, PRU_INTC_REGMAP_MASK, 0x03020100},
>>>> + {PRUSS_INTC_HOSTMAP1, PRU_INTC_REGMAP_MASK, 0x07060504},
>>>> + {PRUSS_INTC_HOSTMAP2, PRU_INTC_REGMAP_MASK, 0x0000908},
>>>> + {PRUSS_INTC_CHANMAP0, PRU_INTC_REGMAP_MASK, 0},
>>>> + {PRUSS_INTC_CHANMAP8, PRU_INTC_REGMAP_MASK, 0x00020200},
>>>> + {PRUSS_INTC_STATIDXCLR, 0, 32},
>>>> + {PRUSS_INTC_STATIDXCLR, 0, 19},
>>>> + {PRUSS_INTC_ENIDXSET, 0, 19},
>>>> + {PRUSS_INTC_STATIDXCLR, 0, 18},
>>>> + {PRUSS_INTC_ENIDXSET, 0, 18},
>>>> + {PRUSS_INTC_STATIDXCLR, 0, 34},
>>>> + {PRUSS_INTC_ENIDXSET, 0, 34},
>>>> + {PRUSS_INTC_ENIDXSET, 0, 32},
>>>> + {PRUSS_INTC_HOSTINTEN, 0, 5}
>>>
>>> please add ","
>>
>> Also a struct to describe each entry would improve readability.
>> Then you could also use ARRAY_SIZE.
> 
> SG _ I could not follow this, are you recommending that I create a
> structure with three variables and then create
>            an array for it.
> something like:
> 
> const static struct [] = {
>    {
>    unsigned int reg_base;
>    unsigned int reg_mask;
>    unsigned int reg_val;
>    },
> ...
> };

Yes:

  struct s_name {
	unsigned int base;
	unsigned int mask;
	unsigned int val;
  };

  const static struct s_name array[] = {
	...
  };

> 
>>>> + value = (PRUSS_CAN_GPIO_SETUP_DELAY *
>>>> + (priv->clk_freq_pru / 1000000) / 1000) /
>>>> + PRUSS_CAN_DELAY_LOOP_LENGTH;
>>
>> This calculation looks delicate. 64-bit math would be safer.
> 
> SG - This one works fine. I am dividing it twice to avoid the problem.

Yes, but what if the frequency increases with the next generation of the
hardware?

Wolfgang.
