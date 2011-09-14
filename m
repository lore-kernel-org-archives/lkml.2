Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753025Ab1INIFG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 04:05:06 -0400
Received: from mail-vw0-f42.google.com ([209.85.212.42]:43662 "EHLO
	mail-vw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752117Ab1INIFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 04:05:00 -0400
MIME-Version: 1.0
In-Reply-To: <CAJ0pr19+qC0nVwzrq5wbQKzgSVFXzuSgJ2T8auNhmXpzQu8bfg@mail.gmail.com>
References: <1313758358-27536-1-git-send-email-per.forlin@stericsson.com>
	<1313758358-27536-2-git-send-email-per.forlin@stericsson.com>
	<1313758358-27536-3-git-send-email-per.forlin@stericsson.com>
	<CAC5umyjWx7ZvT+F_XhOZt_utr=mS-0p5tDpJ1ioWNiDAJLNXwQ@mail.gmail.com>
	<CAJ0pr18dn3CtBsXk9MG3Zn9zSwAiNoxB3b-62aMO3+8H+kUX3A@mail.gmail.com>
	<CAJ0pr1-ba0iY808igXJuEiWAX5zwhTUD6r+8MAMeBTHYFTenCg@mail.gmail.com>
	<CAC5umygBmE-dayTrUhU_=dn7+YZ=nd8-s7SJw5xLxnKN1pBMAQ@mail.gmail.com>
	<CAJ0pr19+qC0nVwzrq5wbQKzgSVFXzuSgJ2T8auNhmXpzQu8bfg@mail.gmail.com>
Date: Wed, 14 Sep 2011 17:04:59 +0900
Message-ID: <CAC5umygv+y4J-hPNDjYo9ToV4z4uv5rzvK9pCLMa7vbjKvJgZg@mail.gmail.com>
Subject: Re: [PATCH v9 2/3] mmc: core: add random fault injection
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Per Forlin <per.forlin@linaro.org>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, Linus Walleij <linus.walleij@linaro.org>,
        Chris Ball <cjb@laptop.org>, linux-doc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/9/14 Per Forlin <per.forlin@linaro.org>:

> It's simple and the patch would be just two lines.
> The reason for changing my mind is that it may be useful to be able to
> pass the fault injection attributes even when mmc_core is a module.
>
>> module_param is more complicated than this. Also the parameter is only
>> usefull when when mmc_core is built into the kernel (it's useless when
>> mmc_core is built as a module).
>>
> If you want to enable fault injection for the mmc_core module at load
> time (during mmc initialisation) the param must be used.
> modprobe mmc_core fail_request=1,1,1,1
> As soon as the module is loaded there is no need for the module param anymore.

OK, I agree with you.  The module parameter is the only way
to enable mmc fault injection if CONFIG_FAULT_INJECTION_DEBUG_FS
is disabled.
