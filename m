Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801Ab1CVG7q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 02:59:46 -0400
Received: from mout9.freenet.de ([195.4.92.99]:38928 "EHLO mout9.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754414Ab1CVG7p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 02:59:45 -0400
Message-ID: <4D884917.2010400@dualc.maya.org>
Date: Tue, 22 Mar 2011 08:00:39 +0100
From: Andreas Hartmann <andihartmann@freenet.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:2.0b13pre) Gecko/20110316 Firefox/4.0b13pre SeaMonkey/2.1b2pre
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: intel_ips produces constant load of 1
References: <im2ik4$3dd$1@ID-44327.news.uni-berlin.de> <20110321110404.6a71a404@jbarnes-desktop>
In-Reply-To: <20110321110404.6a71a404@jbarnes-desktop>
X-Enigmail-Version: 1.2a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes wrote:
> On Sat, 19 Mar 2011 16:38:38 +0100
> Andreas Hartmann <andihartmann@01019freenet.de> wrote:
> 
>> Hello,
>>
>> on my MSI CR620 laptop, intel_ips produces a constant load of 1, even if
>> the machine is idle.
>>
>> The ips-monitor hangs in D state:
>>
>> ps aux | grep ips
>> root       593  0.0  0.0      0     0 ?        S    17:20   0:00
>> [ips-adjust]
>> root       594  0.0  0.0      0     0 ?        D    17:20   0:00
>> [ips-monitor]
>>
>> If the module isn't loaded, the load of the machine in idle mode is 0 as
>> expected.
> 
> This is a reporting problem, and probably due to the schedule() call
> and associated task state in the ips-monitor thread.  I thought setting
> the task state to interruptible would prevent this, but it seems like
> it's not enough for the deferrable on-stack timers?
> 
> At any rate, it's not actually causing increased CPU usage, so you can
> safely ignore it until we have a fix.
> 

I've got one more question (I found
http://forum.soft32.com/linux/RFC-Intelligent-power-sharing-driver-ftopict510146.html):

Where is the difference to the functionality the bios provides? I can't
see (and hear :-)) any difference between with intel_ips and without
intel_ips.
The fan always runs at a minimal speed, very quiet.
The fan is getting loader, if the load is getting high (during
compile-sessions e.g.). If the compile session is ready, the fan get's
slower again.

If I check the "cpu MHz" in /proc/cpuinfo with or without intel_ips, I
can't see any difference. The value never exceeds the value given in the
model name. The lowest values are equal, too.


What is the added value compared to the bios functionality? How can I
check it?



Thank you for your help!
Andreas
