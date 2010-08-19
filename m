Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285Ab0HSRyG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 13:54:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10214 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754235Ab0HSRyE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 13:54:04 -0400
Subject: Re: struct fanotify_event_metadata
From: Eric Paris <eparis@redhat.com>
To: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Cc: Andreas Schwab <schwab@linux-m68k.org>,
        Andreas Gruenbacher <agruen@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <201008191644.29299.tvrtko.ursulin@sophos.com>
References: <m21va1ozqx.fsf@igel.home>
	 <201008191644.29299.tvrtko.ursulin@sophos.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 19 Aug 2010 13:53:46 -0400
Message-ID: <1282240426.21419.1716.camel@acb20005.ipt.aol.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-08-19 at 16:44 +0100, Tvrtko Ursulin wrote:
> On Saturday 14 Aug 2010 18:44:38 Andreas Schwab wrote:
> > The pid field of struct fanotify_event_metadata has 64 bits which looks
> > excessive.  Wouldn't it make sense to make it 32 bits and swap it with
> > the mask field?  That would avoid the unaligned mask field, and remove
> > the need for the packed attribute.

Wish this thought came up 2 weeks ago  :)  It's going to stay __packed__
no matter what, even if the alignment works out nicely and it doesn't do
anything.

I'm certainly willing to shrink the pid and switch some locations if
noone objects but it will definitely break userspace, in that it is
going to require a recompile of anyone's userspace listener (the
interface was only intended to grow, not get switched around) but it has
only been in there about a week so I'm not seeing a huge harm.

I would not be happy to see the mask shrink, we might not be there yet,
we might not ever get there, but it was part of the future proofing of
the interface.

Would anyone like to send a patch? Tvrtko?

-Eric

