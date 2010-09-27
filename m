Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933358Ab0I0SbF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 14:31:05 -0400
Received: from a.mail.sonic.net ([64.142.16.245]:33691 "EHLO a.mail.sonic.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932448Ab0I0SbE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 14:31:04 -0400
X-Greylist: delayed 1509 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 Sep 2010 14:31:03 EDT
Message-ID: <4CA0DCDE.5030401@twiddle.net>
Date: Mon, 27 Sep 2010 11:05:18 -0700
From: Richard Henderson <rth@twiddle.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        Matt Turner <mattst88@gmail.com>
Subject: Re: alpha: potential race around hae_cache in RESTORE_ALL
References: <20100925181304.GV19804@ZenIV.linux.org.uk> <AANLkTi=XURM0hOiitvNSiacd9+7Vx8s7V0KZ+oZQsDDQ@mail.gmail.com> <20100925191836.GW19804@ZenIV.linux.org.uk> <20100925192509.GX19804@ZenIV.linux.org.uk> <20100927075828.GA15344@jurassic.park.msu.ru> <20100927121227.GB19804@ZenIV.linux.org.uk> <20100927124624.GC19804@ZenIV.linux.org.uk> <20100927162610.GA18373@jurassic.park.msu.ru> <AANLkTimjep+H2VDJC1sFvT52XPmiKgMHuRBirzNm6qnL@mail.gmail.com>
In-Reply-To: <AANLkTimjep+H2VDJC1sFvT52XPmiKgMHuRBirzNm6qnL@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/27/2010 10:10 AM, Linus Torvalds wrote:
> On Mon, Sep 27, 2010 at 9:26 AM, Ivan Kokshaysky
> <ink@jurassic.park.msu.ru> wrote:
>>
>> Looks like we need to drop HAE bits from SAVE_ALL/RESTORE_ALL, which
>> benefits (1) and automatically fixes (3), and do the entire IO sequences
>> in (2) with disabled interrupts (if HAE is involved).
> 
> No can do.
> 
> HAE is used in user space too (the X server), and it depends on the
> kernel restoring HAE over interrupts and system calls, afaik.
> 
> I'm also pretty certain that all SMP machines either don't have HAE at
> all, or have a per-CPU HAE in hardware (and then it's possible that we
> screw it up in software, of course). Anything else would be too broken
> for words. Can somebody find documentation saying otherwise?

I'm pretty sure T2 is too broken for words, and RAWHIDE has
wide enough HAE that we can get away with leaving it at
defaults most of the time.

That said, I'm pretty sure I've never heard of anyone trying
T2 that wasn't at DEC.  I'm pretty sure if we deleted it, no
one would notice.

But all the respectable smp hardware doesn't use the HAE.


r~
