Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189Ab1KAMKL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 08:10:11 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:40226 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753942Ab1KAMKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 08:10:10 -0400
Message-ID: <4EAFE184.5010409@metafoo.de>
Date: Tue, 01 Nov 2011 13:09:40 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20111004 Icedove/3.0.11
MIME-Version: 1.0
To: =?UTF-8?B?UGFsaSBSb2jDoXI=?= <pali.rohar@gmail.com>
CC: linux-kernel@vger.kernel.org, Anton Vorontsov <cbou@mail.ru>,
        syed rafiuddin <rafiuddin.sayed@gmail.com>,
        Rodolfo Giometti <giometti@linux.it>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 8/9] bq27x00: Add miscdevice for each battery with ioctl
 for reading registers
References: <1316531933-7159-1-git-send-email-pali.rohar@gmail.com> <1320108191-6647-1-git-send-email-pali.rohar@gmail.com> <1320108191-6647-8-git-send-email-pali.rohar@gmail.com>
In-Reply-To: <1320108191-6647-8-git-send-email-pali.rohar@gmail.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/2011 01:43 AM, Pali Rohár wrote:
> * When bq27x00_battery module is loaded it take control of bq27200 i2c battery chip and then it is not possible to use i2cget program from user space (returns -EBUSY)
> * This patch adds new miscdevice for each battery which has ioctl BQ27X00_READ_REG for reading battery registers from user space
> 
> * ioctl cmd:
>   #define BQ27X00_READ_REG _IO(MISC_MAJOR, 0)
> 
> * ioctl arg:
>   struct bq27x00_reg_parms {
>     int reg; /* battery register (in) */
>     int single; /* 1 - 8bit register, 0 - 16bit register (in) */
>     int ret; /* register status, negative indicate error (out) */
>   };
> 
> Signed-off-by: Pali Rohár <pali.rohar@gmail.com>

I'm not sure if this is such a good idea. Why do you need to read the registers
from userspace? Shouldn't all relevant information be available in a
standardized format through the power_supply userspace API? If you want to use
it for debugging it might be a better idea to provide a debugfs file.

- Lars
