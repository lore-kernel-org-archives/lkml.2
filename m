Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600Ab1KQGrj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 01:47:39 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:58191 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752238Ab1KQGri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 01:47:38 -0500
Message-ID: <4EC4AE0B.1040500@kernel.org>
Date: Thu, 17 Nov 2011 06:47:39 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111108 Thunderbird/8.0
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: Lars-Peter Clausen <lars@metafoo.de>, Greg Kroah-Hartman <gregkh@suse.de>,
        Jean Delvare <khali@linux-fr.org>,
        Michael Hennerich <Michael.Hennerich@analog.com>,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, spi-devel-general@lists.sourceforge.net
Subject: Re: [PATCH 2/5] I2C: Add helper macro for i2c_driver boilerplate
References: <1321434819-23678-1-git-send-email-lars@metafoo.de> <1321434819-23678-3-git-send-email-lars@metafoo.de> <CACxGe6toOFjOdP7-oZ4O2J=g2U+Y+aWOUzHDoCaX6goAs6zKsQ@mail.gmail.com>
In-Reply-To: <CACxGe6toOFjOdP7-oZ4O2J=g2U+Y+aWOUzHDoCaX6goAs6zKsQ@mail.gmail.com>
X-Enigmail-Version: 1.3.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/16/2011 05:12 PM, Grant Likely wrote:
> On Wed, Nov 16, 2011 at 2:13 AM, Lars-Peter Clausen <lars@metafoo.de> wrote:
>> This patch introduces the module_i2c_driver macro which is a convenience macro
>> for I2C driver modules similar to module_platform_driver. It is intended to be
>> used by drivers which init/exit section does nothing but register/unregister
>> the I2C driver. By using this macro it is possible to eliminate a few lines of
>> boilerplate code per I2C driver.
>>
>> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> 
> Acked-by: Grant Likely <grant.likely@secretlab.ca>
Acked-by: Jonathan Cameron <jic23@cam.ac.uk>
> 
>> ---
>>  include/linux/i2c.h |   13 +++++++++++++
>>  1 files changed, 13 insertions(+), 0 deletions(-)
>>
>> diff --git a/include/linux/i2c.h b/include/linux/i2c.h
>> index a81bf6d..7e92854 100644
>> --- a/include/linux/i2c.h
>> +++ b/include/linux/i2c.h
>> @@ -485,6 +485,19 @@ static inline int i2c_adapter_id(struct i2c_adapter *adap)
>>  {
>>        return adap->nr;
>>  }
>> +
>> +/**
>> + * module_i2c_driver() - Helper macro for registering a I2C driver
>> + * @__i2c_driver: i2c_driver struct
>> + *
>> + * Helper macro for I2C drivers which do not do anything special in module
>> + * init/exit. This eliminates a lot of boilerplate. Each module may only
>> + * use this macro once, and calling it replaces module_init() and module_exit()
>> + */
>> +#define module_i2c_driver(__i2c_driver) \
>> +       module_driver(__i2c_driver, i2c_add_driver, \
>> +                       i2c_del_driver)
>> +
>>  #endif /* I2C */
>>  #endif /* __KERNEL__ */
>>
>> --
>> 1.7.7.1
>>
>>
>>
> 
> 
> 

