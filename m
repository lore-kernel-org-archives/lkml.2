Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753048Ab1AAQTx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jan 2011 11:19:53 -0500
Received: from ist.d-labs.de ([213.239.218.44]:39937 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751227Ab1AAQTw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jan 2011 11:19:52 -0500
Date: Sat, 1 Jan 2011 17:19:46 +0100
From: Florian Mickler <florian@mickler.org>
To: Jeff Mahoney <jeffm@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Dan Carpenter <error27@gmail.com>, balbir@linux.vnet.ibm.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] taskstats: Use better ifdef for alignment
Message-ID: <20110101171946.6179c3b6@schatten.dmk.lab>
In-Reply-To: <4D1CAAA1.8030106@suse.com>
References: <4D1BCE58.4000902@suse.com>
	<20101229161418.d34bf0d4.akpm@linux-foundation.org>
	<4D1C180A.20000@suse.com>
	<20101229213243.891b0db5.akpm@linux-foundation.org>
	<4D1CAAA1.8030106@suse.com>
X-Mailer: Claws Mail 3.7.6cvs31 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Dec 2010 10:52:01 -0500
Jeff Mahoney <jeffm@suse.com> wrote:

> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> On 12/30/2010 12:32 AM, Andrew Morton wrote:
> > On Thu, 30 Dec 2010 00:26:34 -0500 Jeff Mahoney <jeffm@suse.com> wrote:
> > 
> >> On 12/29/2010 07:14 PM, Andrew Morton wrote:
> >>> On Wed, 29 Dec 2010 19:12:08 -0500 Jeff Mahoney <jeffm@suse.com> wrote:
> >>>
> >>>>  Commit 4be2c95d added a null field to align the taskstats structure but
> >>>>  the discussion centered around ia64. The issue exists on other platforms
> >>>>  with inefficient unaligned access and adding them piecemeal would be
> >>>>  an unmaintainable mess.
> >>>>
> >>>>  This patch uses Dave Miller's suggestion of using a combination of
> >>>>  CONFIG_64BIT && !CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS to determine
> >>>>  whether alignment is needed.
> >>>>
> >>>>  Note that this will cause breakage on those platforms with applications
> >>>>  like iotop which had hard-coded offsets into the packet to access the
> >>>>  taskstats structure.
> >>>
> >>> That seems a very good reason to not apply the patch.
> >>>
> >>> Tell us more, please...
> >>
> >> I don't want to rehash the same discussion
> > 
> > Please do so.  That discussion went on for a long time over many emails
> > and multiple iterations of the patch.  I personally have forgotten the
> > reasoning and if I could remember it, I wouldn't remember which version
> > of the patch it applied to.
> > 
> > Applying a patch which is *known* to break *known* userspace
> > applications is a quite extraordinary thing to do.  We owe it to people
> > to fully explain the reasoning.
> 
> Ok, so the gist is that iotop makes what I'd call unreasonable
> assumptions about the contents of a netlink genetlink packet containing
> generic attributes. 

Is there already a patch available or integrated into iotop which
fixes this? I'd think that if the kernel could wait on fixed iotop's to
be distributed it would be easier to sell the breakage on bugzilla &
co...

Just my 2 cents, but I don't know enough to weigh the different aspects
of this... iotop shurely is not a showstopper if the upsides of this
patch are big enough?

Regards,
Flo
