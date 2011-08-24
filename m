Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212Ab1HXN4H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 09:56:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18405 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751076Ab1HXN4E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 09:56:04 -0400
Date: Wed, 24 Aug 2011 15:53:06 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: monstr@monstr.eu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 17/43] microblaze: Use set_current_blocked() and
	block_sigmask()
Message-ID: <20110824135306.GA7828@redhat.com>
References: <1313772419-21951-1-git-send-email-matt@console-pimps.org> <1313772419-21951-18-git-send-email-matt@console-pimps.org> <4E54BB02.6060404@monstr.eu> <1314181287.3611.17.camel@mfleming-mobl1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314181287.3611.17.camel@mfleming-mobl1.ger.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/24, Matt Fleming wrote:
>
> On Wed, 2011-08-24 at 10:49 +0200, Michal Simek wrote:
> > > v2 of this patch depends on "[PATCH 01/43] signal: Add block_sigmask()
> > > for adding sigmask to current->blocked" so they need to go through the
> > > same tree but this patch would benefit from some maintainer ACK's.
> >
> > Please add there my ACK to it too.

Thanks Michal.

> > I will add patches 14-16/43 v2 to microblaze next branch keep them
> > for a while. I will propose them to Linus tree for v3.2.
>
> Actually, I just realised this is where it gets a little complicated. If
> you take those 3 patches and they're not in Oleg's tree, [PATCH 17/43]
> doesn't apply cleanly. Fixing 17/43 up so it applies without patches
> 14-16 would result in something like this in handle_signal(),
>
> 	if (!(ka->sa.sa_flags & SA_NODEFER)) {
> 		block_sigmask(ka, sig);
> 	}
> 	return 1;
>
> Which Linus would have to fixup to its original form when he merges the
> two trees. I think all the microblaze patches should go through Oleg's
> tree,

Agreed, this looks simpler.

Michal, unless you object, I am going to add the microblaze changes
(with your acks) to ptrace branch, it already has 01/43 which adds
block_sigmask().

OK?

Oleg.

