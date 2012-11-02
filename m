Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759313Ab2KBQsi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 12:48:38 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:51890 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758988Ab2KBQsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 12:48:35 -0400
Date: Fri, 2 Nov 2012 09:48:28 -0700
From: Tejun Heo <tj@kernel.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Ric Wheeler <rwheeler@redhat.com>,
        Petr Matousek <pmatouse@redhat.com>, Kay Sievers <kay@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: Re: setting up CDB filters in udev (was Re: [PATCH v2 0/3] block:
 add queue-private command filter, editable via sysfs)
Message-ID: <20121102164828.GA3823@mtj.dyndns.org>
References: <20121025180045.GL11442@htj.dyndns.org>
 <1657557410.1945557.1351190120407.JavaMail.root@redhat.com>
 <20121031212241.GZ2945@htj.dyndns.org>
 <5093DD5E.6030808@redhat.com>
 <20121102153530.483453c7@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121102153530.483453c7@pyramind.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Alan, Paolo.

On Fri, Nov 02, 2012 at 03:35:30PM +0000, Alan Cox wrote:
> > >> That would be a change with respect to what we have now.  After
> > >> transferring a root-opened (better: CAP_SYS_RAWIO-opened) file
> > >> descriptor to an unprivileged process your SG_IO commands get
> > >> filtered.  So a ioctl is needed if you want to rely on SCM_RIGHTS.
> > > 
> > > Yeah, I get that it's a behavior change, but would that be a problem?
> > 
> > Worse, it's a potential security hole because previously you'd get
> > filtering and now you wouldn't.
> > 
> > Considering that SCM_RIGHTS is usually used to transfer a file
> > descriptor from a privileged process to an unprivileged one, I'd be very
> > worried of that.
> 
> In other contexts you inherit file handles via exec and having a "root
> opened so its special" model is bad. Historically it led to things like
> the rlogin/rsh hacks on SunOS and friends where a program run by the rsh
> daemon got a root opened socket as its stdin/out and could issue ifconfig
> ioctls on it at will.
> 
> Not a good model. Any removal of filters and passing them to a task
> should be explicit. The behaviour really ought to be to permit the
> intentional setting of explicit filters then passing them, not touch the
> default behaviour.

Yeah, well, then I guess it'll have to be a separate ioctl to switch
SG_IO for !root users.

Thanks.

-- 
tejun
