Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754274Ab1FCA4l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 20:56:41 -0400
Received: from gate.crashing.org ([63.228.1.57]:41261 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752578Ab1FCA4k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 20:56:40 -0400
Subject: Re: tty breakage in X (Was: tty vs workqueue oddities)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: gregkh@suse.de,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20110602110727.7343782b@lxorguk.ukuu.org.uk>
References: <1306999045.29297.55.camel@pasglop>
	 <1307003821.29297.77.camel@pasglop>
	 <20110602110727.7343782b@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 03 Jun 2011 10:56:14 +1000
Message-ID: <1307062574.29297.204.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-02 at 11:07 +0100, Alan Cox wrote:
> On Thu, 02 Jun 2011 18:37:01 +1000
> Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:
> 
> > On Thu, 2011-06-02 at 17:17 +1000, Benjamin Herrenschmidt wrote:
> > > Hi Alan !
> > 
> > Hrm... looks like Alan is innocent ... interesting tho, the culprit
> > patch looks like something he (or somebody known to understand the tty
> > code :-) should have reviewed.
> 
> I did review it, and ran it and it worked beautifully on my system 8)
> 
> I do wonder if it has an interaction with Linus earlier changes to queue
> flushing as I've never tested both together.

I just noticed it doesn't happen (or if it does, it recovers fast enough
to not be noticable) on an SMP machine (dual G5). However, if I boot the
same machine with maxcpus=1, the problem is back. A simple "dmesg" in
gnome terminal shows it.

However, on that much faster machine, it also recovers a lot faster. On
the powerbook, it hangs a few minutes, on the G5 it hangs a few seconds.

I don't have the bandwidth to dive into the workqueue/tty before this
week-end, I'll give it a shot next week if nobody beats me to it.

Cheers,
Ben.

