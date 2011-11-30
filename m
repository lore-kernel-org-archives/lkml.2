Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757405Ab1K3InX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 03:43:23 -0500
Received: from ppsw-51.csi.cam.ac.uk ([131.111.8.151]:33231 "EHLO
	ppsw-51.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755983Ab1K3InU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 03:43:20 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Date: 30 Nov 2011 08:43:05 +0000
From: "J.I. Cameron" <jic23@cam.ac.uk>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Thomas Meyer <thomas@m3y3r.de>, gregkh@suse.de, linux-iio@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging:iio: Use kcalloc instead of kzalloc to allocate
 array
Message-ID: <Prayer.1.3.4.1111300843050.31356@hermes-2.csi.cam.ac.uk>
In-Reply-To: <20111130063523.GS3195@mwanda>
References: <1322600880.1534.334.camel@localhost.localdomain>
 <20111130063523.GS3195@mwanda>
X-Mailer: Prayer v1.3.4
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 30 2011, Dan Carpenter wrote:

>On Tue, Nov 29, 2011 at 10:08:00PM +0100, Thomas Meyer wrote:
>> The advantage of kcalloc is, that will prevent integer overflows which could
>> result from the multiplication of number of elements and size and it is also
>> a bit nicer to read.
>> 
>> The semantic patch that makes this change is available
>> in https://lkml.org/lkml/2011/11/25/107
>> 
Fine by me. Thanks.  As stated by others though you might want to change the description
to not imply it's mainly about overflows.
>> Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
Acked-by: Jonathan Cameron <jic23@kernel.org>
>> ---
>> 
>> diff -u -p a/drivers/staging/iio/accel/lis3l02dq_ring.c b/drivers/staging/iio/accel/lis3l02dq_ring.c
>> --- a/drivers/staging/iio/accel/lis3l02dq_ring.c 2011-11-13 11:07:47.933826988 +0100
>> +++ b/drivers/staging/iio/accel/lis3l02dq_ring.c 2011-11-28 20:00:44.704446880 +0100
>> @@ -93,8 +93,7 @@ static int lis3l02dq_read_all(struct iio
>>  	struct spi_message msg;
>>  	int ret, i, j = 0;
>>  
>> -	xfers = kzalloc((buffer->scan_count) * 2
>> -			* sizeof(*xfers), GFP_KERNEL);
>> +	xfers = kcalloc((buffer->scan_count) * 2, sizeof(*xfers), GFP_KERNEL);
>
>I've looked at these and none of them can actually overflow.
>
>But if they could then there would still be the potential for
>overflow here.  If buffer->scan_count were a negative number then
>the first for loop could cause memory corruption.
>
>Still it's a cleanup and the patch is fine.
