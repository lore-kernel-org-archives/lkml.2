Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240Ab1GROmR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 10:42:17 -0400
Received: from smtp-out.google.com ([74.125.121.67]:28440 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753540Ab1GROmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 10:42:15 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=v2af/uplC4oqydRSN7aiwtcYke4AQqwHu8pP9djky1z2bRFqQEUFjkieBSvKUGFI7
	Vq/7Tdnl0YqY0ji6moBnQ==
Date: Mon, 18 Jul 2011 07:41:56 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nick Piggin <npiggin@kernel.dk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] vfs: fix race in rcu lookup of pruned dentry
In-Reply-To: <CA+55aFwXgcWxvAz7w1f_HYyzdm9b9EBJfrWhF1FW7EA3zpbJPg@mail.gmail.com>
Message-ID: <alpine.LSU.2.00.1107180726210.2541@sister.anvils>
References: <alpine.LSU.2.00.1107171356480.3175@sister.anvils> <CA+55aFw5LhGq-a6mAhgZbGP2FJ+tnV9HRxKoiFuVYbttOo2tNw@mail.gmail.com> <20110717231610.GR11013@ZenIV.linux.org.uk> <CA+55aFxEGKgx+_xy+Lnt=84wRzE9TyznL3VCNSqWs7HC_H35_A@mail.gmail.com>
 <alpine.LSU.2.00.1107171641130.1274@sister.anvils> <20110718002524.GU11013@ZenIV.linux.org.uk> <alpine.LSU.2.00.1107171740260.1327@sister.anvils> <20110718020818.GW11013@ZenIV.linux.org.uk>
 <CA+55aFwXgcWxvAz7w1f_HYyzdm9b9EBJfrWhF1FW7EA3zpbJPg@mail.gmail.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Jul 2011, Linus Torvalds wrote:
> 
> So I claim that your patch changes *way* more than mine does. I think
> I'd prefer Hugh's over that one. I still think that right now, my
> one-liner is actually the one that changes things the least (and I
> don't mean in size of patch, but in behavior and logic).

A quick audit of .d_iputs suggests that they're all okay with yours;
but it only needs one of them to say BUG_ON(dentry->d_inode) for no
good reason, and the fix becomes much more dangerous than the tiny
race it's trying to fix.

I've entirely failed to reproduce the issue since I sent you the patch:
the last time I saw it was a couple of hours before sending the patch,
and that was the first time in weeks (partly because of vacation).
It's now looking as if I was just lucky to get it in hours that time.

I'm thinking there's some other factor, which I know nothing about,
which opens the window to make this issue more than theoretical.
I may be forced to opening the window artificially to get it to
happen often enough to even begin to verify that your patch,
or Al's, or mine, does not blow up in some unforeseen way.
And I'm unlikely to be testing filesystem dentry_iputs at all.

Your patch remains my preference, but given Al's uneasiness,
my vote remains to make no change now for 3.0, but put yours
in early for 3.1-rc.

Hugh
