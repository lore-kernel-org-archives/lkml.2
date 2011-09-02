Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933219Ab1IBJDR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 05:03:17 -0400
Received: from plane.gmane.org ([80.91.229.3]:54257 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933132Ab1IBJDM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 05:03:12 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4E609DB1.30507@cam.ac.uk>
Date: Fri, 02 Sep 2011 10:11:13 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110801 Thunderbird/5.0
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel.iio,gmane.linux.kernel
To: Dan Carpenter 
	<public-error27-Re5JQEeQqe8AvxtiuMwx3w@plane.gmane.org>
CC: "Maxin B. John" 
	<public-maxin.john-Re5JQEeQqe8AvxtiuMwx3w@plane.gmane.org>,
        Amit Kucheria 
	<public-amit.kucheria-LY4KaoCqKrnby3iVrkZq2A@plane.gmane.org>,
        public-devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@plane.gmane.org,
        Arnd Bergmann <public-arnd-r2nGTMty4D4@plane.gmane.org>,
        public-linux-iio-u79uwXL29TY76Z2rM5mHXA@plane.gmane.org,
        Greg Kroah-Hartman <public-gregkh-l3A5Bk7waGM@plane.gmane.org>,
        public-linux-kernel-u79uwXL29TY76Z2rM5mHXA@plane.gmane.org,
        Bryan Freed 
	<public-bfreed-F7+t8E8rja9g9hUCZPvPmw@plane.gmane.org>,
        Jonathan Cameron 
	<public-jic23-KWPb1pKIrIJaa/9Udqfwiw@plane.gmane.org>
Subject: Re: [PATCH] staging: iio: light: Fix compiler warning in tsl2563.c
References: <20110901212413.GA3371@maxin> <20110901215540.GA2430@shale.localdomain>
In-Reply-To: <20110901215540.GA2430@shale.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 09/01/11 22:55, Dan Carpenter wrote:
> On Fri, Sep 02, 2011 at 12:24:13AM +0300, Maxin B. John wrote:
>> --- a/drivers/staging/iio/light/tsl2563.c
>> +++ b/drivers/staging/iio/light/tsl2563.c
>> @@ -225,9 +225,9 @@ static int tsl2563_read_id(struct tsl2563_chip *chip, u8 *id)
>>  
>>  	ret = i2c_smbus_read_byte_data(client, TSL2563_CMD | TSL2563_REG_ID);
>>  	if (ret < 0)
>> -		return ret;
>> +		return -EIO;
> 
> Don't overwrite the error code.  For example, the lower layers can
> return -EAGAIN and that's more useful than just returning -EIO every
> time.
> 
> Your fix works, but it's not very clean.  Just add a "*id = ret;"
> line before the "return 0;" and that's it.  (It doesn't make sense
> to pass a pointer to "id" and not use it).
> 
> (In other words, don't make any changes to the tsl2563_probe()
> function)
> 
>>  
>> -	return 0;
>> +	return ret;
>>  }
>> 
Yikes - I wonder why my various compilers don't throw that up.
Ah well Dan's fix is indeed the right one and what was intended.

Thanks,

Jonathan

