Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290Ab2F1XLM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 19:11:12 -0400
Received: from icebox.esperi.org.uk ([81.187.191.129]:39563 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752282Ab2F1XKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 19:10:51 -0400
From: Nix <nix@esperi.org.uk>
To: Francois Romieu <romieu@fr.zoreil.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: 3.4.x regression: rtl8169: frequent resets
References: <87y5n7qup0.fsf@spindle.srvr.nix>
	<20120628193026.GA31627@electric-eye.fr.zoreil.com>
	<87fw9fp2e1.fsf@spindle.srvr.nix>
	<20120628222325.GA1579@electric-eye.fr.zoreil.com>
Emacs: the definitive fritterware.
Date: Fri, 29 Jun 2012 00:10:49 +0100
In-Reply-To: <20120628222325.GA1579@electric-eye.fr.zoreil.com> (Francois
	Romieu's message of "Fri, 29 Jun 2012 00:23:25 +0200")
Message-ID: <87bok3oww6.fsf@spindle.srvr.nix>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-DCC-INFN-TO-Metrics: spindle 1233; Body=3 Fuz1=3 Fuz2=3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 Jun 2012, Francois Romieu stated:

> Nix <nix@esperi.org.uk> :
>> Francois Romieu <romieu@fr.zoreil.com> :
>> > Can you try and revert 036dafa28da1e2565a8529de2ae663c37b7a0060 ?
>> 
>> I can try, but there's been a *lot* of code motion since then, 'git
>> revert' fails hilariously (trying to patch obviously the wrong places):
>> I'll have to do it by hand.
>
> There is a single line reject in rtl8169_start_xmit. Other than that it
> should patch -p1 -R fine.

... and indeed it does. Weird, why does git revert fail so badly when
patch and git apply are both happy?!

I'll reboot into this kernel tomorrow, and report back in a few days (or
sooner if it goes wrong).

>> [    1.341389] r8169 0000:06:00.0: eth0: jumbo features [frames: 6128 bytes, tx checksumming: ko]
>
> This chipset is not supposed to be pushed beyond 6128 bytes.

Interesting. It's always worked flawlessly at 7200 for me before, until,
uh, last year when it stopped working and I never noticed (in fact
a 7200-byte MTU was how the machine was shipped to me :) ).

I guess I'll knock it down to 6128 then, less than 1000 bytes isn't
going to ruin performance by any means...

... aand that works. thanks! (Let's see if the link stuttering continues. I
expect it will, though it's been three hours since the last stutter...)

-- 
NULL && (void)
