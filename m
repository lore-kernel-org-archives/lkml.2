Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612Ab1GMXPQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 19:15:16 -0400
Received: from proxima.lp0.eu ([81.2.80.65]:58114 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752109Ab1GMXPO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 19:15:14 -0400
Message-ID: <4E1E26FD.7020503@simon.arlott.org.uk>
Date: Thu, 14 Jul 2011 00:15:09 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110511 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-media@vger.kernel.org
Subject: Re: 2.6.39 "tuner-core: remove usage of DIGITAL_TV" breaks saa7134
 with mt2050
References: <4E1CBAC8.2030404@simon.arlott.org.uk> <4E1D1DAF.4060900@redhat.com>
In-Reply-To: <4E1D1DAF.4060900@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/07/11 05:23, Mauro Carvalho Chehab wrote:
> Em 12-07-2011 18:21, Simon Arlott escreveu:
>> commit ad020dc2fe9039628cf6cef42cd1b76531ee8411
>> Author: Mauro Carvalho Chehab <mchehab@redhat.com>
>> Date:   Tue Feb 15 09:30:50 2011 -0200
>> 
>>     [media] tuner-core: remove usage of DIGITAL_TV
>>     
>> This breaks my Pinnacle PCTV 300i DVB-T cards as they can no longer tune
>> DVB-T.
>> 
>> [  540.010030] tuner 3-0043: Tuner doesn't support mode 3. Putting tuner to sleep
>> [  540.011017] tuner 2-0043: Tuner doesn't support mode 3. Putting tuner to sleep
>> [  540.012012] tuner 3-0060: Tuner doesn't support mode 3. Putting tuner to sleep
>> [  540.013029] tuner 2-0060: Tuner doesn't support mode 3. Putting tuner to sleep
>> 
>> saa7134 needs to indicate digital TV tuning to mt20xx but it looks like
>> tuner-core no longer has any way to allow a tuner to indicate support
>> for this?
>> 
>> (mt2050_set_tv_freq in mt20xx.c uses V4L2_TUNER_DIGITAL_TV)
> 
> Could you please try the enclosed patch? It should fix the issue.
> I should probably rename T_ANALOG_TV to just T_TV, but I'll do it on
> a next patch if this one works ok, as we don't want to send a renaming
> patch to -stable.

This fixes it. Tuner error messages could do with being error level - I
didn't see the message initially as I have the debugging turned off.
The -EINVAL never gets passed up to userspace.

> ---
> [media] Fix Digital TV breakage with mt20xx tuner
> 
> The mt20xx tuner passes V4L2_TUNER_DIGITAL_TV to tuner core. However, the
> check_mode code now doesn't handle it well. Change the logic there to
> avoid the breakage, and fix a test for analog-only at g_tuner.

Thanks,

-- 
Simon Arlott
