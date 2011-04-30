Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755639Ab1D3Cp1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 22:45:27 -0400
Received: from oproxy5-pub.bluehost.com ([67.222.39.38]:39235 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751897Ab1D3Cp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 22:45:26 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=L9+0jjdflaU2r9xpbjb2Y+Zq6ld9oZTjXYDHWS1FQ4DYI+2RyByRjUmWcd4lc3tZxf8uCjWanTHfoxIqd7bOWmzHTPXE22bEywIKsafyojLPa8UPrd59J0m/4mmnwENp;
Date: Fri, 29 Apr 2011 19:45:20 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Thomas Hellstrom <thellstrom@vmware.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        linaro-mm-sig@lists.linaro.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [Linaro-mm-sig] [RFC] ARM DMA mapping TODO, v1
Message-ID: <20110429194520.14a8cce5@jbarnes-desktop>
In-Reply-To: <1304117214.2513.262.camel@pasglop>
References: <201104212129.17013.arnd@arndb.de>
	<201104281428.56780.arnd@arndb.de>
	<20110428131531.GK17290@n2100.arm.linux.org.uk>
	<201104281629.52863.arnd@arndb.de>
	<20110428143440.GP17290@n2100.arm.linux.org.uk>
	<BANLkTinhm7ar1mf1D-dSMiLtw5hRNY36RA@mail.gmail.com>
	<1304036962.2513.202.camel@pasglop>
	<4DBA5194.7080609@vmware.com>
	<1304062523.2513.235.camel@pasglop>
	<20110429092712.5bbd6948@jbarnes-desktop>
	<1304117214.2513.262.camel@pasglop>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 Apr 2011 08:46:54 +1000
Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> > Ah if it were that simple. :)  There are big costs to implementing full
> > coherency for all your devices, as you well know, so it's just not a
> > question of benchmark optimization.  
> 
> But it -is- that simple.
> 
> You do have to deal with coherency anyways for your PHB unless you start
> advocating that we should make everything else non coherent as well. So
> you have the logic. Just make your GPU operate on the same protocol.
> 
> It's really only a perf tradeoff I believe. And a bad one.

Ok so I was the one oversimplifying. :)  Yes, it's definitely doable to
make a cache coherent PHB, and is awfully nice from a perf and
programming perspective.

But as you say, to make a high performance one for things like gfx, or
even to handle things like atomic ops, adds a lot of expense (in the
case of graphics, a whole lot unless you can integrate with the CPU,
and even then display can be tough to deal with).

I don't see even good coherent implementations being good enough for
high perf graphics in the near term (though at least on relatively high
power designs like Sandy Bridge we're getting close) so we'll have to
solve the uncached and simultaneous mapping issue both for today's
hardware and the near future.

-- 
Jesse Barnes, Intel Open Source Technology Center
