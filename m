Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757364Ab0HQN7R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 09:59:17 -0400
Received: from 68.mail-out.ovh.net ([91.121.185.69]:40706 "HELO
	68.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757291Ab0HQN7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 09:59:15 -0400
Message-ID: <4C6A95AF.3000200@example.com>
Date: Tue, 17 Aug 2010 15:59:11 +0200
From: Piotr Hosowicz <piotr@hosowicz.com>
Reply-To: piotr@hosowicz.com
Organization: hosowicz.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100805 Icedove/3.0.6
MIME-Version: 1.0
To: piotr@hosowicz.com
CC: Arnd Bergmann <arnd@arndb.de>, Sam Ravnborg <sam@ravnborg.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: ioctl definition - has it changed recently?
References: <4C67023D.6050603@example.com> <4C68EFE8.20202@example.com> <4C6A8A73.1070003@example.com> <201008171518.14032.arnd@arndb.de> <4C6A93E4.8000500@example.com>
In-Reply-To: <4C6A93E4.8000500@example.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 10786402583454183794
X-Ovh-Remote: 83.24.75.141 (dmt141.neoplus.adsl.tpnet.pl)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17.08.2010 15:51, Piotr Hosowicz wrote:
> On 17.08.2010 15:18, Arnd Bergmann wrote:
>> On Tuesday 17 August 2010, Piotr Hosowicz wrote:
>>>>> Just take a look at all the other patches that went into the
>>>>> kernel to do this for other drivers.
>>>
>>> I do not know how to find them. :-(
>>
>> git log -p -S"unlocked_ioctl"
>
> Thanks a lot.
>
>>>> It seems different. How to change it? Now it works, I built it without
>>>> your remarks, exactly how I described on my blog:
>>>>
>>>> http://phosowicz.jogger.pl/2010/08/15/nvidia-graphics-in-fresh-kernels/
>>>
>>> Ok, as I wrote the prototypes differ. What should I do with the inode
>>> parameter?
>>
>> It's normally not needed.
>
> It seems so because the implementation nowwhere refers to the inode
> parameter. But I guess it won't be OK to just remove this parameter from
> the declaraion and the implemetation because some other NVidia code may
> refer to this parameter, pass it and so on. Potentially scrambling
> (spoiling) the parameter stack.

This is as I said, I just commented inode parameter and it wont build:

/root/nvidia/NVIDIA-Linux-x86_64-256.44/kernel/nv.c: At top level: 
 
 

/root/nvidia/NVIDIA-Linux-x86_64-256.44/kernel/nv.c:426: warning: 
initialization from incompatible pointer type 
 

/root/nvidia/NVIDIA-Linux-x86_64-256.44/kernel/nv.c: In function 
‘nv_kern_unlocked_ioctl’: 
 

/root/nvidia/NVIDIA-Linux-x86_64-256.44/kernel/nv.c:3062: warning: 
passing argument 1 of ‘nv_kern_ioctl’ from incompatible pointer type 
 

/root/nvidia/NVIDIA-Linux-x86_64-256.44/kernel/nv.c:2876: note: expected 
‘struct file *’ but argument is of type ‘struct inode *’ 
 

/root/nvidia/NVIDIA-Linux-x86_64-256.44/kernel/nv.c:3062: warning: 
passing argument 2 of ‘nv_kern_ioctl’ makes integer from pointer without 
a cast 

/root/nvidia/NVIDIA-Linux-x86_64-256.44/kernel/nv.c:2876: note: expected 
‘unsigned int’ but argument is of type ‘struct file *’ 
 

/root/nvidia/NVIDIA-Linux-x86_64-256.44/kernel/nv.c:3062: error: too 
many arguments to function ‘nv_kern_ioctl’ 
 

/root/nvidia/NVIDIA-Linux-x86_64-256.44/kernel/nv.c: In function 
‘nv_kern_compat_ioctl’: 
 

/root/nvidia/NVIDIA-Linux-x86_64-256.44/kernel/nv.c:3071: warning: 
passing argument 1 of ‘nv_kern_ioctl’ from incompatible pointer type 
 

/root/nvidia/NVIDIA-Linux-x86_64-256.44/kernel/nv.c:2876: note: expected 
‘struct file *’ but argument is of type ‘struct inode *’ 
 

/root/nvidia/NVIDIA-Linux-x86_64-256.44/kernel/nv.c:3071: warning: 
passing argument 2 of ‘nv_kern_ioctl’ makes integer from pointer without 
a cast 

/root/nvidia/NVIDIA-Linux-x86_64-256.44/kernel/nv.c:2876: note: expected 
‘unsigned int’ but argument is of type ‘struct file *’ 
 

/root/nvidia/NVIDIA-Linux-x86_64-256.44/kernel/nv.c:3071: error: too 
many arguments to function ‘nv_kern_ioctl’

Regards,

Piotr Hosowicz

-- 
Zatrzymuje się samochód na sejmowym parkingu. Podchodzi do niego 
ochroniarz i mówi:
- Pan tu parkuje?! Tu Sejm ... Ministrowie, politycy, posłowiei ...
- Dzięki, włączę alarm.
NP:  -
NB: 2.6.36-rc1
