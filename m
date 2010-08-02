Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755347Ab0HBVIh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 17:08:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:33621 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751076Ab0HBVIf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 17:08:35 -0400
X-User-Agent: K-9 Mail for Android
References: <4C5033D9.7030800@kernel.org> <4C50349F.7020002@suse.de> <alpine.LFD.2.00.1007291042441.2471@localhost.localdomain> <4C529F59.3020404@suse.de> <alpine.LFD.2.00.1008020956080.9198@localhost.localdomain> <4C56E42D.5010300@suse.de> <4C56E5C7.90206@suse.de> <alpine.LFD.2.00.1008022022560.27107@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1008022022560.27107@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: Re: [GIT PULL tip/genirq] Please pull from lost-spurious-irq
From: Tejun Heo <tj@kernel.org>
Date: Mon, 02 Aug 2010 23:06:57 +0200
To: Thomas Gleixner <tglx@linutronix.de>
CC: lkml <linux-kernel@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>,
        Greg KH <gregkh@suse.de>
Message-ID: <07f0ab73-7a5e-45c3-b2a8-cff745dc6bc7@email.android.com>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 02 Aug 2010 21:08:17 +0000 (UTC)
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


-- 
tejun
