Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757386Ab0EJWIe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 18:08:34 -0400
Received: from crca.org.au ([74.207.252.120]:46359 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756239Ab0EJWIc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:08:32 -0400
X-Bogosity: Ham, spamicity=0.000002
Message-ID: <4BE883DB.1040504@tuxonice.net>
Date: Tue, 11 May 2010 08:08:27 +1000
From: Nigel Cunningham <nigel@tuxonice.net>
Reply-To: nigel@tuxonice.net
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Andy Isaacson <adi@hexapodia.org>
CC: Steven Liu <lingjiujianke@gmail.com>,
       Linus WALLEIJ <linus.walleij@stericsson.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Check kmalloc return value before use the buffer
References: <v2ubd0d95d71005061941j4f9272d1he7dc9bcf5daa6457@mail.gmail.com> <CEE6BB42CAD6E947908279175AF8470A025A68CE5C@EXDCVYMBSTM006.EQ1STM.local> <z2mbd0d95d71005070017w7aa97001m2b81be6dbc1021b9@mail.gmail.com> <4BE3DF5A.9070601@tuxonice.net> <v2gbd0d95d71005070247j1f615a65mcbd52b5b6474206e@mail.gmail.com> <CEE6BB42CAD6E947908279175AF8470A025A68D366@EXDCVYMBSTM006.EQ1STM.local> <4BE4BDED.5050406@tuxonice.net> <v2ubd0d95d71005061941j4f9272d1he7dc9bcf5daa6457@mail.gmail.com> <CEE6BB42CAD6E947908279175AF8470A025A68CE5C@EXDCVYMBSTM006.EQ1STM.local> <z2mbd0d95d71005070017w7aa97001m2b81be6dbc1021b9@mail.gmail.com> <20100510214946.GA4361@hexapodia.org>
In-Reply-To: <20100510214946.GA4361@hexapodia.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On 11/05/10 07:49, Andy Isaacson wrote:
> On Fri, May 07, 2010 at 03:17:39PM +0800, Steven Liu wrote:
>>   	bigrxbuf_virtual = kmalloc(DMA_TEST_SIZE, GFP_KERNEL);
>> +	if (bigrxbuf_virtual == NULL) {
>> +		status = -ENOMEM;
>> +		kfree(bigtxbuf_virtual);
>> +		goto out;
>> +	}
>
> On Sat, May 08, 2010 at 11:27:09AM +1000, Nigel Cunningham wrote:
>>> Acked-by: Linus Walleij<linus.walleij@stericsson.com>
>>
>> Acked-by: Nigel Cunningham<nigel@tuxonice.net>
>
> NACK.  Don't duplicate kfree(), instead do something like

Yeah... that is a better way of doing it.

Regards,

Nigel
