Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545Ab2DGSz4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2012 14:55:56 -0400
Received: from vwp2514.webpack.hosteurope.de ([87.230.42.24]:47501 "EHLO
	vwp2514.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752463Ab2DGSzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2012 14:55:55 -0400
X-Greylist: delayed 1042 seconds by postgrey-1.27 at vger.kernel.org; Sat, 07 Apr 2012 14:55:55 EDT
Message-ID: <4F8089A9.6080704@raumfeld.com>
Date: Sat, 07 Apr 2012 20:38:33 +0200
From: Sven Neumann <s.neumann@raumfeld.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Olof Johansson <olof@lixom.net>, Daniel Mack <daniel@caiaq.de>,
        Daniel Mack <zonque@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: eeti_ts: Mark as CONFIG_BROKEN
References: <1333777207-4151-1-git-send-email-olof@lixom.net> <20120407070206.GA17623@core.coreip.homeip.net>
In-Reply-To: <20120407070206.GA17623@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;s.neumann@raumfeld.com;1333824955;d0768c86;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 07.04.12 09:02, Dmitry Torokhov wrote:
> On Fri, Apr 06, 2012 at 10:40:07PM -0700, Olof Johansson wrote:
>> This seems to have been broken since 2010, so obviously noone actually
>> cares about the driver:
>>
>> make[4]: *** [drivers/input/touchscreen/eeti_ts.o] Error 1
>> drivers/input/touchscreen/eeti_ts.c: In function 'eeti_ts_irq_active':
>> drivers/input/touchscreen/eeti_ts.c:65:2: error: implicit declaration of function 'irq_to_gpio' [-Werror=implicit-function-declaration]
>>
>> irq_to_gpio isn't available on most platforms today, so the driver
>> will need some rework by someone who has hardware access and can test
>> (to make sure that, for example, switching to level interrupts and just
>> keep taking them while there's more to process works).
>>
>> I guess it could just be scheduled for removal, but let's start with
>> marking it CONFIG_BROKEN.
>
> Well, it probably works quite well on arches that do have irq_to_gpio(),
> let's ask Daniel and Sven if they still have this hardware and if they
> can try the patch below that implements what you suggested.

This hardware is still in use and we also still follow kernel 
development and try to update our customer devices to recent kernel 
versions regularly. Currently we are at 3.1.10 and the touchscreen works 
well with that. I'll try to update to a more recent kernel next week and 
will try your patch.


Regards, Sven

