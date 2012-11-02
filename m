Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759533Ab2KBQvc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 12:51:32 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:39711 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759396Ab2KBQva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 12:51:30 -0400
Date: Fri, 2 Nov 2012 09:51:23 -0700
From: Tejun Heo <tj@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Ric Wheeler <rwheeler@redhat.com>, Petr Matousek <pmatouse@redhat.com>,
        Kay Sievers <kay@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: Re: setting up CDB filters in udev (was Re: [PATCH v2 0/3] block:
 add queue-private command filter, editable via sysfs)
Message-ID: <20121102165123.GB3823@mtj.dyndns.org>
References: <20121025180045.GL11442@htj.dyndns.org>
 <1657557410.1945557.1351190120407.JavaMail.root@redhat.com>
 <20121031212241.GZ2945@htj.dyndns.org>
 <5093DD5E.6030808@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5093DD5E.6030808@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Paolo.

On Fri, Nov 02, 2012 at 03:49:02PM +0100, Paolo Bonzini wrote:
> > Yeah, I get that it's a behavior change, but would that be a problem?
> 
> Worse, it's a potential security hole because previously you'd get
> filtering and now you wouldn't.
> 
> Considering that SCM_RIGHTS is usually used to transfer a file
> descriptor from a privileged process to an unprivileged one, I'd be very
> worried of that.

Yeah, I know it's a security thing, was wondering how bad it was.  So,
if we choose this, I guess we'll need an ioctl to switch userland
SG_IO filtering.

> > What disturbs me is that it's a completely new interface to userland
> > and at the same a very limited one at that.  So, yeah, it's
> > bothersome.  I personally would prefer SCM_RIGHTS behavior change +
> > hard coded filters per device class.
> 
> I think hard-coded filters are bad (I prefer to move policy to
> userspace), and SCM_RIGHTS without a ioctl is out of question, really.

No rule is really absolute.  To me, it seems the suggested in-kernel
per-device command code filter is both too big for the given problem
while being too limited for much beyond that.  So, if we can get away
with adding an ioctl, I personally think that would be a better
approach.

Thanks.

-- 
tejun
