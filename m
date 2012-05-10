Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761739Ab2EJWDL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 18:03:11 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61112 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756988Ab2EJWDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 18:03:09 -0400
Date: Thu, 10 May 2012 15:03:04 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: David Miller <davem@davemloft.net>
Cc: alexander.h.duyck@intel.com, jrnieder@gmail.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, stephen.s.ko@intel.com,
        jeffrey.t.kirsher@intel.com
Subject: Re: [ 33/52] net: Fix issue with netdev_tx_reset_queue not resetting
 queue from XOFF state
Message-ID: <20120510220304.GA10166@kroah.com>
References: <20120510.145510.1040533529305157641.davem@davemloft.net>
 <20120510194658.GA9858@burratino>
 <4FAC26A5.3050606@intel.com>
 <20120510.165120.1054985033661946116.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120510.165120.1054985033661946116.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2012 at 04:51:20PM -0400, David Miller wrote:
> From: Alexander Duyck <alexander.h.duyck@intel.com>
> Date: Thu, 10 May 2012 13:35:49 -0700
> 
> > On 05/10/2012 12:46 PM, Jonathan Nieder wrote:
> >> David Miller wrote:
> >>> From: Alexander Duyck <alexander.h.duyck@intel.com>
> >>>> All of the changes in igb are unnecessary.  I think they can be dropped
> >>>> from the patch as they have already been reverted from the latest
> >>>> net-next.  The only change that is really needed is the piece in
> >>>> netdevice.h below.
> >>> Does it hurt?  If not, just let it be.
> >> Based on the commit description for dad8a3b3eaa0 ("igb, ixgbe:
> >> netdev_tx_reset_queue incorrectly called from tx init path"), yes, it
> >> hurts.  I don't know if it hurts enough to justify holding up this
> >> patch until dad8a3b3eaa0 hits mainline.
> >>
> >> |                            this sort of works in most cases except
> >> | when the number of real tx queues changes. When the number of real
> >> | tx queues changes netdev_tx_reset_queue() only gets called on the
> >> | new number of queues so when we reduce the number of queues we risk
> >> | triggering the watchdog timer and repeated device resets.
> >> |
> >> | So this is not only a cosmetic issue but causes real bugs. For
> >> | example enabling/disabling DCB or FCoE in ixgbe will trigger this.
> > I'm fairly certain we really shouldn't make the changes to igb.  I would
> > say to just modify the existing patch by just dropping the igb portion
> > of it and it would be fine.
> 
> Ok, Greg, could you do me a huge favor and simply trim the IGB driver
> changes from this patch and just keep the linux/netdevice.h part?

Now done, thanks for letting me know.

greg k-h
