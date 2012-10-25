Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759673Ab2JYSAw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 14:00:52 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:65109 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759509Ab2JYSAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 14:00:49 -0400
Date: Thu, 25 Oct 2012 11:00:45 -0700
From: Tejun Heo <tj@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Ric Wheeler <rwheeler@redhat.com>, Petr Matousek <pmatouse@redhat.com>,
        Kay Sievers <kay@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: Re: setting up CDB filters in udev (was Re: [PATCH v2 0/3] block:
 add queue-private command filter, editable via sysfs)
Message-ID: <20121025180045.GL11442@htj.dyndns.org>
References: <1954562860.13360801.1350637629926.JavaMail.root@redhat.com>
 <2007908429.13363375.1350637872646.JavaMail.root@redhat.com>
 <20121019201058.GP13370@google.com>
 <5087E093.50700@redhat.com>
 <CAOS58YM5ZO9h0XUCNxV+6U3UzpeUen5ZuyqsNEUaJ81ux=QKvw@mail.gmail.com>
 <5088EC43.2010600@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5088EC43.2010600@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(restoring cc lists)

Hey, Paolo.

On Thu, Oct 25, 2012 at 09:37:39AM +0200, Paolo Bonzini wrote:
> Il 24/10/2012 18:47, Tejun Heo ha scritto:
> > So, I'm still not convinced we need to go forward with full
> > configurability. All use cases you described can be covered with
> > per-class static filters + simple override switch to disable all,
> > which would result in a lot simpler implementation w/ much smaller
> > userland interface.
> 
> I'm not sure the userland interface would be smaller, and it would be
> more complex to get right:
> 
> 1) how do you override the default?  ioctl+SCM_RIGHTS or sysfs?

Disabling filters if opened by root and tranfering via SCM_RIGHTS
would be the simplest interface-wise (there's no new interface at
all).  Would that be too dangerous security-wise?

> 2) do you need to override the default to "no access", "full access" and
> "default access", or is a binary knob (default access/full access)
> sufficient?

Default / full should be enough, no?

> 3) what capabilities control the setting?

CAP_SYS_RAWIO seems to be a pretty good fit.

> > What's the rationale for full configurability?
> 
> Depending on the level of trust you have in your users, there are
> different policies that are applicable.  Even virtualization could have
> a range of choices like "permit only standard operations", "also permit
> UNMAP", "also permit persistent reservations", "permit everything
> including vendor specific commands"

I guess I just feel quite reluctant to expose another rather obscure
userland configurable in-kernel filter and at the same time I'm not
sure whether this is flexible enough.  What if a device is shared by
multiple virtual machines which are trusted at different levels?  What
if we end up actually having to filter cdb contents?

I'm not trying to block it at all cost but let's make sure we looked
into most possibilities before (re)adding this userland visible
interface.

Jens, James, what do you guys think?

Thanks.

-- 
tejun
