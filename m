Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756671Ab1IJBR1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 21:17:27 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:45967 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756132Ab1IJBRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 21:17:25 -0400
X-Sasl-enc: tN0HAAwIIRK1IIwWSDedm3KgcY4UQEJ3EtFAP5w1OS1T 1315617445
Date: Fri, 9 Sep 2011 22:17:21 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: jyothi v <jyos.v.s@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: hw rng
Message-ID: <20110910011720.GA10111@khazad-dum.debian.net>
References: <CAF5Aa4NMjB6H0g=reJKW2xPUg=M_x5vc5DbdhzvXcnznKvePFw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF5Aa4NMjB6H0g=reJKW2xPUg=M_x5vc5DbdhzvXcnznKvePFw@mail.gmail.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 09 Sep 2011, jyothi v wrote:
> Linux provides hardware random registry.
> I would like to know how is it useful.

You use something like this:
http://packages.debian.org/search?keywords=rng-tools

to deal with the entropy from the TRNG (/dev/hw_random) and feed it back to
the kernel, so that it becomes available to the rest of the system (the
kernel itself, and any normal randomness users that get it from /dev/random
and /dev/urandom).

Some hardware RNGs don't use /dev/hw_random, and require specific userspace
drivers instead of rng-tools.

> Is there any RNG system calls/APIs for generating random numbers at
> Linux user space?

There are some book-keeping ioctl() for /dev/random, which stuff like
rng-tools needs to use to feed entropy back to the kernel and to gauge the
amount of entropy the kernel has. 

But to _read_ random data, you just do direct reads from /dev/random or
/dev/urandom.

> If I need random data at user space application, what should I do?

Read it from /dev/urandom if your userspace application would rather receive
the output of a kernel-shielded CRNG when system entropy is low instead of
blocking.  Otherwise, read it from /dev/random, which will block when system
entropy is too low to service the read request.

And get something like this if you will need too much high-quality random
data, or will need high-quality random data from a system that doesn't have
much keyboard and disk activity: http://www.entropykey.co.uk/

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
