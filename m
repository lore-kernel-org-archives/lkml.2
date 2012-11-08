Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755558Ab2KHNNU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 08:13:20 -0500
Received: from antcom.de ([188.40.178.216]:55909 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751721Ab2KHNNT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 08:13:19 -0500
Message-ID: <509BAFB9.6090801@antcom.de>
Date: Thu, 08 Nov 2012 14:12:25 +0100
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM Open Source Research and Development
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.10) Gecko/20121027 Icedove/10.0.10
MIME-Version: 1.0
To: Alban Bedel <alban.bedel@avionic-design.de>
CC: Thierry Reding <thierry.reding@avionic-design.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Alexandre Pereira da Silva <aletes.xgr@gmail.com>
Subject: Re: [PATCH] pwm: lpc32xx - Fix the PWM polarity
References: <20121106181939.61c50233@avionic-0020.adnet.avionic-design.de> <1352301955-15960-1-git-send-email-alban.bedel@avionic-design.de> <509B80A7.1060700@antcom.de> <20121108113353.4fdbb25c@avionic-0020.adnet.avionic-design.de> <509B8D20.6070208@antcom.de> <20121108122345.72aa0f6c@avionic-0020.adnet.avionic-design.de>
In-Reply-To: <20121108122345.72aa0f6c@avionic-0020.adnet.avionic-design.de>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11/12 12:23, Alban Bedel wrote:
>>> It is intended, the formular for duty value in the register is:
>>>
>>> duty = (256 - 256*duty_ns/period_ns) % 256
>>
>> Where does this modulo defined? In the Manual, there is sth. like this
>> defined for RELOADV (tables 606+607), but not for DUTY.
>>
>> Maybe I missed sth. in the manual. Link or hint appreciated!
> 
> The manual doesn't mention this explicitly but you can see that without
> the modulo when duty_ns==0 DUTY would be 256, but the register is only
> 8 bits wide (ie. modulo 256). I made a few test and looked at the PWM
> output on a scope they confirm this:
> 
>  DUTY     HIGH LEVEL
>   1         99.9%
>   25        90.0%
>   128       50.0%
>   220       10.0%
>   255        0.1%
>   0          0.0%
> 
> I'll resubmit the patch with the clamping in the correct order.

Thanks for measuring. With this, your resubmitted patch make much more
sense now.

Roland
