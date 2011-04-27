Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759950Ab1D0TxM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 15:53:12 -0400
Received: from 1wt.eu ([62.212.114.60]:35271 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759896Ab1D0TxK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 15:53:10 -0400
Date: Wed, 27 Apr 2011 21:52:53 +0200
From: Willy Tarreau <w@1wt.eu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        stable@kernel.org, stable-review@kernel.org,
        Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 090/173] USB: serial/kobil_sct, fix potential tty NULL dereference
Message-ID: <20110427195253.GI19594@1wt.eu>
References: <20110425200236.905912775@pcw.home.local> <4DB6994B.3060204@suse.cz> <20110426195342.GB19594@1wt.eu> <4DB740A3.4090702@suse.cz> <20110427102903.62b2ae09@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110427102903.62b2ae09@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

On Wed, Apr 27, 2011 at 10:29:03AM +0100, Alan Cox wrote:
> I'm not sure why a .27 is still maintained to be honest

[OT]

Well, just like 2.4, because there are (a few, but real) users who depend
on it. 2.6.27 was released just 2.5 years ago. There are many places where
servers are deployed to run more than 3 years. With 2.6.32 getting more
reliable nowadays, we could expect to see people deploying it now with
the hope that their servers will still be maintained in 3 years, and we'll
have this discussion again.

[/OT]

> but the reality
> is that the lack of tty refcounting on hangup in old kernels is
> exploitable in many cases via vhangup() and other approaches combined
> with lack of NULL page protection. In several places NULL tty means
> NULL->method() is invoked which on an old kernel where a user process has
> mapped user virtual address zero means you just got owned.

I completely agree with this. This is why I first thought this patch
alone was suitable. However in 2.6.27, DEFAULT_MMAP_MIN_ADDR is set
by default, which substantially reduces the risk.

> This is all well known stuff. SELinux will mitigate fairly effectively on
> some vendors systems.
> 
> Alan

Regards,
Willy

