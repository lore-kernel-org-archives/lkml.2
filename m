Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755051Ab1DTOeI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 10:34:08 -0400
Received: from kroah.org ([198.145.64.141]:43683 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753379Ab1DTOeD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 10:34:03 -0400
Date: Wed, 20 Apr 2011 07:34:35 -0700
From: Greg KH <greg@kroah.com>
To: Amit Shah <amit.shah@redhat.com>
Cc: Milton Miller <miltonm@bga.com>, Rusty Russell <rusty@rustcorp.com.au>,
        linux-kernel@vger.kernel.org, benh@kernel.crashing.org,
        linuxppc-dev@ozlabs.org
Subject: Re: hvc_console: Don't access hvc_task if not initialised
Message-ID: <20110420143435.GB22436@kroah.com>
References: <df8ea6d65c1ceeb25b0a3fdfc66995b8a8273ea5.1300951793.git.amit.shah@redhat.com>
 <hvc-kick-notask@mdm.bga.com>
 <20110325084714.GA28356@amit-x200.redhat.com>
 <hvc-kick-notask-2@mdm.bga.com>
 <20110420123330.GB3519@amit-x200.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110420123330.GB3519@amit-x200.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 20, 2011 at 06:03:30PM +0530, Amit Shah wrote:
> On (Mon) 28 Mar 2011 [11:52:05], Milton Miller wrote:
> > On Fri, 25 Mar 2011 about 14:17:14 +0530, Amit Shah wrote:
> > > On (Thu) 24 Mar 2011 [08:58:04], Milton Miller wrote:
> > > > On Thu, 24 Mar 2011 07:29:58 -0000, Amit Shah wrote:
> > > > > hvc_open() can be called without having any backing device.  This
> > > > > results in a call to hvc_kick() which calls wake_up_process on a NULL
> > > > > pointer.  
> > > > 
> > > > How is hvc_open called without a hvc_driver registered to the tty layer?
> > > 
> > > This gets reproduced in a couple of scenarios, I'm trying to get more
> > > information.
> 
> OK - I finally could reproduce myself, albiet it's a panic in
> hvc_open, not the one mentioned earlier.
> 
> hvc_console is built into the kernel and virtio_console is a module.
> This sequence triggers a panic:
> 
> - modprobe virtio_console
> - agetty /dev/hvc0 9600 vt100
> - rmmod virtio_console
> - modprobe virtio_console
> - agetty /dev/hvc0 9600 vt100
> 
> A patch that I had sent previously, to hvc_remove() a port when the
> associated virtio_console port gets unplugged, fixes this panic.
> 
> Stricter checking in hvc_open(), as you mentioned, will solve the
> other one as well.

Care to either create this patch, or resend your original one, if you
want it applied?

thanks,

greg k-h
