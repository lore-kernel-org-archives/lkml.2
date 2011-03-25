Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809Ab1CYSWS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 14:22:18 -0400
Received: from mout9.freenet.de ([195.4.92.99]:37607 "EHLO mout9.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752343Ab1CYSWR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 14:22:17 -0400
Message-ID: <4D8CDD93.3030203@dualc.maya.org>
Date: Fri, 25 Mar 2011 19:23:15 +0100
From: Andreas Hartmann <andihartmann@freenet.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:2.0b13pre) Gecko/20110316 Firefox/4.0b13pre SeaMonkey/2.1b2pre
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org
Subject: Re: intel_ips produces constant load of 1
References: <im2ik4$3dd$1@ID-44327.news.uni-berlin.de> <20110321110404.6a71a404@jbarnes-desktop> <20110322132555.715dc096@jbarnes-desktop>
In-Reply-To: <20110322132555.715dc096@jbarnes-desktop>
X-Enigmail-Version: 1.2a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes wrote:
> On Mon, 21 Mar 2011 11:04:04 -0700
> Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> 
>>> ps aux | grep ips
>>> root       593  0.0  0.0      0     0 ?        S    17:20   0:00
>>> [ips-adjust]
>>> root       594  0.0  0.0      0     0 ?        D    17:20   0:00
>>> [ips-monitor]
>>>
>>> If the module isn't loaded, the load of the machine in idle mode is 0 as
>>> expected.  
>>
>> This is a reporting problem, and probably due to the schedule() call
>> and associated task state in the ips-monitor thread.  I thought setting
>> the task state to interruptible would prevent this, but it seems like
>> it's not enough for the deferrable on-stack timers?
>>
>> At any rate, it's not actually causing increased CPU usage, so you can
>> safely ignore it until we have a fix.
> 
> Oops, one task uses interruptible correctly, but the monitor thread
> doesn't.
> 
> Does this patch fix your load average?

The patch works fine:

ps aux | grep ips
root     22427  0.0  0.0      0     0 ?        S    19:15   0:00
[ips-adjust]
root     22428  0.0  0.0      0     0 ?        S    19:15   0:00
[ips-monitor]



btw: what does this mean (first line):


kernel: [ 6610.030205] intel ips 0000:00:1f.6: CPU TDP doesn't match
expected value (found 25, expected 29)
kernel: [ 6610.030218] intel ips 0000:00:1f.6: PCI INT C -> GSI 18
(level, low) -> IRQ 18
kernel: [ 6610.030733] intel ips 0000:00:1f.6: IPS driver initialized,
MCP temp limit 90


Thank you,
kind regards,
Andreas
