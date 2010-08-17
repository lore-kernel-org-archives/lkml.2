Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756774Ab0HQNvi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 09:51:38 -0400
Received: from 68.mail-out.ovh.net ([91.121.185.69]:36075 "HELO
	68.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751052Ab0HQNvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 09:51:37 -0400
Message-ID: <4C6A93E4.8000500@example.com>
Date: Tue, 17 Aug 2010 15:51:32 +0200
From: Piotr Hosowicz <piotr@hosowicz.com>
Reply-To: piotr@hosowicz.com
Organization: hosowicz.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100805 Icedove/3.0.6
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: ioctl definition - has it changed recently?
References: <4C67023D.6050603@example.com> <4C68EFE8.20202@example.com> <4C6A8A73.1070003@example.com> <201008171518.14032.arnd@arndb.de>
In-Reply-To: <201008171518.14032.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 10657205568582873348
X-Ovh-Remote: 83.24.75.141 (dmt141.neoplus.adsl.tpnet.pl)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17.08.2010 15:18, Arnd Bergmann wrote:
> On Tuesday 17 August 2010, Piotr Hosowicz wrote:
>>>> Just take a look at all the other patches that went into the
>>>> kernel to do this for other drivers.
>>
>> I do not know how to find them. :-(
>
> git log -p -S"unlocked_ioctl"

Thanks a lot.

>>> It seems different. How to change it? Now it works, I built it without
>>> your remarks, exactly how I described on my blog:
>>>
>>> http://phosowicz.jogger.pl/2010/08/15/nvidia-graphics-in-fresh-kernels/
>>
>> Ok, as I wrote the prototypes differ. What should I do with the inode
>> parameter?
>
> It's normally not needed.

It seems so because the implementation nowwhere refers to the inode 
parameter. But I guess it won't be OK to just remove this parameter from 
the declaraion and the implemetation because some other NVidia code may 
refer to this parameter, pass it and so on. Potentially scrambling 
(spoiling) the parameter stack.

Regards,

Piotr Hosowicz

> If you do need it, use file->f_path.dentry->d_inode.

Ok, as I said - it is nowhere used. So this is not a problem.

Regards,

Piotr Hosowicz

-- 
Na przyjêciu ch³opak pyta blondynkê:
- Czy mogê ciê prosiæ do walca?
- Zg³upia³e¶? To ju¿ nie mia³e¶ czym przyjechaæ?
NP:  -
NB: 2.6.36-rc1
