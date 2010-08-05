Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759611Ab0HECAG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 22:00:06 -0400
Received: from gate.crashing.org ([63.228.1.57]:36511 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759439Ab0HECAB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 22:00:01 -0400
Subject: Re: [PATCH 1/3] Input: sysrq - drop tty argument from sysrq ops
 handlers
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Airlie <airlied@linux.ie>,
        David Miller <davem@davemloft.net>, Fenghua Yu <fenghua.yu@intel.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Russell King <linux@arm.linux.org.uk>, Tony Luck <tony.luck@intel.com>
In-Reply-To: <20100804100926.3f24f5e5@lxorguk.ukuu.org.uk>
References: <20100804075602.30647.91462.stgit@localhost.localdomain>
	 <20100804075900.30647.46910.stgit@localhost.localdomain>
	 <1280910830.1902.144.camel@pasglop>
	 <20100804100926.3f24f5e5@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 05 Aug 2010 11:59:24 +1000
Message-ID: <1280973564.1902.166.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-08-04 at 10:09 +0100, Alan Cox wrote:
> 
> Fundamentally - no. However the impact it has on a lot of the drivers
> will be significant and you'll be submitting a huge patch pile to fix up
> all the locking assumptions (for one it means port->tty might change
> across any call that ends up in sysrq)

Right. That's nasty. I think we need somewhat to break the loop when
that happens as if we were getting a new interrupt to some extent.

And that's a lot of drivers to fix.

> > serial drivers might need to be audited a bit to make sure they cope
> > with the lock being dropped and re-acquired around the sysrq call.
> 
> Architecturally I think it would make more sense to add a new sysrq
> helper which merely sets a flag, and check that flag at the end of the IRQ
> when dropping the lock anyway.

Interesting idea. That does mean that multiple sysrq in one interrupt
will be coalesced but I don't see that as an issue.

> Otherwise it'll be a huge amount of work to even build test all those
> consoles.

Right. Better to have a way where we can fix them one at a time. I'll
look into it. Thanks.

Cheers,
Ben.


