Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623Ab2IRFri (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 01:47:38 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:62123 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754047Ab2IRFrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 01:47:37 -0400
Message-ID: <50580AF1.4060109@gmail.com>
Date: Tue, 18 Sep 2012 15:47:29 +1000
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Shubhrajyoti <shubhrajyoti@ti.com>
CC: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        julia.lawall@lip6.fr
Subject: Re: [PATCH 3/7] rtc: Convert struct i2c_msg initialization to C99
 format
References: <1347890294-28467-1-git-send-email-shubhrajyoti@ti.com> <1347890294-28467-4-git-send-email-shubhrajyoti@ti.com> <5057D3A2.3040206@gmail.com> <50580937.7000802@ti.com>
In-Reply-To: <50580937.7000802@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/09/12 15:40, Shubhrajyoti wrote:
> On Tuesday 18 September 2012 07:21 AM, Ryan Mallon wrote:
>> Actually, I wonder if it is useful to have something like:.
> Read and write differ only in the flag also it will be a deviation from
> what $SUBJECT
> would warrant.  So could be a separate patch.

Sure, but I think it would help make the code even more readable than
just converting to C99 initialisers (especially since putting the C99
initialiser all on one line is hard to read), and there is little sense
in doing one clean up and then replacing it later with a different clean up.

If you are worried about the duplication of code for a single flag
difference you could always do:

  #define I2C_OP(_addr, _buf, _len, _flags)	\
	...

  #define I2C_WRITE(addr, buf, len) I2C_OP(addr, buf, len, 0)
  #define I2C_READ(addr, buf, len)  I2C_OP(addr, buf, len, I2C_M_RD)

~Ryan

>>
>> 	#define I2C_WRITE(_addr, _buf, _len) {	\
>> 		.addr	= _addr,		\
>> 		.buf	= _buf,			\
>> 		.len	= _len,			\
>> 	}
>>
>> 	#define I2C_READ(_addr, _buf, _len) {	\
>> 		.addr	= _addr,		\
>> 		.buf	= _buf,			\
>> 		.len	= _len,			\
>> 		.flags	= I2C_M_RD,		\
>> 	}
>>
>> and then write this as:
>>
>> 	struct i2c_msg msgs[2] = {
>> 		I2C_WRITE(client->addr, reg_addr, sizeof(reg_addr)),
>> 		I2C_READ(client->addr, buf, len),
>> 	};
> 

