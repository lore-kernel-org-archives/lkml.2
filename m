Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933389Ab0HLKYz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 06:24:55 -0400
Received: from mail09.linbit.com ([212.69.161.110]:46096 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933334Ab0HLKYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 06:24:53 -0400
Date: Thu, 12 Aug 2010 12:24:51 +0200
From: Lars Ellenberg <lars.ellenberg@linbit.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Philipp Reisner <philipp.reisner@linbit.com>, linux-kernel@vger.kernel.org,
        stable@kernel.org, Jens Axboe <jaxboe@fusionio.com>,
        stable-review@kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Greg KH <gregkh@suse.de>
Subject: Re: [Stable-review] [38/67] drbd: Disable delay probes for the
 upcomming release
Message-ID: <20100812102451.GA29878@barkeeper1-xen.linbit>
References: <20100812000616.181969463@clark.site>
 <1281582902.7543.513.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281582902.7543.513.camel@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 12, 2010 at 04:15:02AM +0100, Ben Hutchings wrote:
> On Wed, 2010-08-11 at 17:05 -0700, Greg KH wrote:
> > 2.6.35-stable review patch.  If anyone has any objections, please let us know.
> > 
> > ------------------
> > 
> > From: Philipp Reisner <philipp.reisner@linbit.com>
> > 
> > commit 6710a5760355be8f2e51682f41b0d3fc76550309 upstream.
> > 
> > Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
> > Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
> > Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> [...]
> 
> Anyone want to explain why this is important?

The receiving side implementation of this "delay probe" feature
has potential to stall the DRBD resync process under certain ill
circumstances.  Thus we rather not send the delay probes in the first
place.  The feature has been reverted upstream, and is being replaced.

> Similarly "drbd: Initialize all members of sync_conf to their defaults
> [Bugz 315]"; I assume that some Bugzilla entry would tell me, only I
> have no idea where it is.

If it so happened that these defaults have not been set, and no explicit
value assigned either, and then later a delay probe is received (which,
if no one sends one, can no longer be the case), it could lead to a
division by zero in kernel space :(

You'd have to misuse drbd userland to get there, but you could.

> These commit messages *suck*.

We'll try to make them suck less.

	Lars
