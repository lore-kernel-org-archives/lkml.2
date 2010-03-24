Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932280Ab0CXQrx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 12:47:53 -0400
Received: from mail.tmr.com ([64.65.253.246]:47955 "EHLO partygirl.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751151Ab0CXQrt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 12:47:49 -0400
Message-ID: <4BAA4229.9010506@tmr.com>
Date: Wed, 24 Mar 2010 12:47:37 -0400
From: Bill Davidsen <davidsen@tmr.com>
Organization: TMR Associates Inc, Schenectady NY
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.21) Gecko/20090507 Fedora/1.1.16-1.fc9 NOT Firefox/3.0.11 pango-text SeaMonkey/1.1.16
MIME-Version: 1.0
To: Clemens Ladisch <clemens@ladisch.de>
CC: Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org,
       alsa-devel@alsa-project.org
Subject: Re: 2.6.34-rc1: regression: ^Z no longer stops sound
References: <20100314075831.GA13457@elf.ucw.cz> <hnjjud$k26$1@dough.gmane.org> <20100323135942.GB1703@ucw.cz> <4BA8CB73.80400@ladisch.de>
In-Reply-To: <4BA8CB73.80400@ladisch.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clemens Ladisch wrote:
> Pavel Machek wrote:
>   
>> On Sun 2010-03-14 17:20:13, Bill Davidsen wrote:
>>     
>>> Pavel Machek wrote:
>>>       
>>>> In 2.6.33, hitting ^Z stopped mpg123 in a way you'd expect (both on
>>>> thinkpad and geode notebook).
>>>>
>>>> On 2.6.34-rc1, hit ^Z and sound starts looping.
>>>>         
>>> That's not new, I have seen it back as far as 2.6.27.25 doing a suspend 
>>> in a VM (KVM, no libvirt). But it only happens a few times a year, so I 
>>> never chased it. I hate to report an occasional problem in an obsolete 
>>> kernel, and I can't reproduce it.
>>>
>>> Does it happen repeatably with the new kernel?
>>>       
>> It happened reliably so far, yes.
>>     
>
> This sounds as if the device has been configured to ignore underruns.
> What are the contents of /proc/asound/card0/pcm0p/sub0/{sw_params,status}
> when it's looping, and when it's really suspended?
>   

If you can give me a hint how to read /proc when the machine is 
suspended, other than waking it up, I'll certainly check the next time I 
see it.

But after reading your thought on underruns, I think you right. I see 
from a note  I wrote myself that I get this while pushing a wav file 
over the network to run "play" (from sox) on another machine. Every once 
in a while it finds a musical phrase it really likes. I had assumed it 
was a bug in sox, but a bug or mis-configure in the device fits all of 
the observed cases I've seen.

-- 
Bill Davidsen <davidsen@tmr.com>
  "We can't solve today's problems by using the same thinking we
   used in creating them." - Einstein

