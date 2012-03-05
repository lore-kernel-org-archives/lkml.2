Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932255Ab2CENaX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 08:30:23 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:53231 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932194Ab2CENaW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 08:30:22 -0500
Message-ID: <4F54BFD9.8000802@ti.com>
Date: Mon, 5 Mar 2012 14:30:01 +0100
From: "Cousson, Benoit" <b-cousson@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: Andrew Morton <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH] devicetree: Add empty of_platform_populate() for !CONFIG_OF_ADDRESS
 (sparc)
References: <1330121218-10442-1-git-send-email-grant.likely@secretlab.ca> <4F513990.1030401@ti.com> <20120302170715.9f0a67ef.akpm@linux-foundation.org> <20120303040930.1E9283E190C@localhost>
In-Reply-To: <20120303040930.1E9283E190C@localhost>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

On 3/3/2012 5:09 AM, Grant Likely wrote:
> On Fri, 2 Mar 2012 17:07:15 -0800, Andrew Morton<akpm@linux-foundation.org>  wrote:
>> On Fri, 2 Mar 2012 22:20:16 +0100
>> "Cousson, Benoit"<b-cousson@ti.com>  wrote:
>>
>>> Hi Grant,
>>>
>>> In fact this patch is not working for build without CONFIG_OF like x86.
>>>
>>> On 2/24/2012 11:06 PM, Grant Likely wrote:
>>>> --- a/include/linux/of_platform.h
>>>> +++ b/include/linux/of_platform.h
>>>> @@ -81,7 +81,7 @@ extern struct platform_device *of_device_alloc(struct device_node *np,
>>>>    					 struct device *parent);
>>>>    extern struct platform_device *of_find_device_by_node(struct device_node *np);
>>>>
>>>> -#if !defined(CONFIG_SPARC) /* SPARC has its own device registration method */
>>>> +#ifdef CONFIG_OF_ADDRESS /* device reg helpers depend on OF_ADDRESS */
>>>>    /* Platform devices and busses creation */
>>>>    extern struct platform_device *of_platform_device_create(struct device_node *np,
>>>>    						   const char *bus_id,
>>>> @@ -94,7 +94,15 @@ extern int of_platform_populate(struct device_node *root,
>>>>    				const struct of_device_id *matches,
>>>>    				const struct of_dev_auxdata *lookup,
>>>>    				struct device *parent);
>>>> -#endif /* !CONFIG_SPARC */
>>>> +#else
>>>> +static inline int of_platform_populate(struct device_node *root,
>>>> +					const struct of_device_id *matches,
>>>> +					const struct of_dev_auxdata *lookup,
>>>> +					struct device *parent)
>>>> +{
>>>> +	return -ENODEV;
>>>> +}
>>>> +#endif /* !CONFIG_OF_ADDRESS */
>>>>
>>>>    #endif /* CONFIG_OF_DEVICE */
>>>
>>> Because if CONFIG_OF_DEVICE is not defined, then the stub for
>>> of_platform_populate will not be defined either. It should exist for any
>>> config without CONFIG_OF.
>>>
>>> Building twl4030 for x86 is actually broken.
>>>
>>
>> All twl is broken.  i386 allmodconfig with this monring's linux-next:
>>
>> drivers/mfd/twl-core.c: In function 'twl_probe':
>> drivers/mfd/twl-core.c:1357: error: implicit declaration of function 'of_platform_populate'
>>
>
> This patch seems to solve it finally against irqdomain/next.  Benoit, with
> your ack I'll push it out.

I've just built it on x86 and tested it on OMAP4 board successfully.

Acked-by: Benoit Cousson <b-cousson@ti.com>

Thanks,
Benoit
