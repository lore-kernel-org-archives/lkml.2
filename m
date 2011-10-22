Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751Ab1JVFP3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 01:15:29 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:54152 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260Ab1JVFP2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 01:15:28 -0400
MIME-Version: 1.0
In-Reply-To: <4E60B63C.1030101@cam.ac.uk>
References: <20110902094107.GA2846@maxin>
	<4E60B63C.1030101@cam.ac.uk>
Date: Sat, 22 Oct 2011 08:15:27 +0300
Message-ID: <CAMhs6Yzw3-CARTULhy4s-Re4Q82Ek9gZGUQtABLLs0PSArHCuw@mail.gmail.com>
Subject: Re: [PATCH] staging: iio: light: Fix compiler warning in tsl2563.c
From: Maxin B John <maxin.john@gmail.com>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Dan Carpenter <error27@gmail.com>, Bryan Freed <bfreed@chromium.org>,
        linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-iio@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        devel@driverdev.osuosl.org,
        Amit Kucheria <amit.kucheria@verdurent.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Sep 2, 2011 at 1:55 PM, Jonathan Cameron <jic23@cam.ac.uk> wrote:
> On 09/02/11 10:41, Maxin B. John wrote:
>>> Don't overwrite the error code.  For example, the lower layers can
>>> return -EAGAIN and that's more useful than just returning -EIO every
>>> time.
>> Ahh.. Thanks a lot for explaining this.
>>
>>> Your fix works, but it's not very clean.  Just add a "*id = ret;"
>>> line before the "return 0;" and that's it.  (It doesn't make sense
>>> to pass a pointer to "id" and not use it).
>> Dan, yes, I agree with you. This fix is much much better than what I
>> had in my mind.
>>
>>> Yikes - I wonder why my various compilers don't throw that up.
>> I guess, in "iio-blue.git" tree, the 'id = 0' suppresses this warning.
> That'd do it. oops.
>
> Ideally keep the white space but doesn't really matter. Either send on
> to Greg directly or I'll add it to iio-blue and send on with the next fixes
> series - probably this afternoon.
>>
>> Signed-off-by: Maxin B. John <maxin.john@gmail.com>
> Acked-by: Jonathan Cameron <jic23@cam.ac.uk>
>

Sorry for the delay in replying to this mail. I am curious about the
status of this patch. I couldn't locate this patch at  iio-blue.git as
it is not present in kernel.org now
(http://git.kernel.org/?p=linux/kernel/git/jic23/iio-blue.git;a=summary)
Please ignore this mail if you have already added this patch to your tree.

>> ---
>> diff --git a/drivers/staging/iio/light/tsl2563.c b/drivers/staging/iio/light/tsl2563.c
>> index f25243b..55012ff 100644
>> --- a/drivers/staging/iio/light/tsl2563.c
>> +++ b/drivers/staging/iio/light/tsl2563.c
>> @@ -226,7 +226,7 @@ static int tsl2563_read_id(struct tsl2563_chip *chip, u8 *id)
>>       ret = i2c_smbus_read_byte_data(client, TSL2563_CMD | TSL2563_REG_ID);
>>       if (ret < 0)
>>               return ret;
>> -
>> +     *id = ret;
>>       return 0;
>>  }
>>
>>
>
>

Warm Regards,
Maxin B. John
