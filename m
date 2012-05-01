Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130Ab2EAIuO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 04:50:14 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:36971 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752492Ab2EAIuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 04:50:12 -0400
Message-ID: <4F9FA3DF.9060603@metafoo.de>
Date: Tue, 01 May 2012 10:50:39 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120207 Icedove/3.0.11
MIME-Version: 1.0
To: Jonathan Cameron <jic23@cam.ac.uk>
CC: joseph daniel <josephdanielwalter@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging/iio/meter: fix the coding style problem
References: <1335813977-8096-1-git-send-email-josephdanielwalter@gmail.com> <4F9EEFB2.8030201@metafoo.de> <4F9F9711.1010904@cam.ac.uk>
In-Reply-To: <4F9F9711.1010904@cam.ac.uk>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01/2012 09:56 AM, Jonathan Cameron wrote:
> On 4/30/2012 9:01 PM, Lars-Peter Clausen wrote:
>> On 04/30/2012 09:26 PM, joseph daniel wrote:
>>> Signed-off-by: joseph daniel<josephdanielwalter@gmail.com>
>>> ---
>>> Hi Lars,
>>>     Thanks for review. how about the below change?
>>>   drivers/staging/iio/meter/ade7854-i2c.c |    6 +++++-
>>>   1 file changed, 5 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/staging/iio/meter/ade7854-i2c.c
>>> b/drivers/staging/iio/meter/ade7854-i2c.c
>>> index 1e1faa0..52bdb05 100644
>>> --- a/drivers/staging/iio/meter/ade7854-i2c.c
>>> +++ b/drivers/staging/iio/meter/ade7854-i2c.c
>>> @@ -181,6 +181,7 @@ static int ade7854_i2c_read_reg_32(struct device
>>> *dev,
>>>   {
>>>       struct iio_dev *indio_dev = dev_get_drvdata(dev);
>>>       struct ade7854_state *st = iio_priv(indio_dev);
>>> +    uint32_t value;
>>>       int ret;
>>>
>>>       mutex_lock(&st->buf_lock);
>>> @@ -195,7 +196,10 @@ static int ade7854_i2c_read_reg_32(struct device
>>> *dev,
>>>       if (ret)
>>>           goto out;
>>>
>>> -    *val = (st->rx[0]<<  24) | (st->rx[1]<<  16) | (st->rx[2]<<  8)
>>> | st->rx[3];
>>> +    memcpy(&value, st->rx, sizeof(uint32_t));
>>> +
>> Uhm, yes, you are right st->rx is unaligned. The memcpy is not
>> necessary though
>> if you use get_unaligned_be32. Sorry for the pointer to the wrong
>> function.
> Or we could just force the alignment of st->rx? Might not be worth
> bothering.

Yes, but be32_to_cpu wants a be32 and there is another functions which only
does a 16 bit access on rx, so we'd need to cast and things get messy. Also for
tx we store first a 16bit value and then a 32bit value and while it is possible
to get this properly aligned this gets a bit messy too. I think we are fine
with {get,set}_unaligned for now.
