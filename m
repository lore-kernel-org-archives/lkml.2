Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752112Ab2KEADv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 19:03:51 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:32816 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499Ab2KEADu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 19:03:50 -0500
Message-ID: <50970260.3020004@gmail.com>
Date: Mon, 05 Nov 2012 11:03:44 +1100
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Luca Clementi <luca.clementi@gmail.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Brian Swetland <swetland@google.com>
Subject: Re: [PATCH] Staging: Android: logger: module_exit implementationg
References: <1351836952-3389-1-git-send-email-luca.clementi@gmail.com> <20121102182926.GA18824@kroah.com> <CAERW5OyUN_RCOsihCOUnWwAxFA4ODiqX-=i9x=zEcHXczVNCGA@mail.gmail.com>
In-Reply-To: <CAERW5OyUN_RCOsihCOUnWwAxFA4ODiqX-=i9x=zEcHXczVNCGA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/12 04:45, Luca Clementi wrote:
> On Fri, Nov 2, 2012 at 11:29 AM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
>> On Thu, Nov 01, 2012 at 11:15:52PM -0700, Luca Clementi wrote:

<snip>

>>> +             vfree(current_log->buffer);
>>> +             kfree(current_log->misc.name);
>>> +             kfree(current_log);
>>> +     }
>>> +
>>> +     return;
>>> +}
>>> +
>>> +
>>> +module_init(logger_init);
>>
>> Is module_init() the same "level" as device_initcall()?  Did you test
>> this out in an Android system?
> 
> Honestly I haven't tested it on Android, but in include/linux/init.h there is:
> 
> #define module_init(x)  __initcall(x);
> ...
> #define __initcall(fn) device_initcall(fn)
> 
> Which lead me to think that there is not much difference between the two call.

The different initcalls run at different times. Often modules run with
something other than module_init if there are other dependencies on the
module/subsystem (see i2c core/busses for example). You would need to
check why logger was using device_initcall and make sure that it works
correctly (e.g. doesn't miss some early logs) in order to make this
change. It should be done as a separate patch anyway to make it easier
to identify any issues with it later.

~Ryan

