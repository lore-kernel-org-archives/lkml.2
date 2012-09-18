Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756052Ab2IRFxZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 01:53:25 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:19712 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754613Ab2IRFxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 01:53:24 -0400
X-IronPort-AV: E=Sophos;i="4.80,441,1344204000"; 
   d="scan'208";a="173577538"
Date: Tue, 18 Sep 2012 07:53:21 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: Ryan Mallon <rmallon@gmail.com>
cc: Shubhrajyoti <shubhrajyoti@ti.com>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org, julia.lawall@lip6.fr
Subject: Re: [PATCH 3/7] rtc: Convert struct i2c_msg initialization to C99
 format
In-Reply-To: <50580AF1.4060109@gmail.com>
Message-ID: <alpine.DEB.2.02.1209180752080.2056@localhost6.localdomain6>
References: <1347890294-28467-1-git-send-email-shubhrajyoti@ti.com> <1347890294-28467-4-git-send-email-shubhrajyoti@ti.com> <5057D3A2.3040206@gmail.com> <50580937.7000802@ti.com> <50580AF1.4060109@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Sep 2012, Ryan Mallon wrote:

> On 18/09/12 15:40, Shubhrajyoti wrote:
>> On Tuesday 18 September 2012 07:21 AM, Ryan Mallon wrote:
>>> Actually, I wonder if it is useful to have something like:.
>> Read and write differ only in the flag also it will be a deviation from
>> what $SUBJECT
>> would warrant.  So could be a separate patch.
>
> Sure, but I think it would help make the code even more readable than
> just converting to C99 initialisers (especially since putting the C99
> initialiser all on one line is hard to read),

The one line thing is the fault of Coccinelle :)

julia

> and there is little sense
> in doing one clean up and then replacing it later with a different clean up.
>
> If you are worried about the duplication of code for a single flag
> difference you could always do:
>
>  #define I2C_OP(_addr, _buf, _len, _flags)	\
> 	...
>
>  #define I2C_WRITE(addr, buf, len) I2C_OP(addr, buf, len, 0)
>  #define I2C_READ(addr, buf, len)  I2C_OP(addr, buf, len, I2C_M_RD)
>
> ~Ryan
>
>>>
>>> 	#define I2C_WRITE(_addr, _buf, _len) {	\
>>> 		.addr	= _addr,		\
>>> 		.buf	= _buf,			\
>>> 		.len	= _len,			\
>>> 	}
>>>
>>> 	#define I2C_READ(_addr, _buf, _len) {	\
>>> 		.addr	= _addr,		\
>>> 		.buf	= _buf,			\
>>> 		.len	= _len,			\
>>> 		.flags	= I2C_M_RD,		\
>>> 	}
>>>
>>> and then write this as:
>>>
>>> 	struct i2c_msg msgs[2] = {
>>> 		I2C_WRITE(client->addr, reg_addr, sizeof(reg_addr)),
>>> 		I2C_READ(client->addr, buf, len),
>>> 	};
>>
>
>
