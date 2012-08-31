Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755166Ab2HaVwI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 17:52:08 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50360 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755128Ab2HaVwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 17:52:04 -0400
Message-ID: <50413200.5010104@linaro.org>
Date: Fri, 31 Aug 2012 15:52:00 -0600
From: Mathieu Poirier <mathieu.poirier@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: linux-kernel@vger.kernel.org, rdunlap@xenotime.net, arve@android.com,
        kernel-team@android.com, john.stultz@linaro.org
Subject: Re: [PATCH v2] drivers/tty: Folding Android's keyreset driver in
 sysRQ
References: <1346365854-28441-1-git-send-email-mathieu.poirier@linaro.org> <20120830230129.GC21501@core.coreip.homeip.net>
In-Reply-To: <20120830230129.GC21501@core.coreip.homeip.net>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-08-30 05:01 PM, Dmitry Torokhov wrote:
> Hi Matthieu,
> 
> On Thu, Aug 30, 2012 at 04:30:54PM -0600, mathieu.poirier@linaro.org wrote:
>> From: "Mathieu J. Poirier" <mathieu.poirier@linaro.org>
>>
>> This patch adds keyreset functionality to the sysrq driver. It
>> allows certain button/key combinations to be used in order to
>> trigger device resets.
>>
>> The first time the key-combo is detected a work function that syncs
>> the filesystems is scheduled and the kernel rebooted. If all the keys
>> are released and then pressed again, it calls panic. Reboot on panic
>> should be set for this to work.  A platform device that specify a
>> reset key-combo should be added to the board file to trigger the
>> feature.
>
> Why do we need to involve a platform device and not use, for example, a module
> parameter, that could be set up from userspace?

The platform device comes from the original design and was included to
minimise the amount of changes in code that make use of the current
keyreset driver.

I am definitely willing to explore the possibility of adding module
parameter to complement the platform data but again, to avoid impacting
board code I'm in favour of keeping the platform data/device - get back
to me if you disagree.

Thinking back on this it may be better to call 'platform_driver_probe'
rather than 'platform_driver_register'.  That way one wouldn't have to
instantiate a platform_device.

> 
> Also, why do we need reset_fn() and not simply invoke SysRq-B handler
> that should call ctrl_alt_del() for us?

The reset_fn() gives an implementer the chance of calling some custom
function before the reset sequence is started and in my opinion should
stay.  On the flip side I'm not sure that I understand what you mean by
"SysRq-B handler" - are you talking about the "sysrq_reboot_op" ?
Please expand on that ?

Thanks for the review and comments,
Mathieu.

> 
> Thanks.
> 

