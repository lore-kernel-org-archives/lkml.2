Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932419Ab1EIWxi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 18:53:38 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:45021 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755767Ab1EIWxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 18:53:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=cTGJc7BifhKVDtGIup+rK9AWaJjQWYKzuXVmNn7D4Voy2uYdxiwaNQXlQ/bOpy0cjG
         42OlqocHpTM9UCyuIVnCcM+iQFupYkqm1uoBhVJI867Wktod1a/i7M/W8xpFouVcxIdu
         McX1za6juWQRecCoaDVq2GuWT2Zg8kC/OyKR0=
MIME-Version: 1.0
In-Reply-To: <BANLkTim7ATRyJ2NvoCj4Sv=7CLizKMd_WA@mail.gmail.com>
References: <alpine.DEB.2.00.1105082045250.15552@artax.karlin.mff.cuni.cz>
	<alpine.LSU.2.00.1105081303540.16151@sister.anvils>
	<alpine.DEB.2.00.1105091307570.32299@artax.karlin.mff.cuni.cz>
	<BANLkTinCUQSjjif3op3H_9HDm5Eu-o+Luw@mail.gmail.com>
	<BANLkTim3kKJkisZK1mOgKhsEEs7FzZmyXA@mail.gmail.com>
	<1304979549.4865.56.camel@mulgrave.site>
	<BANLkTim7ATRyJ2NvoCj4Sv=7CLizKMd_WA@mail.gmail.com>
Date: Mon, 9 May 2011 15:53:33 -0700
Message-ID: <BANLkTi=DCKmN_BafFckKHOMfjWpVLQPDFA@mail.gmail.com>
Subject: Re: [PATCH] Don't mlock guardpage if the stack is growing up
From: Tony Luck <tony.luck@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
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

On Mon, May 9, 2011 at 3:31 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> With current kernels, I think the stack expands by one page during the
> mlockall (for STACK_GROWSUP), with the patch it shouldn't.

Tried this on ia64 (with a mod because the upward growing stack isn't
blessed with
the [stack] annotation, only the downward growing stack gets that honour).

ia64 builds, boots, and processes can still grow stacks (both of them).  The
patched kernel doesn't change the size of the upwardly growing stack across
the mlockall().

-Tony

P.S. while we could start both stacks on the same page and have the grow
away from the start point, ia64 actually starts them out a fair distance apart
and lets them run into each other (if you have enough memory to let them
grow that far, and if ulimit -s doesn't stop them earlier)
