Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754982Ab0IJA7c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 20:59:32 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47814 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753659Ab0IJA7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 20:59:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:openpgp:content-type
         :content-transfer-encoding;
        b=aWkyGkKBXLqEcmvH0ehSLO4uNz+sXod+9ZekVYWthkfr6Vk2SVqFRVslGPiz72L6mb
         Ptv/G48PUgsbhz9UFvEZToFMWkCEI9xHeb5d1F0LcZwqJrZ/Pm89ZtSjIUouKQI7d4jx
         P8bymxh25w07o/gGItK7swsM5JwUGPpFfPzKc=
Message-ID: <4C8982EF.8030705@gmail.com>
Date: Fri, 10 Sep 2010 02:59:27 +0200
From: Artur Skawina <art.08.09@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9pre) Gecko/20100819 Lightning/1.0b2 Lanikai/3.1.3pre
MIME-Version: 1.0
To: Nix <nix@esperi.org.uk>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Venkatesh Pallipadi <venki@google.com>,
        Damien Wyart <damien.wyart@free.fr>,
        John Drescher <drescherjm@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [BISECTED] 2.6.35.*: horrible (exponential? >linear) slowdown
 to unusability (HPET)
References: <87zkvx2ese.fsf@spindle.srvr.nix>	<20100906053255.GA23340@brouette> <87iq2gyllg.fsf@spindle.srvr.nix> <87wrqu8s1u.fsf_-_@spindle.srvr.nix>
In-Reply-To: <87wrqu8s1u.fsf_-_@spindle.srvr.nix>
X-Enigmail-Version: 1.1.1
OpenPGP: id=DDEB1C43
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/10 00:34, Nix wrote:
> It did: I found a system on which the fault was consistently
> reproducible. Bisected.
> 
> The horrible slowdowns some people are experiencing in 2.6.35 are *not*
> a result of bootmem interfering with the scheduler. They are a result of
> an HPET patch, specifically, this one:
> 
> commit 30a564be9d9554c168a654eddc2165869cc0d7bf
> Author: Thomas Gleixner <tglx@linutronix.de>
> Date:   Tue Apr 13 15:31:36 2010 +0200
> 
>     x86, hpet: Restrict read back to affected ATI chipsets

> On (at least) my ICH10 motherboard (a Tyan S7010), running this commit
> (or later) without hpet=verbose leads to one of two behaviours depending
> on whether or not CONFIG_NO_HZ is on. (This system is using HPET timers
> rather than the TSC even though it is a constant_tsc system, because it
> is an always-on headless server and I wanted it to spend as much time in
> C3 as possible. Why, yes, bisecting a bug on an always-on headless
> server with a dozen client systems *was* a complete pig, why do you
> ask?)

I'm seeing this too, except here it happens every couple of days of uptime,
lasts for a few minutes, and then goes away. Which made bisecting a bit
impractical... Thank you for doing it. 
HW is similar; x64 and X58/82801JI/ICH10, tsc clocksrc.
Did that printk trigger? Empirically confirming that this is the problem
could take weeks here, as it happens so rarely...

artur
