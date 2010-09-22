Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385Ab0IVJmq (ORCPT <rfc822;list-kernel77@spinics.net>);
	Wed, 22 Sep 2010 05:42:46 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:41891 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752289Ab0IVJmp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 05:42:45 -0400
X-Authenticated: #8143315
X-Provags-ID: V01U2FsdGVkX1/6WusWzt76nrEVLvkYnh2fsxDCnravSI2eZPGR9s
	2VmaIXLxn4L2CQ
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Andrew Morton" <akpm@linux-foundation.org>, "Greg KH" <greg@kroah.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, stable@kernel.org
Subject: Re: [stable] regression in 2.6.35.4 'load is to heavy (video
 subsystem?)'
References: <op.vh8rams6gp7xae@127.0.0.1>
 <20100921165007.6200846f.akpm@linux-foundation.org>
 <20100922000101.GA5077@kroah.com>
Date: Wed, 22 Sep 2010 11:42:41 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
FROM: Karsten Mehrhoff <kawime@gmx.de>
Message-ID: <op.vjfg9fo2gp7xae@127.0.0.1>
In-Reply-To: <20100922000101.GA5077@kroah.com>
User-Agent: Opera Mail/10.70 (Linux)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Am 22.09.2010, 02:01 Uhr, schrieb Greg KH <greg@kroah.com>]

> On Tue, Sep 21, 2010 at 04:50:07PM -0700, Andrew Morton wrote:
>> On Mon, 30 Aug 2010 10:02:36 +0200
>> Karsten Mehrhoff <kawime@gmx.de> wrote:
>>
>>> Using the same .config from 2.6.35.3 to compile 2.5.36.4 results in a
>>> heavy load with 2.6.35.4.
>>
>> A regression within -stable is rather bad.
>
> Agreed.
>
>>> Example:
>>>
>>> Difference between 2.6.35.1/2/3 and 2.6.35.4 while watching some  
>> videos:
>>> 2.6.35.4 switches the cpu for flash videos in the browser (opera or
>>> iceweasel) or other video outputs to 2200/2400/2600 MHz meanwhile  
>> 2.6.35.3
>>> (or older) stays at 1000 Mhz. That results in a higher cpu  
>> temperature,
>>> more power consumption and so one.
>>>
>>> Using other GUI program results in nearly the same problems with  
>> 2.6.35.4,
>>> so this kernel is unusable for me.
>>>
>>> Results to see the difference for the same action
>>> 2.6.35.4
>>> Core0 Temp:  +45.0__C
>>> Core1 Temp:  +43.0__C
>>> cpu MHz:	2200.000 or higher
>>>
>>> 2.6.35.3
>>> Core0 Temp:  +32.0__C
>>> Core1 Temp:  +31.0__C
>>> cpu MHz:	1000.000 (max. 1800, but falling back to 1000)
>
> Can you run 'git bisect' between 2.6.35.3 and 2.6.35.4 to try to find
> out the offending patch that caused this issue?
>
> thanks,
>
> greg k-h

Same for 2.6.35.5 using 256.53

For your info, I did run some tests today using a nVidia 9500GT

    Kernel       |   Performance with NVIDIA-Linux-x86_64-
                 |       256.53      |    260.19.04 (BETA)
----------------------------------------------------------
  2.6.35.3       |      good         |      good
----------------------------------------------------------
  2.6.35.4       |       bad         |     not tested
----------------------------------------------------------
  2.6.35.5       |       bad         |      ~ good
----------------------------------------------------------
  2.6.36-rc4     |                   |
    (git1-5)     |     failed        |      good
----------------------------------------------------------
  2.6.36-rc4     |                   |
    (git1)       |     failed        |      good
----------------------------------------------------------


Karsten
