Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755382Ab2IRFkP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 01:40:15 -0400
Received: from na3sys009aog132.obsmtp.com ([74.125.149.250]:37189 "EHLO
	na3sys009aog132.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754791Ab2IRFkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 01:40:13 -0400
Message-ID: <50580937.7000802@ti.com>
Date: Tue, 18 Sep 2012 11:10:07 +0530
From: Shubhrajyoti <shubhrajyoti@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Ryan Mallon <rmallon@gmail.com>
CC: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        julia.lawall@lip6.fr
Subject: Re: [PATCH 3/7] rtc: Convert struct i2c_msg initialization to C99
 format
References: <1347890294-28467-1-git-send-email-shubhrajyoti@ti.com> <1347890294-28467-4-git-send-email-shubhrajyoti@ti.com> <5057D3A2.3040206@gmail.com>
In-Reply-To: <5057D3A2.3040206@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 18 September 2012 07:21 AM, Ryan Mallon wrote:
> Actually, I wonder if it is useful to have something like:.
Read and write differ only in the flag also it will be a deviation from
what $SUBJECT
would warrant.  So could be a separate patch.
>
> 	#define I2C_WRITE(_addr, _buf, _len) {	\
> 		.addr	= _addr,		\
> 		.buf	= _buf,			\
> 		.len	= _len,			\
> 	}
>
> 	#define I2C_READ(_addr, _buf, _len) {	\
> 		.addr	= _addr,		\
> 		.buf	= _buf,			\
> 		.len	= _len,			\
> 		.flags	= I2C_M_RD,		\
> 	}
>
> and then write this as:
>
> 	struct i2c_msg msgs[2] = {
> 		I2C_WRITE(client->addr, reg_addr, sizeof(reg_addr)),
> 		I2C_READ(client->addr, buf, len),
> 	};

