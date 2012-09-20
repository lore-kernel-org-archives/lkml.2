Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753377Ab2ITRt5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 13:49:57 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:56952 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577Ab2ITRtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 13:49:55 -0400
Date: Thu, 20 Sep 2012 13:49:53 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
cc: paulmck@linux.vnet.ibm.com, John Stultz <john.stultz@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: Re: RCU lockup in the SMP idle thread, help...
In-Reply-To: <CACRpkdaOG59CNvqUGFer+1TcVM8ovJwxmc3ZryJKw--PJ=bzsQ@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1209201056531.6667@xanadu.home>
References: <CACRpkdYgxsF1G7Dc_xCcQcFV9G+foz1czOCmROcMQ5NfR-ziCA@mail.gmail.com> <50520E8A.9030408@linaro.org> <20120913165844.GW4257@linux.vnet.ibm.com> <CACRpkdatjfk_eUof5G4fwa-Qf8SoF_NvSUJQAZ7U8yjcSYFuTA@mail.gmail.com> <20120914175322.GI4257@linux.vnet.ibm.com>
 <CACRpkdbw+VgaV26U6uZeKr9g28ax2shrieQSxFuj-Pi9RXPtLQ@mail.gmail.com> <20120920000313.GH2455@linux.vnet.ibm.com> <CACRpkdaOG59CNvqUGFer+1TcVM8ovJwxmc3ZryJKw--PJ=bzsQ@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Sep 2012, Linus Walleij wrote:

> On Thu, Sep 20, 2012 at 2:03 AM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> 
> > Any thoughts on the feasibility of implementing NMI-based stack backtraces
> > for ARM?
> 
> Nico's department, so let's page him.

That _could_ be done, at least in theory, with some restrictions.  

However in practice ...

> In IIRC ux500 all NMIs are reserved for the secure world, so it's
> basically a no can do. :-(

That's the main issue here: not all platforms allow FIQs ( a FIQ is the 
closest to a NMI on ARM) to be available to the operating system.

However, for where this is possible, there is a patch series from Anton 
Vorontsov implementing FIQ based KGDB support which might be useful 
here.


Nicolas
