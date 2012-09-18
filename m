Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760Ab2IRUKT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 16:10:19 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:59948 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754526Ab2IRUKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 16:10:15 -0400
Message-ID: <5058D4DE.6060007@linux.vnet.ibm.com>
Date: Tue, 18 Sep 2012 13:09:02 -0700
From: Cody P Schafer <cody@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Venu Byravarasu <vbyravarasu@nvidia.com>
CC: Shubhrajyoti D <shubhrajyoti@ti.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "julia.lawall@lip6.fr" <julia.lawall@lip6.fr>,
        Shubhrajyoti Datta <omaplinuxkernel@gmail.com>
Subject: Re: [PATCHv2 6/6] media: Convert struct i2c_msg initialization to
 C99 format
References: <1347961843-9376-1-git-send-email-shubhrajyoti@ti.com> <1347961843-9376-7-git-send-email-shubhrajyoti@ti.com> <D958900912E20642BCBC71664EFECE3E6DDEFB947B@BGMAIL02.nvidia.com> <CAM=Q2cv8R8QUbV2UqNO+AbwgprAYxBtBjK=4rkHnqegGJWTdog@mail.gmail.com> <D958900912E20642BCBC71664EFECE3E6DDEFB9480@BGMAIL02.nvidia.com>
In-Reply-To: <D958900912E20642BCBC71664EFECE3E6DDEFB9480@BGMAIL02.nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12091820-2398-0000-0000-00000B1B0401
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000294; HX=3.00000196; KW=3.00000007;
 PH=3.00000001; SC=3.00000007; SDB=6.00175258; UDB=6.00039683; UTC=2012-09-18
 20:10:14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 18 Sep 2012 03:02:42 AM PDT, Venu Byravarasu wrote:
>> -----Original Message-----
>> From: Shubhrajyoti Datta [mailto:omaplinuxkernel@gmail.com]
>> Sent: Tuesday, September 18, 2012 3:30 PM
>> To: Venu Byravarasu
>> Cc: Shubhrajyoti D; linux-media@vger.kernel.org; linux-
>> kernel@vger.kernel.org; julia.lawall@lip6.fr
>> Subject: Re: [PATCHv2 6/6] media: Convert struct i2c_msg initialization to C99
>> format
>
>>>>        struct i2c_msg test[2] = {
>>>> -             { client->addr, 0,        3, write },
>>>> -             { client->addr, I2C_M_RD, 2, read  },
>>>> +             {
>>>> +                     .addr = client->addr,
>>>> +                     .flags = 0,
>>>
>>> Does flags not contain 0 by default?
>>>
>>
>> It does however I felt that 0 means write so letting it be explicit.
>>
>> In case a removal is preferred that's doable too however felt it is
>> more readable this way.
>
> Though it adds readability, it carries an overhead of one write operation too.
> So, better to remove it.

Partially initialized structs will have their unmentioned members 
initialized to zero.

So there is no "overhead of one write operation" by mentioning it 
explicitly.

