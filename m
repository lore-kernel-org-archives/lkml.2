Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899Ab1FCJhs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 05:37:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53812 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753687Ab1FCJhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 05:37:47 -0400
MIME-Version: 1.0
In-Reply-To: <1307084189.23876.19.camel@pasglop>
References: <1306999045.29297.55.camel@pasglop> <1307003821.29297.77.camel@pasglop>
 <20110602110727.7343782b@lxorguk.ukuu.org.uk> <1307062574.29297.204.camel@pasglop>
 <1307081874.23876.14.camel@pasglop> <1307084189.23876.19.camel@pasglop>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 3 Jun 2011 18:36:54 +0900
Message-ID: <BANLkTim6VsynZHLagcu9Xo3EjsUz=54dYA@mail.gmail.com>
Subject: Re: tty breakage in X (Was: tty vs workqueue oddities)
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, gregkh@suse.de,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>, Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 3, 2011 at 3:56 PM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
>
> So I think my theory stands that flush_to_ldisc constantly reschedule
> itself causing the worker thread to eat all CPU and starve the consumer
> of the PTY. I won't have time to dig much deeper today nor probably this
> week-end so I'm sending this email for others who want to look.

Gaah - that commit is total and utter crap.

I *removed* the whole "reschedule the work queue again" crap. It was
totally wrong. See commit a5660b41af6a.

But then commit b1c43f82c5aa added the crap right back in.

So does it all work if you just remove the broken schedule_work() line
from flush_to_ldisc?

Otherwise we'll need to just revert it. The commit is clearly totally broken.

                    Linus
