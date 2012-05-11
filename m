Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759503Ab2EKNOK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 09:14:10 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:46846 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753400Ab2EKNOH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 09:14:07 -0400
Message-ID: <4FAD109A.9040607@mev.co.uk>
Date: Fri, 11 May 2012 14:14:02 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120414 Thunderbird/11.0.1
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: H Hartley Sweeten <hartleys@visionengravers.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>,
        Ian Abbott <ian.abbott@mev.co.uk>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] staging: comedi: register sysfs device attributes with
 driver core
References: <201205101805.28589.hartleys@visionengravers.com> <20120511061649.GW22134@mwanda>
In-Reply-To: <20120511061649.GW22134@mwanda>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-05-11 07:16, Dan Carpenter wrote:
> On Thu, May 10, 2012 at 06:05:28PM -0700, H Hartley Sweeten wrote:
>> -static const struct attribute_group comedi_sysfs_files = {
>> -	.attrs	= comedi_attrs,
>> +static struct device_attribute comedi_dev_attrs[] = {
>> +	__ATTR(max_read_buffer_kb, S_IRUGO | S_IWUSR,
>> +		show_max_read_buffer_kb, store_max_read_buffer_kb),
>> +	__ATTR(read_buffer_kb, S_IRUGO | S_IWUSR | S_IWGRP,
>> +		show_read_buffer_kb, store_read_buffer_kb),
>> +	__ATTR(max_write_buffer_kb, S_IRUGO | S_IWUSR,
>> +		show_max_write_buffer_kb, store_max_write_buffer_kb),
>> +	__ATTR(write_buffer_kb, S_IRUGO | S_IWUSR | S_IWGRP,
>> +		show_write_buffer_kb, store_write_buffer_kb),
>> +	__ATTR_NULL
>
> Some of these are group writable and some are only user writable so
> it's not consistent.  Probably just make them user writeable.
>
> I guess this was in the original code too, but it's just more
> obvious now that they're grouped together.

Is it possible to change (group) ownership of these attribute files 
using udev rules?  Ideally, users in the group that has group ownership 
on the /dev/comedi* files should be able to modify the read_buffer_kb 
and write_buffer_kb attribute files as well, but only super-users should 
be able to modify the max_read_buffer_kb and max_write_buffer_kb files.

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
