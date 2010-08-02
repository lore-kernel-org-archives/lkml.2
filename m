Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828Ab0HBU4z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 16:56:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42639 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751245Ab0HBU4x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 16:56:53 -0400
Message-ID: <4C572327.7040801@suse.de>
Date: Mon, 02 Aug 2010 21:57:27 +0200
From: Tejun Heo <teheo@suse.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.7) Gecko/20100713 Thunderbird/3.1.1
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
Cc: lkml <linux-kernel@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>,
        Greg KH <gregkh@suse.de>
Subject: Re: [GIT PULL tip/genirq] Please pull from lost-spurious-irq
References: <4C5033D9.7030800@kernel.org> <4C50349F.7020002@suse.de> <alpine.LFD.2.00.1007291042441.2471@localhost.localdomain> <4C529F59.3020404@suse.de> <alpine.LFD.2.00.1008020956080.9198@localhost.localdomain> <4C56E42D.5010300@suse.de> <4C56E5C7.90206@suse.de> <alpine.LFD.2.00.1008022022560.27107@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1008022022560.27107@localhost.localdomain>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Thomas.

On 08/02/2010 08:52 PM, Thomas Gleixner wrote:
>> Ooh, another reason is timer locality.  If timers are shared per desc,
>> they have much higher chance of being on the same processor.  Global
>> timers would be pretty bad in that respect.
> 
> That's irrelevant. If you need to poll an interrupt, then it does not
> matter at all whether you bounce some cache lines or not.
> 
> In fact we have two cases:
> 
>    1) An interrupt needs to be polled all the time. That sucks whether
>       the poll timer bounces a few cache lines or not.
> 
>    2) Polling an irq for some time. Either it works again after a
>       while, so your suckage is restricted to the poll period. If not
>       see #1

Hmm... for spurious and watch the above are true and if it were the
above two it would definitely make more sense to use per-purpose
global timers.  The problem is w/ expect tho.  It's supposed to be
used with normal hot paths, so expect/unexpect operations better be
low overhead and local.  I'll talk more about it in the other reply.

> And it's even less of an issue as the main users of this misfeature
> are laptops and desktop machines, where locality is not really that
> important. If an enterprise admin decides to ignore the fact that the
> hardware is flaky, then he does not care about the cache line bounces
> either.

These problems do happen on intel chipset machines and is something
which can be worked around with some effort.  Eh, let's talk on the
other reply.

Thanks.

-- 
tejun
