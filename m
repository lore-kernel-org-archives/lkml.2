Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756857Ab2HPJD3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 05:03:29 -0400
Received: from ppsw-43.csi.cam.ac.uk ([131.111.8.143]:58403 "EHLO
	ppsw-43.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756788Ab2HPJD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 05:03:27 -0400
X-Greylist: delayed 1829 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 Aug 2012 05:03:27 EDT
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <502CB031.3040808@jic23.retrosnub.co.uk>
Date: Thu, 16 Aug 2012 09:32:49 +0100
From: Jonathan Cameron <jic23@jic23.retrosnub.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>
CC: "Kim, Milo" <Milo.Kim@ti.com>, Jonathan Cameron <jic23@kernel.org>,
        "jic23@cam.ac.uk" <jic23@cam.ac.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>
Subject: Re: [PATCH 1/3] iio: add iio_read_channel_offset() consumer api
References: <A874F61F95741C4A9BA573A70FE3998F41EEFD6E@DQHE02.ent.ti.com> <502CACFF.3000105@metafoo.de>
In-Reply-To: <502CACFF.3000105@metafoo.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/08/12 09:19, Lars-Peter Clausen wrote:
> On 08/16/2012 09:39 AM, Kim, Milo wrote:
>> This allows the iio consumer to get the offset of the channel.
>> The value of offset can be used when calculating the result such
>> as 'result = raw * scale + offset'.
> result = (raw + offset) * scale
>
> Otherwise it looks good, except for:
>
>> +/**
>> + * iio_read_channel_offset() - read offset from a given channel
>> + * @channel:		The channel being queried.
>> + * @val:		Offset Value read back.
>> + *
>> + * Note offset can be used in the consumer when calculating the result
>> + * such as 'result = raw * scale + offset'.
>> + */
> The documentation should go in the c file.
I've often wondered about this myself.  Looking quickly about it does
appear that it is more popular to do it in c file...  Guess I've been wrong
for quite some time.  For now it's probably better to keep this docs
in the header and do the move all in one go given all the other docs
are here in this header.

I can see the arguments either way, but have not as yet seen anyone
stamp their foot on what is the 'one true way'.

>
>> +int iio_read_channel_offset(struct iio_channel *chan, int *val);
>>   #endif

