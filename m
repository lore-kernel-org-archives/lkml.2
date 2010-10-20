Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751782Ab0JTJiv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 05:38:51 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36211 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918Ab0JTJit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 05:38:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=YR61e2dwJxouV5qsnhvgG9rpDcIz8hikHXLSDQnkKjF2BaBGu85kZXHSp4jOVGpB5w
         Ba6zNbf9izCYf3Z0oq0JkSTQY2vBF5oqfQ1X0bxC/uZNirz2DqgVlOETjxvCIGXWhlC+
         zVBLWP2ayHUlTICvBAA9YZfhLuAIDlOl2wF+0=
Message-ID: <4CBEB8A3.6080100@suse.cz>
Date: Wed, 20 Oct 2010 11:38:43 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.11) Gecko/20101013 SUSE/3.1.5 Thunderbird/3.1.5
MIME-Version: 1.0
CC: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        clemens@ladisch.de, venki@google.com,
        the arch/x86 maintainers <x86@kernel.org>
Subject: Re: HPET causes tasks to freeze (still in 2.6.36-rc6)
References: <4CA9F471.2080704@suse.cz> <alpine.LFD.2.00.1010041747550.14550@localhost6.localdomain6> <4CB38960.5070306@suse.cz>
In-Reply-To: <4CB38960.5070306@suse.cz>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/2010 12:02 AM, Jiri Slaby wrote:
> On 10/04/2010 06:31 PM, Thomas Gleixner wrote:
>> On Mon, 4 Oct 2010, Jiri Slaby wrote:
>>> HPET as a clocksource has still issues in the latest kernels (confirmed
>>> in 2.6.36-rc6) at least on x86_64. Unless clocksource=jiffies,
>>> clocksource=tsc or nolapic_timer is used, the system is unusable. Tasks
>>> are not woken unless mouse is moved, key is pressed (or other hard irq
>>> triggered). 2.6.32 seems to be the last working.
>>
>> The problem is not clocksource related, it's NOHZ related.
>>
>> clocksource=jiffies, clocksource=tsc are disabling NOHZ simply because
>> we can not do NOHZ neither with jiffies nor with a TSC which stops in
>> deeper C-states.
>>
>> nolapic_timer installs a dummy lapic timer so the lapic is not used,
>> but HPET is used instead and NOHZ is disabled as well.
>>
>> So the real problem is that the hpet broadcast interrupts which are
>> used to work around the lapic timer stops in C3 problem are not coming
>> through for whatever reason.
>>
>> So the question is what changed in the ACPI/idle NOHZ code which might
>> expose this problem.
>>
>> Can we get dmesg, output of proc/timer_list and output of
>> /proc/acpi/processor/CPU0/power for a .32 and a non working kernel
>> please ?
> 
> Sure:
> http://labs.suse.cz/jslaby/bug-579932/

Did anybody have a chance to look into the logs? Should I create a bug
at kernel.org for that? Or provide more info?

thanks,
-- 
js
suse labs
