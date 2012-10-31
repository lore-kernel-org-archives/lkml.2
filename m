Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756723Ab2JaSgg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 14:36:36 -0400
Received: from smtp-out-183.synserver.de ([212.40.185.183]:1270 "EHLO
	smtp-out-183.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966Ab2JaSge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 14:36:34 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 13481
Message-ID: <50916FA2.2000802@metafoo.de>
Date: Wed, 31 Oct 2012 19:36:18 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.10) Gecko/20121027 Icedove/10.0.10
MIME-Version: 1.0
To: Pantelis Antoniou <panto@antoniou-consulting.com>
CC: Jonathan Cameron <jic23@cam.ac.uk>, "Patil, Rachna" <rachna@ti.com>,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Koen Kooi <koen@dominion.thruhere.net>, Matt Porter <mporter@ti.com>,
        Russ Dill <Russ.Dill@ti.com>, linux-omap@vger.kernel.org
Subject: Re: [PATCH 1/3] ti_adc: Update with IIO map interface
References: <1351783496-11557-1-git-send-email-panto@antoniou-consulting.com> <50916563.8080704@metafoo.de> <F29A4A48-CDFA-4058-BED1-C09242B23326@antoniou-consulting.com> <509168EF.9040000@metafoo.de> <C105B6BF-8407-4484-826A-A979E16B6B44@antoniou-consulting.com>
In-Reply-To: <C105B6BF-8407-4484-826A-A979E16B6B44@antoniou-consulting.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31/2012 07:12 PM, Pantelis Antoniou wrote:
> 
> On Oct 31, 2012, at 8:07 PM, Lars-Peter Clausen wrote:
> 
>> On 10/31/2012 06:55 PM, Pantelis Antoniou wrote:
>>> [...]
>>>>> 	}
>>>>>
>>>>> 	indio_dev->channels = chan_array;
>>>>> +	indio_dev->num_channels = channels;
>>>>> +
>>>>> +	size = (channels + 1) * sizeof(struct iio_map);
>>>>> +	adc_dev->map = kzalloc(size, GFP_KERNEL);
>>>>> +	if (adc_dev->map == NULL) {
>>>>> +		kfree(chan_array);
>>>>> +		return -ENOMEM;
>>>>> +	}
>>>>> +
>>>>> +	for (i = 0; i < indio_dev->num_channels; i++) {
>>>>> +		adc_dev->map[i].adc_channel_label = chan_array[i].datasheet_name;
>>>>> +		adc_dev->map[i].consumer_dev_name = "any";
>>>>> +		adc_dev->map[i].consumer_channel = chan_array[i].datasheet_name;
>>>>> +	}
>>>>> +	adc_dev->map[i].adc_channel_label = NULL;
>>>>> +	adc_dev->map[i].consumer_dev_name = NULL;
>>>>> +	adc_dev->map[i].consumer_channel = NULL;
>>>>
>>>> The map should be passed in via platform data or similar. All the fields of
>>>> the map depend on the specific user, so you can't use a generic map. In fact
>>>> if we were able to use a generic map, we wouldn't need a map at all.
>>>
>>> There's no platform data in the board I'm using. It's board-generic using
>>> device tree only.
>>
>> That's the 'or similar' ;) Unfortunately we do not have a device tree
>> binding for IIO yet. But I think we should aim at a interface similar like
>> we have in other subsystems like the clk, regulator or dma framework.
>>
>> - Lars
> 
> So in the meantime no-one can use IIO ADC in any OF only platform.

Yes, nobody can use it until somebody implements it. So far nobody needed
it, so that's why it hasn't been implemented yet. The whole in kernel
consumer API for IIO is still very young and only a very few drivers support
it yet.

> 
> In the meantime, this is pretty reasonable IMO. This is only for a specific 
> board with known channel mappings.

Unfortunately it is not. It is adding a device specific hack to a generic
driver and it is also completely misusing the API.

> 
> I'm not out to fix IIO, I'm out to fix a single board.
> 

It's not about fixing IIO, it's about extending IIO to be able to serve your
needs. See, the issue is if everybody would work around the lack of DT
bindings we'll never have DT bindings for IIO, so the right thing to do is
to implement them instead of working around the lack of.

- Lars
