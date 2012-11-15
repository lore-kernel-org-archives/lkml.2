Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933335Ab2KODYj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 22:24:39 -0500
Received: from mms3.broadcom.com ([216.31.210.19]:2303 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933227Ab2KODYi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 22:24:38 -0500
X-Server-Uuid: B86B6450-0931-4310-942E-F00ED04CA7AF
Message-ID: <50A4606D.4020402@broadcom.com>
Date: Wed, 14 Nov 2012 19:24:29 -0800
From: "Nithin Nayak Sujir" <nsujir@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028
 Thunderbird/16.0.2
MIME-Version: 1.0
To: "Denys Fedoryshchenko" <denys@visp.net.lb>
cc: "Michael Chan" <mchan@broadcom.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Latest 3.6.6 are not compiling due tg3 network driver,
 hwmon_device_unregister
References: <8b566c4a9ee622737212dc17291ee238@visp.net.lb>
In-Reply-To: <8b566c4a9ee622737212dc17291ee238@visp.net.lb>
X-WSS-ID: 7CBA80F33P83085381-01-01
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This was fixed by

commit de0a41484c47d783dd4d442914815076aa2caac2
Author: Paul Gortmaker <paul.gortmaker@windriver.com>
Date:   Mon Oct 1 11:43:49 2012 -0400

     tg3: unconditionally select HWMON support when tg3 is enabled.


Nithin.


On 11/14/2012 07:03 PM, Denys Fedoryshchenko wrote:
> Hi
>
> During compiling i am getting that:
>
> drivers/built-in.o: In function `tg3_close':
> tg3.c:(.text+0x12902e): undefined reference to `hwmon_device_unregister'
> drivers/built-in.o: In function `tg3_hwmon_open':
> tg3.c:(.text+0x12ae09): undefined reference to `hwmon_device_register'
>
> Kernel config are at http://nuclearcat.com/config-tg3.txt  , but i noticed this error are 
> appearing at x86, x64 kernels, probably also other 3.6.x series kernels.
> Disabling TG3 driver helps, but i believe it is not a solution.
>
> ---
> Denys Fedoryshchenko, Network Engineer, Virtual ISP S.A.L.
> -- 
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


