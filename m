Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755864Ab1EIXIr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 19:08:47 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:44985 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755816Ab1EIXIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 19:08:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=OXoQWLezyftMefqpX5MQPeZbiRLC6ivkSPaySE+VrXSm8XBGfqCKHJ0gYPhCEM0Y3R
         qenYNldWxWa5NsXys66VYN5E0dR2K9xUSZnqjSaaeQ5aCGQtL1ZYyHOF3oncOBE2BadK
         3XyJFY0ix2oNewCAb5l50v2T6Lxm40BA7pDA8=
MIME-Version: 1.0
In-Reply-To: <BANLkTikkA5H2D23u23FV0cTcL2bAT8BKWQ@mail.gmail.com>
References: <alpine.DEB.2.00.1105082045250.15552@artax.karlin.mff.cuni.cz>
	<alpine.LSU.2.00.1105081303540.16151@sister.anvils>
	<alpine.DEB.2.00.1105091307570.32299@artax.karlin.mff.cuni.cz>
	<BANLkTinCUQSjjif3op3H_9HDm5Eu-o+Luw@mail.gmail.com>
	<BANLkTim3kKJkisZK1mOgKhsEEs7FzZmyXA@mail.gmail.com>
	<1304979549.4865.56.camel@mulgrave.site>
	<BANLkTim7ATRyJ2NvoCj4Sv=7CLizKMd_WA@mail.gmail.com>
	<BANLkTi=DCKmN_BafFckKHOMfjWpVLQPDFA@mail.gmail.com>
	<BANLkTikkA5H2D23u23FV0cTcL2bAT8BKWQ@mail.gmail.com>
Date: Mon, 9 May 2011 16:08:44 -0700
Message-ID: <BANLkTikLJPCc5ffobAb5uhdryRqjGhpVAQ@mail.gmail.com>
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

On Mon, May 9, 2011 at 3:58 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> Ahh, so you never actually have one single mapping that has both flags set?
>
> In that case, I won't even worry about it.

Definitely not for normal processes - I'm not sure how both stacks are
set up for threads.

> One thing I did want to verify: did the mlockall() actually change the
> stack size without that patch? Just to double-check that the patch
> actually did change semantics visibly.

On an unpatched system I see this (lots more than one page of growth -
pages are 64K on this config):
6007fffffff50000-6007fffffff70000 rw-p 00000000 00:00 0
6007fffffff50000-6008000000750000 rw-p 00000000 00:00 0

On a patched system I see (this one has 16K pages - no growth)
600007ffff9d0000-600007ffff9d4000 rw-p 00000000 00:00 0
600007ffff9d0000-600007ffff9d4000 rw-p 00000000 00:00 0

-Tony
