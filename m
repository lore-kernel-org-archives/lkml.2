Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932801Ab0HQOdd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 10:33:33 -0400
Received: from 70.mail-out.ovh.net ([91.121.185.63]:33987 "HELO
	70.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932688Ab0HQOd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 10:33:26 -0400
Message-ID: <4C6A9DB0.20409@example.com>
Date: Tue, 17 Aug 2010 16:33:20 +0200
From: Piotr Hosowicz <piotr@hosowicz.com>
Reply-To: piotr@hosowicz.com
Organization: hosowicz.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100805 Icedove/3.0.6
MIME-Version: 1.0
To: piotr@hosowicz.com
CC: Arnd Bergmann <arnd@arndb.de>, Sam Ravnborg <sam@ravnborg.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: ioctl definition - has it changed recently?
References: <4C67023D.6050603@example.com> <4C68EFE8.20202@example.com> <4C6A8A73.1070003@example.com> <201008171518.14032.arnd@arndb.de> <4C6A93E4.8000500@example.com> <4C6A95AF.3000200@example.com>
In-Reply-To: <4C6A95AF.3000200@example.com>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 11362863336742482290
X-Ovh-Remote: 83.24.77.29 (dmv29.neoplus.adsl.tpnet.pl)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17.08.2010 15:59, Piotr Hosowicz wrote:
> On 17.08.2010 15:51, Piotr Hosowicz wrote:
>> On 17.08.2010 15:18, Arnd Bergmann wrote:
>>> On Tuesday 17 August 2010, Piotr Hosowicz wrote:
>>>>>> Just take a look at all the other patches that went into the
>>>>>> kernel to do this for other drivers.
>>>>
>>>> I do not know how to find them. :-(
>>>
>>> git log -p -S"unlocked_ioctl"
>>
>> Thanks a lot.
>>
>>>>> It seems different. How to change it? Now it works, I built it without
>>>>> your remarks, exactly how I described on my blog:
>>>>>
>>>>> http://phosowicz.jogger.pl/2010/08/15/nvidia-graphics-in-fresh-kernels/
>>>>>
>>>>
>>>> Ok, as I wrote the prototypes differ. What should I do with the inode
>>>> parameter?
>>>
>>> It's normally not needed.
>>
>> It seems so because the implementation nowwhere refers to the inode
>> parameter. But I guess it won't be OK to just remove this parameter from
>> the declaraion and the implemetation because some other NVidia code may
>> refer to this parameter, pass it and so on. Potentially scrambling
>> (spoiling) the parameter stack.
>
> This is as I said, I just commented inode parameter and it wont build:

I appeared when I examined the code that they prepared for this and :

#define HAVE_UNLOCKED_IOCTL 1

... in nv.c almost suffices. ;-) They defined this like that:

static struct file_operations nv_fops = {
     .owner     = THIS_MODULE,
     .poll      = nv_kern_poll,
     // .ioctl     = nv_kern_ioctl,
#if defined(HAVE_UNLOCKED_IOCTL)
     .unlocked_ioctl = nv_kern_unlocked_ioctl,
#endif
#if defined(NVCPU_X86_64) && defined(HAVE_COMPAT_IOCTL)
     .compat_ioctl = nv_kern_compat_ioctl,
#endif
#ifndef NV_USER_MAP
     .mmap      = nv_kern_mmap,
#endif /* NV_USER_MAP */
     .open      = nv_kern_open,
     .release   = nv_kern_close,
};

Regards and thanks,

Piotr Hosowicz


-- 
- Jaka jest najwiêksza anomalia fizjologiczno-polityczna?
- Cz³onek wysuniêty z ramienia na czo³o.
NP: Dream Theater - Pull Me Under
NB: 2.6.36-rc1
