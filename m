Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935835Ab2JaSHo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 14:07:44 -0400
Received: from smtp-out-183.synserver.de ([212.40.185.183]:1222 "EHLO
	smtp-out-183.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933506Ab2JaSHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 14:07:43 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 19185
Message-ID: <509168EF.9040000@metafoo.de>
Date: Wed, 31 Oct 2012 19:07:43 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.10) Gecko/20121027 Icedove/10.0.10
MIME-Version: 1.0
To: Pantelis Antoniou <panto@antoniou-consulting.com>
CC: Jonathan Cameron <jic23@cam.ac.uk>, "Patil, Rachna" <rachna@ti.com>,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Koen Kooi <koen@dominion.thruhere.net>, Matt Porter <mporter@ti.com>,
        Russ Dill <Russ.Dill@ti.com>, linux-omap@vger.kernel.org
Subject: Re: [PATCH 1/3] ti_adc: Update with IIO map interface
References: <1351783496-11557-1-git-send-email-panto@antoniou-consulting.com> <50916563.8080704@metafoo.de> <F29A4A48-CDFA-4058-BED1-C09242B23326@antoniou-consulting.com>
In-Reply-To: <F29A4A48-CDFA-4058-BED1-C09242B23326@antoniou-consulting.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31/2012 06:55 PM, Pantelis Antoniou wrote:
> [...]
>>> 	}
>>>
>>> 	indio_dev->channels = chan_array;
>>> +	indio_dev->num_channels = channels;
>>> +
>>> +	size = (channels + 1) * sizeof(struct iio_map);
>>> +	adc_dev->map = kzalloc(size, GFP_KERNEL);
>>> +	if (adc_dev->map == NULL) {
>>> +		kfree(chan_array);
>>> +		return -ENOMEM;
>>> +	}
>>> +
>>> +	for (i = 0; i < indio_dev->num_channels; i++) {
>>> +		adc_dev->map[i].adc_channel_label = chan_array[i].datasheet_name;
>>> +		adc_dev->map[i].consumer_dev_name = "any";
>>> +		adc_dev->map[i].consumer_channel = chan_array[i].datasheet_name;
>>> +	}
>>> +	adc_dev->map[i].adc_channel_label = NULL;
>>> +	adc_dev->map[i].consumer_dev_name = NULL;
>>> +	adc_dev->map[i].consumer_channel = NULL;
>>
>> The map should be passed in via platform data or similar. All the fields of
>> the map depend on the specific user, so you can't use a generic map. In fact
>> if we were able to use a generic map, we wouldn't need a map at all.
> 
> There's no platform data in the board I'm using. It's board-generic using
> device tree only.

That's the 'or similar' ;) Unfortunately we do not have a device tree
binding for IIO yet. But I think we should aim at a interface similar like
we have in other subsystems like the clk, regulator or dma framework.

- Lars
