Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759623Ab2JaSn4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 14:43:56 -0400
Received: from li42-95.members.linode.com ([209.123.162.95]:48944 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753549Ab2JaSny convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 14:43:54 -0400
Subject: Re: [PATCH 1/3] ti_adc: Update with IIO map interface
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: Pantelis Antoniou <panto@antoniou-consulting.com>
In-Reply-To: <50916FA2.2000802@metafoo.de>
Date: Wed, 31 Oct 2012 20:43:49 +0200
Cc: Jonathan Cameron <jic23@cam.ac.uk>, "Patil, Rachna" <rachna@ti.com>,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Koen Kooi <koen@dominion.thruhere.net>, Matt Porter <mporter@ti.com>,
        Russ Dill <Russ.Dill@ti.com>, linux-omap@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <67596D26-26EC-483A-A83A-8A7F43BDE466@antoniou-consulting.com>
References: <1351783496-11557-1-git-send-email-panto@antoniou-consulting.com> <50916563.8080704@metafoo.de> <F29A4A48-CDFA-4058-BED1-C09242B23326@antoniou-consulting.com> <509168EF.9040000@metafoo.de> <C105B6BF-8407-4484-826A-A979E16B6B44@antoniou-consulting.com> <50916FA2.2000802@metafoo.de>
To: Lars-Peter Clausen <lars@metafoo.de>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 31, 2012, at 8:36 PM, Lars-Peter Clausen wrote:

> On 10/31/2012 07:12 PM, Pantelis Antoniou wrote:
>> 
>> On Oct 31, 2012, at 8:07 PM, Lars-Peter Clausen wrote:
>> 
>>> On 10/31/2012 06:55 PM, Pantelis Antoniou wrote:
>>>> [...]
>>>>>> 	}
>>>>>> 
>>>>>> 	indio_dev->channels = chan_array;
>>>>>> +	indio_dev->num_channels = channels;
>>>>>> +
>>>>>> +	size = (channels + 1) * sizeof(struct iio_map);
>>>>>> +	adc_dev->map = kzalloc(size, GFP_KERNEL);
>>>>>> +	if (adc_dev->map == NULL) {
>>>>>> +		kfree(chan_array);
>>>>>> +		return -ENOMEM;
>>>>>> +	}
>>>>>> +
>>>>>> +	for (i = 0; i < indio_dev->num_channels; i++) {
>>>>>> +		adc_dev->map[i].adc_channel_label = chan_array[i].datasheet_name;
>>>>>> +		adc_dev->map[i].consumer_dev_name = "any";
>>>>>> +		adc_dev->map[i].consumer_channel = chan_array[i].datasheet_name;
>>>>>> +	}
>>>>>> +	adc_dev->map[i].adc_channel_label = NULL;
>>>>>> +	adc_dev->map[i].consumer_dev_name = NULL;
>>>>>> +	adc_dev->map[i].consumer_channel = NULL;
>>>>> 
>>>>> The map should be passed in via platform data or similar. All the fields of
>>>>> the map depend on the specific user, so you can't use a generic map. In fact
>>>>> if we were able to use a generic map, we wouldn't need a map at all.
>>>> 
>>>> There's no platform data in the board I'm using. It's board-generic using
>>>> device tree only.
>>> 
>>> That's the 'or similar' ;) Unfortunately we do not have a device tree
>>> binding for IIO yet. But I think we should aim at a interface similar like
>>> we have in other subsystems like the clk, regulator or dma framework.
>>> 
>>> - Lars
>> 
>> So in the meantime no-one can use IIO ADC in any OF only platform.
> 
> Yes, nobody can use it until somebody implements it. So far nobody needed
> it, so that's why it hasn't been implemented yet. The whole in kernel
> consumer API for IIO is still very young and only a very few drivers support
> it yet.
> 
>> 
>> In the meantime, this is pretty reasonable IMO. This is only for a specific 
>> board with known channel mappings.
> 
> Unfortunately it is not. It is adding a device specific hack to a generic
> driver and it is also completely misusing the API.
> 
>> 
>> I'm not out to fix IIO, I'm out to fix a single board.
>> 
> 
> It's not about fixing IIO, it's about extending IIO to be able to serve your
> needs. See, the issue is if everybody would work around the lack of DT
> bindings we'll never have DT bindings for IIO, so the right thing to do is
> to implement them instead of working around the lack of.
> 
> - Lars

OK, OK,

I see the point. It's just that I'm under the gun for more pressing matters ATM.
Can at least get a small write-up about how the bindings should look like?

There's absolutely nothing, not even a hint of one out there in the intertubes,
on how the channel mapping should look like.

Regards

-- Pantelis




