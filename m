Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932754Ab2IDVxH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 17:53:07 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52265 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757639Ab2IDVxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 17:53:04 -0400
Message-ID: <5046783D.4020702@linaro.org>
Date: Tue, 04 Sep 2012 15:53:01 -0600
From: Mathieu Poirier <mathieu.poirier@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        rdunlap@xenotime.net, arve@android.com, kernel-team@android.com,
        john.stultz@linaro.org
Subject: Re: [PATCH v2] drivers/tty: Folding Android's keyreset driver in
 sysRQ
References: <1346365854-28441-1-git-send-email-mathieu.poirier@linaro.org> <20120830230129.GC21501@core.coreip.homeip.net> <50413200.5010104@linaro.org> <20120831230227.6e5008b5@pyramind.ukuu.org.uk> <20120831224128.GA22073@core.coreip.homeip.net> <50414140.60102@linaro.org> <20120831232234.GB22142@core.coreip.homeip.net>
In-Reply-To: <20120831232234.GB22142@core.coreip.homeip.net>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-08-31 05:22 PM, Dmitry Torokhov wrote:
> On Fri, Aug 31, 2012 at 04:57:04PM -0600, Mathieu Poirier wrote:
>> On 12-08-31 04:41 PM, Dmitry Torokhov wrote:
>>> On Fri, Aug 31, 2012 at 11:02:27PM +0100, Alan Cox wrote:
>>>>>> Why do we need to involve a platform device and not use, for example, a module
>>>>>> parameter, that could be set up from userspace?
>>>>>
>>>>> The platform device comes from the original design and was included to
>>>>> minimise the amount of changes in code that make use of the current
>>>>> keyreset driver.
>>>>
>>>> The platform device is IMHO the right answer. In this class of devices
>>>> the stuff is compiled in, the userspace is Android, there are no modules
>>>> and there is no reason for it to be configurable.
>>>
>>> It does not matter if it is built in or not, /sys/module/XXX/parameters
>>> is still there, and while havig it in kernel is "easy" you could as
>>> easily stuff needed data into a sysfs attribute during booting.
>>>
>>> And we should be able to get this from DT even without the platform
>>> device (this was the next step, wasn't it?).
>>
>> Correct - my hope was to get the main functionality accepted before
>> adding DT support.  Do you think the lack of DT support is a blocker for
>> acceptance ?  Please confirm.
>>
> 
> No, lack of DT is not a blocker, but I am unconvinced that we need
> platform device.
> 
> Thanks,
> 

A platform device is really easy to spin-off in a board file and once it
is there you don't have to worry about other loose ends to tie in before
the solution is functional.

I don't mind supplementing the current proposition with a module
parameter interface to get the "key_down" and "key_up" sequences.

Which brings us to the "reset_fn()" function - in my opinion it offers
significant advantages and should be kept in the design.  What I'm not
so clear about is on the implementation.  Should it be kept as part of a
platform data or be implemented as a notifier as suggested by Alan.  I
am looking for guidance here and suggestions are encouraged.

Regards,
Mathieu.
