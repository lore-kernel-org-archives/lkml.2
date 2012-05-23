Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757854Ab2EWJSS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 05:18:18 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:60708 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753457Ab2EWJSQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 05:18:16 -0400
Message-ID: <4FBCAB50.5000907@mev.co.uk>
Date: Wed, 23 May 2012 10:18:08 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120516 Thunderbird/12.0.1
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: H Hartley Sweeten <hartleys@visionengravers.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>,
        Ian Abbott <ian.abbott@mev.co.uk>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] staging: comedi: remove this_board macro in the s526
 driver
References: <201205221820.10770.hartleys@visionengravers.com> <20120523054849.GK4637@mwanda>
In-Reply-To: <20120523054849.GK4637@mwanda>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-05-23 06:48, Dan Carpenter wrote:
> On Tue, May 22, 2012 at 06:20:10PM -0700, H Hartley Sweeten wrote:
>> The 'thisboard' macro depends on having a local variable with
>> a magic name. The CodingStyle document suggests not doing this
>> to avoid confusion. Remove the macro and use the comedi_board()
>> inline helper to get the dev->board_ptr information.
>>
>> Signed-off-by: H Hartley Sweeten<hsweeten@visionengravers.com>
>> Cc: Ian Abbott<abbotti@mev.co.uk>
>> Cc: Mori Hess<fmhess@users.sourceforge.net>
>> Cc: Greg Kroah-Hartman<gregkh@linuxfoundation.org>
>>
>> ---
>> @@ -769,13 +765,7 @@ static int s526_attach(struct comedi_device *dev, struct comedi_devconfig *it)
>>   	}
>>   	***/
>>
>> -/*
>> - * Initialize dev->board_name.  Note that we can use the "thisboard"
>> - * macro now, since we just initialized it in the last line.
>> - */
>> -	dev->board_ptr =&s526_boards[0];
>
> Was this intended?  Most of the boards have auto probing so the
> ->board_ptr gets set automatically.  We already called
> comedi_board() so I wonder if the autoprobed board is the same as
> the&s526_boards[0];?  NULL pointer perhaps?  I don't know.

If .num_names in struct comedi_driver is non-zero, the core comedi 
module will set dev->board_ptr to something non-NULL and meaningful to 
the driver before it calls the driver's ->attach() method.  (This is 
done by the comedi_recognize() function.)  The driver can change 
dev->board_ptr to something else if it wants.  In this case, 
dev->board_ptr will already be set to &s526_boards[0] so there is no 
point setting it again.

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
