Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752931Ab1JBO6z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 10:58:55 -0400
Received: from usmamail.tilera.com ([206.83.70.75]:40385 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701Ab1JBO6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 10:58:51 -0400
Message-ID: <4E887C23.4030600@tilera.com>
Date: Sun, 2 Oct 2011 10:58:43 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Gilad Ben-Yossef <gilad@benyossef.com>
CC: <linux-kernel@vger.kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, <linux-mm@kvack.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH 0/5] Reduce cross CPU IPI interference
References: <1316940890-24138-1-git-send-email-gilad@benyossef.com> <4E831A79.1030402@tilera.com> <CAOtvUMdGeBfbLpSqonzLTT6+JUiabDjBG5bpd1_RPykt3x+5Hw@mail.gmail.com>
In-Reply-To: <CAOtvUMdGeBfbLpSqonzLTT6+JUiabDjBG5bpd1_RPykt3x+5Hw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/2/2011 4:44 AM, Gilad Ben-Yossef wrote:
>> We have some code in our tree (not yet
>> returned to the community) that tries to deal with some sources of interrupt
>> jitter on tiles that are running isolcpu and want to be 100% in user space.
> Yes, I think this work will benefit this kind of use case (CPU/user
> space bound on a dedicated CPU)
> the most, although other use cases can benefit as well (e.g. power
> management with idle cores).
>
> Btw, do you have any plan to share the patches you mentioned? it could
> save me a lot of time. Not wanting to
> re-invent the wheel and all that...

I'd like to, but getting the patch put together cleanly is still on my list
behind a number of other things (glibc community return, kernel catch-up
with a backlog of less controversial changes, customer crises, enhancements
targeted to forthcoming releases, etc.; I'm sure you know the drill...)

>>> This first version creates an on_each_cpu_mask infrastructure API (derived
>>> from
>>> existing arch specific versions in Tile and Arm) and uses it to turn two
>>> global
>>> IPI invocation to per CPU group invocations.
>> The global version looks fine; I would probably make on_each_cpu() an inline
>> in the !SMP case now that you are (correctly, I suspect) disabling
>> interrupts when calling the function.
>>
> Good point. Will do.
>
> I will take this email as an ACK to the tile relevant changes, if that
> is OK with you.

Yes, definitely.

Acked-by: Chris Metcalf <cmetcalf@tilera.com>

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

