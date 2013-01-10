Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752434Ab3AJJyd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 04:54:33 -0500
Received: from smtp-out-052.synserver.de ([212.40.185.52]:1688 "EHLO
	smtp-out-052.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827Ab3AJJyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 04:54:31 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 9922
Message-ID: <50EE8FFD.2000000@metafoo.de>
Date: Thu, 10 Jan 2013 10:55:09 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.11) Gecko/20121122 Icedove/10.0.11
MIME-Version: 1.0
To: Julia Lawall <julia.lawall@lip6.fr>
CC: Grant Likely <grant.likely@secretlab.ca>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Jonathan Cameron <jic23@cam.ac.uk>, linux-iio@vger.kernel.org
Subject: Re: [PATCH 1/3] spi: Add helper functions for setting up transfers
References: <1357752671-30222-1-git-send-email-lars@metafoo.de> <alpine.DEB.2.02.1301100951060.2063@localhost6.localdomain6>
In-Reply-To: <alpine.DEB.2.02.1301100951060.2063@localhost6.localdomain6>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/2013 09:53 AM, Julia Lawall wrote:
>> +@r1@
>> +identifier fn;
>> +identifier xfers;
>> +@@
>> +fn(...)
>> +{
>> +	...
>> +(
>> +	struct spi_transfer xfers[...];
>> +|
>> +	struct spi_transfer xfers[];
>> +)
>> +	...
>> +}
> 
> Can it happen that there would be more than one spi_transfer or spi_message
> variable per function?  This semantic patch will only treat the case where
> there is only one, because the ... before an after the variable declaration
> won't match another declaration of the same form.
> 
> julia

I guess it could happen, but I would consider it to be very rare. There are
a few examples of multiple transfers in the kernel. But most of them look like

struct spi_message msg;
struct spi_transfer xfer_foo;
struct spi_transfer xfer_bar;

...
spi_message_add_tail(&xfer_foo, &msg);
spi_message_add_tail(&xfer_bar, &msg);

So the transformation can't be applied here anyway.

Do you have an idea how to change the rule to work with multiple
transfers/messages per function? If it would make the cocci file more
complex I wouldn't bother to take care of it, since it basically has no
practical use.

- Lars
