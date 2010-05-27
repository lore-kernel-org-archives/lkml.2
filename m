Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932315Ab0E0PhA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 11:37:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35964 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757336Ab0E0Pg7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 11:36:59 -0400
Date: Thu, 27 May 2010 17:35:22 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Richard Henderson <rth@twiddle.net>, wezhang@redhat.com,
       linux-kernel@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>,
       William Cohen <wcohen@redhat.com>
Subject: [PATCH 0/3] (Was: Q: sys_personality() && misc oddities)
Message-ID: <20100527153522.GA13858@redhat.com>
References: <20100525141720.GA2253@redhat.com> <20100525193348.83F1549A54@magilla.sf.frob.com> <20100526123622.GA26033@redhat.com> <20100526203105.59D7849A56@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100526203105.59D7849A56@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/26, Roland McGrath wrote:
>
> > Yes, libc itself is fine. But from the application's pov, personality()
> > returns int, not long.
>
> That doesn't really matter to error/success ambiguity.  Since what I said
> is true, it won't ever return exactly -1 for a non-error.  But even if it
> did, the application can use errno=0;personality(x);errno!=0 checking.

Agreed! to me this looks like the user-space bug, but there are people
who disagree.

Probably my initial email wasn't clear, I'll try to explain this better
in the changelog.

> > How about
> >
> > 	if (personality != 0xffffffff) {
> > 		if (personality >= 0x7fffffff)
> > 			return -EINVAL;
>
> Sure.

OK. Please see the patches.

	1/3 - obviously makes sense to me
	2/3 - not sure
	3/3 - simple cleanup, doesn't depend on 1-2

Oleg.

