Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752418Ab3ABBnJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2013 20:43:09 -0500
Received: from mail.kapsi.fi ([217.30.184.167]:56826 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751672Ab3ABBnG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2013 20:43:06 -0500
Message-ID: <50E3907C.4040106@iki.fi>
Date: Wed, 02 Jan 2013 03:42:20 +0200
From: Antti Palosaari <crope@iki.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Shuah Khan <shuahkhan@gmail.com>
CC: Borislav Petkov <bp@alien8.de>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Andy Furniss <andyqos@ukfsn.org>, Alex Deucher <alexdeucher@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        dri-devel@lists.freedesktop.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: radeon 0000:02:00.0: GPU lockup CP stall for more than 10000msec
References: <CADnq5_MJzNdWVCauZj5Z7Monmsy4gWeYP3gJaPUPwHEgqhqOYw@mail.gmail.com> <20121223002507.GA12121@liondog.tnic> <CADnq5_Oe=_nOrsgUZvPc82F5CFAWecx=Uiqn0CAeK+YG3ns3AA@mail.gmail.com> <20121223105527.GA6230@liondog.tnic> <50D6E491.3030801@ukfsn.org> <20121223110730.GC6230@liondog.tnic> <50D6E8A4.1030204@ukfsn.org> <20121223113153.GA8918@liondog.tnic> <20121223115133.GA229@x4> <20121223122210.GA4460@liondog.tnic> <20121223133102.GA8153@liondog.tnic> <CAKocOOPO7ZhybEgKfCkpna+KbpGgajMp6HuHbO9m9uT3gUtP0g@mail.gmail.com>
In-Reply-To: <CAKocOOPO7ZhybEgKfCkpna+KbpGgajMp6HuHbO9m9uT3gUtP0g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 82.128.184.254
X-SA-Exim-Mail-From: crope@iki.fi
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/25/2012 06:50 AM, Shuah Khan wrote:
> On Sun, Dec 23, 2012 at 6:31 AM, Borislav Petkov <bp@alien8.de> wrote:
>> On Sun, Dec 23, 2012 at 01:22:12PM +0100, Borislav Petkov wrote:
>>> Right, let me try that and report back.
>>
>> Yep, looks like reverting the above commit fixes it - the boston.com
>> website loads just fine.
>>
>> Thanks.
>>
>> --
>> Regards/Gruss,
>>      Boris.
>
> Saw the same error and after reading this thread, reverted the
>
> Commit 2d6cc7296d4ee128ab0fa3b715f0afde511f49c2.
>
> drm/radeon: use async dma for ttm buffer moves on 6xx-SI
>
> and the problem is gone. In my case, it is a solid hang right after
> system switches to vga. I was able to login on console once or twice.
> But dmesg showed the same message reported in this thread:
>
> [   35.812085] radeon 0000:01:00.0: GPU lockup CP stall for more than 10000msec
> [   35.812091] radeon 0000:01:00.0: GPU lockup (waiting for
> 0x0000000000000002 last fence id 0x0000000000000001)
>
>
> My system has:
> 01:00.0 VGA compatible controller: Advanced Micro Devices [AMD] nee
> ATI RV620 [Mobility Radeon HD 3400 Series]

I ended up also that same commit after bisecting from current 3.8 master.

01:05.0 VGA compatible controller: ATI Technologies Inc 760G [Radeon 3000]
It is ASUS M5A78L-M/USB3 with integrated GPU.

I cannot even boot unless graphical boot is removed from Fedora 17 boot 
options (rhgb quiet). Random GPU crashes still.

regards
Antti

-- 
http://palosaari.fi/
