Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932671Ab1CRVkR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 17:40:17 -0400
Received: from mail.kapsi.fi ([217.30.184.167]:39334 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932612Ab1CRVkN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 17:40:13 -0400
Message-ID: <4D83D137.6000307@iki.fi>
Date: Fri, 18 Mar 2011 23:40:07 +0200
From: Antti Palosaari <crope@iki.fi>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Florian Mickler <florian@mickler.org>
CC: mchehab@infradead.org, oliver@neukum.org, jwjstone@fastmail.fm,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 09/16] [media] au6610: get rid of on-stack dma buffer
References: <20110315093632.5fc9fb77@schatten.dmk.lab>	<1300178655-24832-1-git-send-email-florian@mickler.org>	<1300178655-24832-9-git-send-email-florian@mickler.org>	<4D8389B2.60507@iki.fi> <20110318222713.4c51f1ed@schatten.dmk.lab>
In-Reply-To: <20110318222713.4c51f1ed@schatten.dmk.lab>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 82.128.184.4
X-SA-Exim-Mail-From: crope@iki.fi
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/18/2011 11:27 PM, Florian Mickler wrote:
> On Fri, 18 Mar 2011 18:34:58 +0200
> Antti Palosaari<crope@iki.fi>  wrote:
>
>> On 03/15/2011 10:43 AM, Florian Mickler wrote:
>>> usb_control_msg initiates (and waits for completion of) a dma transfer using
>>> the supplied buffer. That buffer thus has to be seperately allocated on
>>> the heap.
>>>
>>> In lib/dma_debug.c the function check_for_stack even warns about it:
>>> 	WARNING: at lib/dma-debug.c:866 check_for_stack
>>>
>>> Note: This change is tested to compile only, as I don't have the hardware.
>>>
>>> Signed-off-by: Florian Mickler<florian@mickler.org>
>>
>>
>> This patch did not found from patchwork! Probably skipped due to broken
>> Cc at my contact. Please resend.
>>
>> Anyhow, I tested and reviewed it.
>>
>> Acked-by: Antti Palosaari<crope@iki.fi>
>> Reviewed-by: Antti Palosaari<crope@iki.fi>
>> Tested-by: Antti Palosaari<crope@iki.fi>
>>
>> [1] https://patchwork.kernel.org/project/linux-media/list/
>>
>> Antti
>>
>
> Yes, there was some broken adressing on my side. Sorry.
>
> Thanks for review&&  test!  I will resend (hopefully this weekend) the
> series when I reviewed some of the other patches if it is
> feasible/better to use prealocated memory as suggested by Mauro.
>
> How often does au6610_usb_msg get called in normal operation? Should it
> use preallocated memory?

It is called by demodulator and tuner drivers via I2C. One call per one 
register access. Tuner driver is qt1010 and demod driver is zl10353. 
When you perform tune to channel and device is in sleep there is maybe 
100 or more calls. After channel is tuned as OK, application starts 
calling only some signalling statistics from demod, it is usually only 
few calls per sec.

On my experience I cannot say if it is wise to preallocate or not. 
Anyhow, this same apply for all DVB USB drivers.

Antti
-- 
http://palosaari.fi/
