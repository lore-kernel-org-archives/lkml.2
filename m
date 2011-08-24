Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756770Ab1HXKVb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 06:21:31 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:35237 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756253Ab1HXKV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 06:21:29 -0400
Subject: Re: [PATCH v2 17/43] microblaze: Use set_current_blocked() and
 block_sigmask()
From: Matt Fleming <matt@console-pimps.org>
To: monstr@monstr.eu
Cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <4E54BB02.6060404@monstr.eu>
References: <1313772419-21951-1-git-send-email-matt@console-pimps.org>
	 <1313772419-21951-18-git-send-email-matt@console-pimps.org>
	 <4E54BB02.6060404@monstr.eu>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Aug 2011 11:21:27 +0100
Message-ID: <1314181287.3611.17.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-08-24 at 10:49 +0200, Michal Simek wrote:
> > v2 of this patch depends on "[PATCH 01/43] signal: Add block_sigmask()
> > for adding sigmask to current->blocked" so they need to go through the
> > same tree but this patch would benefit from some maintainer ACK's.
> 
> Please add there my ACK to it too.

OK will do, thanks.

> > 
> > Michal, I dropped your Acked-by because I felt this patch changed
> > quite dramatically since v1 and warrants another review. I hope that's
> > OK.
> 
> That's fine. I have run LTP tests and results look good.

Excellent!

> I will add patches 14-16/43 v2 to microblaze next branch keep them
> for a while. I will propose them to Linus tree for v3.2.

Actually, I just realised this is where it gets a little complicated. If
you take those 3 patches and they're not in Oleg's tree, [PATCH 17/43]
doesn't apply cleanly. Fixing 17/43 up so it applies without patches
14-16 would result in something like this in handle_signal(),

	if (!(ka->sa.sa_flags & SA_NODEFER)) {
		block_sigmask(ka, sig);
	}
	return 1;

Which Linus would have to fixup to its original form when he merges the
two trees. I think all the microblaze patches should go through Oleg's
tree, but it's really up to you two and Linus.

Oleg, if Michal does take patches 14-16 I can send you an updated patch
to apply.

-- 
Matt Fleming, Intel Open Source Technology Center

