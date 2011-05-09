Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755832Ab1EIW64 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 18:58:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39843 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753663Ab1EIW6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 18:58:54 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTi=DCKmN_BafFckKHOMfjWpVLQPDFA@mail.gmail.com>
References: <alpine.DEB.2.00.1105082045250.15552@artax.karlin.mff.cuni.cz>
 <alpine.LSU.2.00.1105081303540.16151@sister.anvils> <alpine.DEB.2.00.1105091307570.32299@artax.karlin.mff.cuni.cz>
 <BANLkTinCUQSjjif3op3H_9HDm5Eu-o+Luw@mail.gmail.com> <BANLkTim3kKJkisZK1mOgKhsEEs7FzZmyXA@mail.gmail.com>
 <1304979549.4865.56.camel@mulgrave.site> <BANLkTim7ATRyJ2NvoCj4Sv=7CLizKMd_WA@mail.gmail.com>
 <BANLkTi=DCKmN_BafFckKHOMfjWpVLQPDFA@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 9 May 2011 15:58:02 -0700
Message-ID: <BANLkTikkA5H2D23u23FV0cTcL2bAT8BKWQ@mail.gmail.com>
Subject: Re: [PATCH] Don't mlock guardpage if the stack is growing up
To: Tony Luck <tony.luck@gmail.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
        Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
        Fenghua Yu <fenghua.yu@intel.com>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org,
        Michel Lespinasse <walken@google.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-ia64@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 9, 2011 at 3:53 PM, Tony Luck <tony.luck@gmail.com> wrote:
>
> P.S. while we could start both stacks on the same page and have the grow
> away from the start point, ia64 actually starts them out a fair distance apart
> and lets them run into each other (if you have enough memory to let them
> grow that far, and if ulimit -s doesn't stop them earlier)

Ahh, so you never actually have one single mapping that has both flags set?

In that case, I won't even worry about it.

One thing I did want to verify: did the mlockall() actually change the
stack size without that patch? Just to double-check that the patch
actually did change semantics visibly.

                 Linus
