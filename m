Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756530Ab1F1E44 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 00:56:56 -0400
Received: from containermaster.com ([88.198.52.246]:33608 "EHLO
	containermaster-cmp.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756480Ab1F1EzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 00:55:15 -0400
X-Greylist: delayed 549 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 Jun 2011 00:55:14 EDT
Message-ID: <sig.11608c07e8.4E095C34.1020904@containermaster-cmp.de>
Date: Tue, 28 Jun 2011 06:44:36 +0200
From: Johann Meier <recv@containermaster-cmp.de>
User-Agent: SpamAssassin version 3.2.4
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: random(4) driver questions
References: <BANLkTinC7vfaRWf5TK9gJuQVtVwDkEQFcQ@mail.gmail.com> <20110627145442.GA2729@thunk.org>
In-Reply-To: <20110627145442.GA2729@thunk.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Assp-Client-SSL: yes
X-Assp-Passing: authenticated
X-Assp-ID: ASSP.nospam (30923-01606)
X-Assp-Version: 1.8.5.9(1.0.07)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/27/11 16:54, Ted Ts'o wrote:
> On Sat, Jun 25, 2011 at 01:51:07PM +0800, Sandy Harris wrote:
>> There was a paper some time back by a group of Israeli researchers
>> and looking at the Linux /dev/random driver, and claiming to find
>> it wanting in several ways. www.pinkas.net/PAPERS/gpr06.pdf
>>
>> To what extent have their objections been dealt with. If some
>> were considered bogus, is there documentation somewhere
>> explaining why?
> 
> Suffice it to say the random generator has changed significantly since
> 2006.  There is now a secondary pool, which uses catastrophic
> reseeding, etc.
> 
>> One problem they pointed out is that there may be little
>> entropy available on a Linux-based router; no keyboard or
>> mouse, solid state storage so no disk entropy, and an
>> enemy might observe network activity, so network
>> interrupts give little or no useful entropy.
> 
> Sure, but a Linux-based router shouldn't be doing crypto work.  If it
> *is* and it is important crypto work, then it needs a hardware random
> number generator.  There's no magic here.
> 
> If you don't want to pay the cost of a random number generator, you
> can do things such as at installation time, bootstrapping the random
> number generator with some cryptographically secure randomness
> available by the installation system.
> 
>> The only in-kernel solution I can think of would be
>> to add something in the system call interface to
>> make very system call throw timing information
>> into the pool. I very much doubt, though, that that
>> is a good idea. What do others think, and does
>> anyone have a better idea?
> 
> It won't hurt (aside from wasting CPU time, assuming you don't add any
> entropy credits), but won't necessarily help, either.
> 
>> What happens to /dev/random when it runs on
>> a virtual machine and all the things it relies on
>> for entropy get virtualised away?
>>
>> The server that the VM is hosted on will usually
>> have plenty of entropy, often a hardware RNG.
>> Is there an interface that makes that visible
>> from the VM? Perhaps a virtual "hardware"
>> RNG driven by /dev/urandom on the host?
> 
> Yes, paravirtualizing the random number generator would be a big help.
> Probably what I would do is to periodically add entropy from the host
> OS to the guest OS, via some paravirt channel.  This would add a new
> "catastrophic reseeding", and if the virtual guest can mix in some
> other unknown material, again that can only help.
> 
> 						- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

If you don't have a hardware rnd, you can use an entropy daemon like
haveged (http://www.issihosts.com/haveged/)
