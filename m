Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752935Ab2DCJpp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 05:45:45 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:33813 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394Ab2DCJpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 05:45:44 -0400
Message-ID: <4F7AC6A5.6050907@linux.vnet.ibm.com>
Date: Tue, 03 Apr 2012 15:15:09 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Martin Steigerwald <Martin@lichtvoll.de>
CC: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        a.p.zijlstra@chello.nl, stern@rowland.harvard.edu, rjw@sisk.pl,
        pavel@ucw.cz
Subject: Re: [REGRESSION] NMI received for unknown reason 3c on CPU 0, strange
 powersaving mode?
References: <201203301304.49708.Martin@lichtvoll.de> <4F7987D0.3090106@linux.vnet.ibm.com> (sfid-20120402_143911_704229_5D7541F7) <201204030927.36606.Martin@lichtvoll.de>
In-Reply-To: <201204030927.36606.Martin@lichtvoll.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
x-cbid: 12040309-4790-0000-0000-0000020E1B92
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2012 12:57 PM, Martin Steigerwald wrote:

> Am Montag, 2. April 2012 schrieb Srivatsa S. Bhat:
>> On 03/30/2012 04:34 PM, Martin Steigerwald wrote:
>>> Hi!
>>>
>>> Since some time I am seeing things like
>>>
>>> Message from syslogd@merkaba at Mar 30 00:29:30 ...
>>>
>>>  kernel:[49074.294260] Uhhuh. NMI received for unknown reason 3c on
>>>  CPU 0.
>>>
>>> Message from syslogd@merkaba at Mar 30 00:29:30 ...
>>>
>>>  kernel:[49074.294263] Do you have a strange power saving mode
>>>  enabled?
>>>
>>> Message from syslogd@merkaba at Mar 30 00:29:30 ...
>>>
>>>  kernel:[49074.294264] Dazed and confused, but trying to continue
>>>
>>> on resume after in-kernel hibernation.
>>
>> Do you see this after suspend-to-ram too?
> 
> No.


Ok..

> 
>>> I do not see any trace of it in syslog, kern.log or dmesg.
>>>
>>> From the timestemp it seems that these messages are issued shortly
>>> before I send the laptop to hibernation last night.
>>>
>>>
>>> I am using a ThinkPad T520 with Intel(R) Core(TM) i5-2520M CPU @
>>> 2.50GHz and Sandybridge graphics.
>>>
>>> I am not exactly sure since when it happens, cause I basically
>>> ignored it for quite some time. Might be some 3.2 kernel where it
>>> started, maybe even the first 3.2 kernel I had. Currently I am
>>> using:
>>>
>>> martin@merkaba:~> cat /proc/version
>>> Linux version 3.3.0-trunk-amd64 (Debian 3.3-1~experimental.1)
>>> (debian- kernel@lists.debian.org) (gcc version 4.6.3 (Debian
>>> 4.6.3-1) ) #1 SMP Thu Mar 22 18:02:10 UTC 2012
>>>
>>> Since I am quite sure I didn´t see this with the first kernel I used
>>> on this machine, which was a 2.6.39 if I remember correctly, I
>>> consider this to be a regression for now.
>>>
>>>
>>> I did not see any other strange effects, only this message.
>>>
>>>
>>> When searching for it I see quite some references¹. But what I looked
>>> at seemed to either quite old or different in that the machine was
>>> frozen then.
>>
>> There was once such a bug report and commit 144060fee (perf: Add PM
>> notifiers to fix CPU hotplug races) tried to fix it, however it didn't
>> work out IIRC.
>>
>> Can you please try out the pm-test framework and let us know in which
>> phase this message is encountered?
>> Documentation/power/basic-pm-debugging.txt
>>
>> 1. Recompile the kernel with CONFIG_PM_DEBUG=y
> 
> Luckily I have this already.
> 
> martin@merkaba:~> grep   CONFIG_PM_DEBUG /boot/config-3.3.0-trunk-amd64
> CONFIG_PM_DEBUG=y
> 
>> 2. # cat /sys/power/pm_test
>> 3. # echo <value> > /sys/power/pm_test
>>    Use the values from the list given in step 2.
>>    From freezer to core, it is increasing depth of suspend phase.
>> 4. # echo mem > /sys/power/state  (for suspend-to-ram)
>>    or echo disk > /sys/power/state  (for suspend-to-disk)
> 
> I understand it that you want me to do step 4 for each of the values from 
> step 3. If not so, please tell me.
>


Yes, that's right. And moreover, the values in step 3 are in increasing order
from freezer to core. Which means, the core level is a superset of everything
before it. (So if you don't hit the problem with the core level, you won't hit it
in any previous level.)

Regards,
Srivatsa S. Bhat

