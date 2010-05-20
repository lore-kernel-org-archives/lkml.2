Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647Ab0ETRDg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 13:03:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33782 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754580Ab0ETRDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 13:03:34 -0400
Date: Thu, 20 May 2010 10:01:09 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jiri Kosina <jkosina@suse.cz>
cc: Don Prince <dhprince-devel@yahoo.co.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT] HID
In-Reply-To: <alpine.LNX.2.00.1005201834190.28092@pobox.suse.cz>
Message-ID: <alpine.LFD.2.00.1005200948210.23538@i5.linux-foundation.org>
References: <alpine.LNX.2.00.1005191430370.28092@pobox.suse.cz> <alpine.LFD.2.00.1005200912540.23538@i5.linux-foundation.org> <alpine.LFD.2.00.1005200922020.23538@i5.linux-foundation.org> <alpine.LNX.2.00.1005201834190.28092@pobox.suse.cz>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 20 May 2010, Jiri Kosina wrote:
> 
> Originally, all the quirks were sprinkled all over the generic code, 
> making it unmaintainable mess. Then the quirks for paricular 
> devices/device groups were separated into idividual drivers, which meant 
> quite a few new config options.

I _entirely_ agree with splitting up quirks. There's nothing wrong with 
that.

However, what is wrong is when those quirks then become
 (a) fairly big drivers (ie not just one-liner "this has an extra button" 
     kind of things)
 (b) are enabled for default
AND
 (c) are for devices that are so rare that almost nobody cares.

We do use that "enable automatically for non-embedded", but we use it for 
common stuff, and for stuff that we _historically_ used to support. Not 
for new random drivers.

> Other larger drivers, which actually implement something substantial and 
> have non-trivial code size impact, are added as a normal config options.

Well, I look at something like "hid-ortec.c", and it has basically a few 
lines of code, much of it __init, and I say "ok, that makes sense to not 
even ask about".

So I can see your argument. That said, I've never even _heard_ of ortek. 
Maybe it's some common chip and I use it every day. But even for something 
that small, I'd wonder how common they really are.

So that kensington driver is a good example of something where I do think 
it makes sense to make it default. It's small, and kensington is a big 
name.

But when the driver is several hundred lines, and the text size is 
probably in the kilobytes (I didn't compile that new driver, but even the 
trivial ones are a few hundred bytes) _and_ the driver is for something 
I've never even heard about, then I really think it shouldn't be enabled 
without asking.

			Linus
