Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172Ab2HaWvv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 18:51:51 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50925 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753714Ab2HaWvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 18:51:49 -0400
Message-ID: <50414002.8040905@linaro.org>
Date: Fri, 31 Aug 2012 16:51:46 -0600
From: Mathieu Poirier <mathieu.poirier@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org,
        rdunlap@xenotime.net, arve@android.com, kernel-team@android.com,
        john.stultz@linaro.org
Subject: Re: [PATCH v2] drivers/tty: Folding Android's keyreset driver in
 sysRQ
References: <1346365854-28441-1-git-send-email-mathieu.poirier@linaro.org> <20120830230129.GC21501@core.coreip.homeip.net> <50413200.5010104@linaro.org> <20120831230227.6e5008b5@pyramind.ukuu.org.uk>
In-Reply-To: <20120831230227.6e5008b5@pyramind.ukuu.org.uk>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-08-31 04:02 PM, Alan Cox wrote:
>>> Why do we need to involve a platform device and not use, for example, a module
>>> parameter, that could be set up from userspace?
>>
>> The platform device comes from the original design and was included to
>> minimise the amount of changes in code that make use of the current
>> keyreset driver.
> 
> The platform device is IMHO the right answer. In this class of devices
> the stuff is compiled in, the userspace is Android, there are no modules
> and there is no reason for it to be configurable.
> 
>> I am definitely willing to explore the possibility of adding module
>> parameter to complement the platform data but again, to avoid impacting
>> board code I'm in favour of keeping the platform data/device - get back
>> to me if you disagree.
>>
>> Thinking back on this it may be better to call 'platform_driver_probe'
>> rather than 'platform_driver_register'.  That way one wouldn't have to
>> instantiate a platform_device.
>>
>>>
>>> Also, why do we need reset_fn() and not simply invoke SysRq-B handler
>>> that should call ctrl_alt_del() for us?
>>
>> The reset_fn() gives an implementer the chance of calling some custom
>> function before the reset sequence is started and in my opinion should

I did not express myself clearly - with reset_fn() a system can do
whatever it wants when a specific series of keys is pressed.

Granted that the next steps are most likely converging toward rebooting
the system - but it may not be right away and depending on the
circumstances a reboot could be avoided altogether.

> 
> So why wouldn't that already be using the reset notifiers ?

I am not familiar with the "reset notifiers" that have been referred to
but a little bit of research indicate that a registering subsystem gets
notified when the event of interest (in this case a reboot) happens.

I understand your proposition here but aren't we loosing flexibility in
what we can achieve when the event has been triggered ?

What do you think of adding a keyreset event that would be fired (and
caught by a registering subsystem) instead of calling reset_fn() ?

Thanks,
Mathieu.

> 
> Alan
> 

