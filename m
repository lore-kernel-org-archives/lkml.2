Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687Ab0GFPQB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 11:16:01 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41278 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752131Ab0GFPQA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 11:16:00 -0400
Date: Tue, 6 Jul 2010 08:14:54 -0700
From: Greg KH <gregkh@suse.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Luotao Fu <l.fu@pengutronix.de>, Alan Cox <alan@linux.intel.com>,
       linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: Problem with tty changes in linux-next
Message-ID: <20100706151454.GB12444@suse.de>
References: <20100706130403.GD3991@pengutronix.de>
 <201007061623.48363.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201007061623.48363.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 06, 2010 at 04:23:48PM +0200, Arnd Bergmann wrote:
> > 2. A more serious problem is that printing kernel message no more works
> > after running into userspace.
> > ....
> > Freeing init memory: 100K
> > 3sy||_|_|
> > phyCORE login:
> > ....
> > The boot message between init and login sheel is printed only
> > partly. The cursor jumps back and forward. It seems that part the
> > special characters like new line etc. are cutted away so that the
> > printout is shown in such a funny manner. After a tty is spawned, every
> > thing works just well. I can log in onto the system and it seems to work
> > so far. I bisected the kernel and identified eventually
> > fb11bee14186af87ee6abb833cf1a2a6be59c65b as the
> > first bad commit. The actual problem should be, however,
> > 36c621d82b956ff6ff72273f848af53e6c581aba, where tty_port_block_til_ready()
> > is introduced. Seems to me that there are locking problems. I
> > unfortunately don't have any insights of tty layer to tell where the
> > exact problem is.
> 
> I'm sorry you had to bisect this. I did the same bisect and already
> submitted a patch for this, which probably got stuck in Greg's inbox
> while he was preparing the stable releases. I can't find the patch
> in the archives now, which could also mean that it never left my local
> machine.
> 
> I have the patch on a different machine, but will resend it to Greg
> when I get there to make sure it doesn't get lost.

It's in my todo queue, sorry, I spent last week on the 5 stable kernel
releases, I should get to this today and push it into the next
linux-next release.

thanks,

greg k-h
