Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870Ab1INI3L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 04:29:11 -0400
Received: from mail-qw0-f42.google.com ([209.85.216.42]:54179 "EHLO
	mail-qw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811Ab1INI3E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 04:29:04 -0400
MIME-Version: 1.0
In-Reply-To: <CAC5umygv+y4J-hPNDjYo9ToV4z4uv5rzvK9pCLMa7vbjKvJgZg@mail.gmail.com>
References: <1313758358-27536-1-git-send-email-per.forlin@stericsson.com>
	<1313758358-27536-2-git-send-email-per.forlin@stericsson.com>
	<1313758358-27536-3-git-send-email-per.forlin@stericsson.com>
	<CAC5umyjWx7ZvT+F_XhOZt_utr=mS-0p5tDpJ1ioWNiDAJLNXwQ@mail.gmail.com>
	<CAJ0pr18dn3CtBsXk9MG3Zn9zSwAiNoxB3b-62aMO3+8H+kUX3A@mail.gmail.com>
	<CAJ0pr1-ba0iY808igXJuEiWAX5zwhTUD6r+8MAMeBTHYFTenCg@mail.gmail.com>
	<CAC5umygBmE-dayTrUhU_=dn7+YZ=nd8-s7SJw5xLxnKN1pBMAQ@mail.gmail.com>
	<CAJ0pr19+qC0nVwzrq5wbQKzgSVFXzuSgJ2T8auNhmXpzQu8bfg@mail.gmail.com>
	<CAC5umygv+y4J-hPNDjYo9ToV4z4uv5rzvK9pCLMa7vbjKvJgZg@mail.gmail.com>
Date: Wed, 14 Sep 2011 10:29:03 +0200
Message-ID: <CAJ0pr18JwZFL64_rKYmMUpS8J38w=v+yR96Aeh15et42bfdY4Q@mail.gmail.com>
Subject: Re: [PATCH v9 2/3] mmc: core: add random fault injection
From: Per Forlin <per.forlin@linaro.org>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, Linus Walleij <linus.walleij@linaro.org>,
        Chris Ball <cjb@laptop.org>, linux-doc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 September 2011 10:04, Akinobu Mita <akinobu.mita@gmail.com> wrote:
> 2011/9/14 Per Forlin <per.forlin@linaro.org>:
>
>> It's simple and the patch would be just two lines.
>> The reason for changing my mind is that it may be useful to be able to
>> pass the fault injection attributes even when mmc_core is a module.
>>
>>> module_param is more complicated than this. Also the parameter is only
>>> usefull when when mmc_core is built into the kernel (it's useless when
>>> mmc_core is built as a module).
>>>
>> If you want to enable fault injection for the mmc_core module at load
>> time (during mmc initialisation) the param must be used.
>> modprobe mmc_core fail_request=1,1,1,1
>> As soon as the module is loaded there is no need for the module param anymore.
>
> OK, I agree with you.  The module parameter is the only way
> to enable mmc fault injection if CONFIG_FAULT_INJECTION_DEBUG_FS
> is disabled.
>
This is true as well. My point is that if using
CONFIG_FAULT_INJECTION_DEBUG_FS the fault attributes can't be set
until after the mmc module initialisation. One may want to test the
error handling during the mmc initialisation.
I'll send out a version v2 using module_param_cb().

Thanks again,
Per
