Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751893Ab2KZFPr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 00:15:47 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:42665 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309Ab2KZFPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 00:15:46 -0500
Date: Mon, 26 Nov 2012 05:15:44 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, monstr@monstr.eu,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: sigaltstack fun
Message-ID: <20121126051544.GD4939@ZenIV.linux.org.uk>
References: <20121119011013.GJ16916@ZenIV.linux.org.uk>
 <20121118.203005.151867624663051294.davem@davemloft.net>
 <20121119023507.GK16916@ZenIV.linux.org.uk>
 <20121118.222724.1495808364736017374.davem@davemloft.net>
 <20121126051002.GB4939@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121126051002.GB4939@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 26, 2012 at 05:10:02AM +0000, Al Viro wrote:
> On Sun, Nov 18, 2012 at 10:27:24PM -0500, David Miller wrote:
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> > 
> > Applied, thanks.
> 
> Hmm...  There's something odd going on with {rt_,}sigaction on sparc -
> we *do* have sa_restorer in struct sigaction and struct old_sigaction,
> but it's not used for anything whatsoever.  There's also a separately
> passed restorer pointer for rt_sigaction() and *that* is used instead,
> but not reported via *oact.
> 
> What's the reason for that weirdness?  I understand why we do that on
> alpha (we have no sa_restorer in struct sigaction we'd inherited from
> OSF/1), but sparc always had perfectly normal sigaction->sa_restorer
> field all along - even for old sigaction(2)...

PS: speaking of weirdness, what's the reason for sparc and ppc (and nothing
else) expecting the first argument of sigaction(2) to be minus signal
number?  ABI archaeology is fun...
