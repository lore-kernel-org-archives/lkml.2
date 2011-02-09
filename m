Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755711Ab1BISct (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 13:32:49 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:34810 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755255Ab1BIScr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 13:32:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=cRYwRZmuaNReW+eMBAkWOflT+8fYjUUdFW8DKcSCsC9dieHyTF61egjHCWXrxCAUHN
         MHocc/mJCohIwDi4RRjsf8QuumSDdWIDZGUAgdyoDKgNtrLPhMqa/SOAS9aOW8liXOwD
         wnZX/x9f4SzfXCMqz7nV74/FEQUjJG5W9ccXQ=
Message-ID: <4D52DD81.7050401@am.sony.com>
Date: Wed, 09 Feb 2011 10:31:29 -0800
From: Frank Rowand <frank.rowand@gmail.com>
Reply-To: frank.rowand@am.sony.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Len Brown <len.brown@intel.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-embedded@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Remove CONFIG_PM altogether, enable power management
 all the time
References: <4D51D341.3040209@am.sony.com> <20110209114137.GA10163@opensource.wolfsonmicro.com> <201102091807.03094.rjw@sisk.pl>
In-Reply-To: <201102091807.03094.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/09/11 09:07, Rafael J. Wysocki wrote:
> On Wednesday, February 09, 2011, Mark Brown wrote:
>> On Tue, Feb 08, 2011 at 03:35:29PM -0800, Frank Rowand wrote:
>>
>>> For 2.6.38-rc4, x86_64, CONFIG_NR_CPUS=4:
>>
>>> size vmlinux
>>>    text     data       bss       dec      hex  filename
>>>
>>> 6553910  3555020   9994240  20103170  132c002  vmlinux    with    CONFIG_PM
>>> 6512652  3553116   9994240  20060008  1321768  vmlinux    without CONFIG_PM
>>>
>>>   41258     1904         0     43162                      delta
>>
>>> That is big enough for me to care.
>>
>> Hrm, that's pretty surprising.  It'd be interesting to know how much of
>> that is due to the PM core itself and how much of that is from drivers.
>> For the drivers CONFIG_PM isn't really the option they should be using
>> in the first place - they mostly want some combination of PM_SLEEP and
>> PM_RUNTIME for the specific functionality.  I'm running some checks now.
>>
>>>  > CONFIG_PM_SLEEP=y
>>
>> Raphael's patch will make this a user visible option in place of raw
>> CONFIG_PM by default so you'd be able to turn that off.
> 
> No, it won't (just to clarify).

Raphael's patch will turn on CONFIG_PM in the correct circumstances, and
leave it off when not needed by other config options.  That means that
the size overhead will _not_ be an issue for me because CONFIG_PM
will not be enabled when not needed.

-Frank
