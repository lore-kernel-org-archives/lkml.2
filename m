Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750943Ab1EJENA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 00:13:00 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:39292 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750703Ab1EJEM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 00:12:58 -0400
Subject: Re: [PATCH] Don't mlock guardpage if the stack is growing up
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tony Luck <tony.luck@gmail.com>,
        Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
        Fenghua Yu <fenghua.yu@intel.com>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org,
        Michel Lespinasse <walken@google.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-ia64@vger.kernel.org
In-Reply-To: <BANLkTikUyUpa9-ZZBquHW4xSCEj8W8TgnA@mail.gmail.com>
References: <alpine.DEB.2.00.1105082045250.15552@artax.karlin.mff.cuni.cz>
	 <alpine.LSU.2.00.1105081303540.16151@sister.anvils>
	 <alpine.DEB.2.00.1105091307570.32299@artax.karlin.mff.cuni.cz>
	 <BANLkTinCUQSjjif3op3H_9HDm5Eu-o+Luw@mail.gmail.com>
	 <BANLkTim3kKJkisZK1mOgKhsEEs7FzZmyXA@mail.gmail.com>
	 <1304979549.4865.56.camel@mulgrave.site>
	 <BANLkTim7ATRyJ2NvoCj4Sv=7CLizKMd_WA@mail.gmail.com>
	 <BANLkTi=DCKmN_BafFckKHOMfjWpVLQPDFA@mail.gmail.com>
	 <BANLkTikkA5H2D23u23FV0cTcL2bAT8BKWQ@mail.gmail.com>
	 <BANLkTikLJPCc5ffobAb5uhdryRqjGhpVAQ@mail.gmail.com>
	 <BANLkTiksgtgviJGmq925OtLNU4QynVLVtg@mail.gmail.com>
	 <BANLkTikUyUpa9-ZZBquHW4xSCEj8W8TgnA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 May 2011 23:12:53 -0500
Message-ID: <1305000773.4865.62.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-09 at 16:25 -0700, Linus Torvalds wrote:
> On Mon, May 9, 2011 at 4:17 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > Ok, I'll consider it tested. I'll commit it with Mikulas as author,
> > but note that I edited it so he won't get the blame if there's some
> > problem.
> 
> Oh, and I marked it for stable too, although I don't know if any
> distribution really cares about parisc or ia64. And I'm not sure that
> ia64 even saw the lvm2 failure case - I'd have expected to hear about
> it if it actually happens there.

Well, it's a done deal, but here's the proof on parisc too:

Before:

c0266000-c0289000 rwxp 00000000 00:00 0                                  [stack]
c0266000-c0a66000 rwxp 00000000 00:00 0                                  [stack]

After:

bffee000-c0010000 rwxp 00000000 00:00 0                                  [stack]
bffee000-c0010000 rwxp 00000000 00:00 0                                  [stack]

James


