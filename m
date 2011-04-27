Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752925Ab1D0Gho (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 02:37:44 -0400
Received: from mtagate5.uk.ibm.com ([194.196.100.165]:60499 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419Ab1D0Ghl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 02:37:41 -0400
Date: Wed, 27 Apr 2011 08:37:42 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [GIT PULL] s390 patches for 2.6.39-rc4
Message-ID: <20110427083742.084bda90@mschwide.boeblingen.de.ibm.com>
In-Reply-To: <BANLkTik_SMi17rgLVss9esoez9OeHEhN0w@mail.gmail.com>
References: <20110426110300.6da0b684@mschwide.boeblingen.de.ibm.com>
	<BANLkTik_SMi17rgLVss9esoez9OeHEhN0w@mail.gmail.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Apr 2011 11:38:22 -0700
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> I'll pull this, but:
> 
> On Tue, Apr 26, 2011 at 2:03 AM, Martin Schwidefsky
> <schwidefsky@de.ibm.com> wrote:
> >
> > Jan Glauber (3):
> >      [S390] prng: prevent access beyond end of stack
> 
> I don't think that's _still_ correct.
> 
> Just looking at the diff, it looks broken:
> 
> >        /* Add the entropy */
> >        while (nbytes >= 8) {
> > -               *((__u64 *)parm_block) ^= *((__u64 *)buf+i*8);
> > +               *((__u64 *)parm_block) ^= *((__u64 *)buf+i);
> >                prng_add_entropy();
> >                i += 8;
> >                nbytes -= 8;
> 
> The "i += 8" implies that "i" is a byte offset.
> 
> But "(__u64 *)buf+i" will parse as "((__u64 *)buf) + i" and thus still
> do another multiply-by-eight.
> 
> So the diff fixes one "off by a factor of 8", but not another, if I
> read it right.
> 
> So the parenthesis should be moved around to something like "*(__u64
> *) (buf+i)", I think.

Urgs, pointer arithmetic for dummies..  it is indeed still wrong. We'll fix.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

