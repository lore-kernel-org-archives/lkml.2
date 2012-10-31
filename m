Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935459Ab2JaVWr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 17:22:47 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:53197 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933351Ab2JaVWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 17:22:46 -0400
Date: Wed, 31 Oct 2012 14:22:41 -0700
From: Tejun Heo <tj@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Ric Wheeler <rwheeler@redhat.com>, Petr Matousek <pmatouse@redhat.com>,
        Kay Sievers <kay@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: Re: setting up CDB filters in udev (was Re: [PATCH v2 0/3] block:
 add queue-private command filter, editable via sysfs)
Message-ID: <20121031212241.GZ2945@htj.dyndns.org>
References: <20121025180045.GL11442@htj.dyndns.org>
 <1657557410.1945557.1351190120407.JavaMail.root@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1657557410.1945557.1351190120407.JavaMail.root@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Paolo.

On Thu, Oct 25, 2012 at 02:35:20PM -0400, Paolo Bonzini wrote:
> > Disabling filters if opened by root and tranfering via SCM_RIGHTS
> > would be the simplest interface-wise (there's no new interface at
> > all).  Would that be too dangerous security-wise?
> 
> That would be a change with respect to what we have now.  After
> transferring a root-opened (better: CAP_SYS_RAWIO-opened) file
> descriptor to an unprivileged process your SG_IO commands get
> filtered.  So a ioctl is needed if you want to rely on SCM_RIGHTS.

Yeah, I get that it's a behavior change, but would that be a problem?

> > I guess I just feel quite reluctant to expose another rather obscure
> > userland configurable in-kernel filter and at the same time I'm not
> > sure whether this is flexible enough.  What if a device is shared by
> > multiple virtual machines which are trusted at different levels?
> 
> No, you just don't do that.  If a device is passed through to virtual
> machines, it is between similar virtual machines (for some definition
> of similar).  The only case where you have this sharing is in practice
> if either the device is read-only (my patch does give you a basic
> two-level filtering, with two separate bitmaps for RO and RW) or if you
> allow persistent reservations (which is as close to full trust as you
> can get).

What disturbs me is that it's a completely new interface to userland
and at the same a very limited one at that.  So, yeah, it's
bothersome.  I personally would prefer SCM_RIGHTS behavior change +
hard coded filters per device class.

But, I'd really like to hear what other guys are thinking.  Jens?
Jens? Jens? Jens? Jens? Jens? Jens? Jens? Jens? Jens? Jens? Jens? :P

Thanks.

-- 
tejun
