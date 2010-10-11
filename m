Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756714Ab0JKWCP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 18:02:15 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48022 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756513Ab0JKWCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 18:02:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=vMd9jVIke4/dgmk+O/Z3a7IpWcinTLSqcyXsLUfG/VKKDMK5k4kiYOuukwZHdtlsRR
         HKTD3q50eb/+l0jUvJXSNsQ45EN1Gq3173+SgcfeukiqfIS66Db8RMbsy2jEn6myfSWG
         SmZwEFQS4hsK8ac1ROw2kTCt3wuPr/i8DZ2JM=
Message-ID: <4CB38960.5070306@suse.cz>
Date: Tue, 12 Oct 2010 00:02:08 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.9) Gecko/20100914 SUSE/3.1.4 Thunderbird/3.1.4
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, clemens@ladisch.de, venki@google.com,
        the arch/x86 maintainers <x86@kernel.org>
Subject: Re: HPET causes tasks to freeze (still in 2.6.36-rc6)
References: <4CA9F471.2080704@suse.cz> <alpine.LFD.2.00.1010041747550.14550@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1010041747550.14550@localhost6.localdomain6>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/2010 06:31 PM, Thomas Gleixner wrote:
> On Mon, 4 Oct 2010, Jiri Slaby wrote:
>> HPET as a clocksource has still issues in the latest kernels (confirmed
>> in 2.6.36-rc6) at least on x86_64. Unless clocksource=jiffies,
>> clocksource=tsc or nolapic_timer is used, the system is unusable. Tasks
>> are not woken unless mouse is moved, key is pressed (or other hard irq
>> triggered). 2.6.32 seems to be the last working.
> 
> The problem is not clocksource related, it's NOHZ related.
> 
> clocksource=jiffies, clocksource=tsc are disabling NOHZ simply because
> we can not do NOHZ neither with jiffies nor with a TSC which stops in
> deeper C-states.
> 
> nolapic_timer installs a dummy lapic timer so the lapic is not used,
> but HPET is used instead and NOHZ is disabled as well.
> 
> So the real problem is that the hpet broadcast interrupts which are
> used to work around the lapic timer stops in C3 problem are not coming
> through for whatever reason.
> 
> So the question is what changed in the ACPI/idle NOHZ code which might
> expose this problem.
> 
> Can we get dmesg, output of proc/timer_list and output of
> /proc/acpi/processor/CPU0/power for a .32 and a non working kernel
> please ?

Sure:
http://labs.suse.cz/jslaby/bug-579932/

thanks,
-- 
js
suse labs
