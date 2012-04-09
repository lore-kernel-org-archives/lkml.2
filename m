Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757742Ab2DISku (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 14:40:50 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39175 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753913Ab2DISks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 14:40:48 -0400
Date: Mon, 9 Apr 2012 11:40:32 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Richard Weinberger <richard@nod.at>
cc: Konstantin Khlebnikov <khlebnikov@openvz.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "paul.gortmaker@windriver.com" <paul.gortmaker@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: swapoff() runs forever
In-Reply-To: <4F82B6ED.2010500@nod.at>
Message-ID: <alpine.LSU.2.00.1204091123380.1430@eggly.anvils>
References: <4F81F564.3020904@nod.at> <4F82752A.6020206@openvz.org> <4F82B6ED.2010500@nod.at>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Apr 2012, Richard Weinberger wrote:
> Am 09.04.2012 07:35, schrieb Konstantin Khlebnikov:
> > Richard Weinberger wrote:
> >> Hi!
> >>
> >> I'm observing a strange issue (at least on UML) on recent Linux kernels.
> >> If swap is being used the swapoff() system call never terminates.
> >> To be precise "while ((i = find_next_to_unuse(si, i)) != 0)" in try_to_unuse()
> >> never terminates.
> >>
> >> The affected machine has 256MiB ram and 256MiB swap.
> >> If an application uses more than 256MiB memory swap is being used.
> >> But after the application terminates the free command still reports that a few
> >> MiB are on my swap device and swappoff never terminates.
> > 
> > After last tmpfs changes swapoff can take minutes.
> > Or this time it really never terminates?
> 
> I've never waited forever. ;-)

Your lack of dedication is disappointing.

> Once I've waited for >30 minutes.
> 
> I don't think that it's related to tmpfs because it happens
> also while shutting down the system after all filesystems have been unmounted.

Like you I'd assume that it is really was going to be forever,
rather than swapoff just being characteristically slow:
a few MiB left on swap shouldn't take long to get off.

I've not seen any such issue in recent months (or years), but
I've not been using UML either.  The most likely cause that springs
to mind would be corruption of the vmalloc'ed swap map: that would
be very likely to cause such a hang.

You say "recent Linux kernels": I wonder what "recent" means.
Is this something you can reproduce quickly and reliably enough
to do a bisection upon?

Thanks,
Hugh
