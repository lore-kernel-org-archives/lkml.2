Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781Ab1FOTdM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 15:33:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53246 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753377Ab1FOTdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 15:33:06 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTinxKV-Kprm+ezfbt2a=C1fz+-7wrg@mail.gmail.com>
References: <BANLkTikbnsu05+Nae8isATuZ8Fucj14+LQ@mail.gmail.com>
 <BANLkTi=nsCK2bFf2v+PkKj=Opsxseqe9pQ@mail.gmail.com> <BANLkTi=ZETGToRcOHXg5gxAQO3EKN+YyLg@mail.gmail.com>
 <BANLkTi=-xJizWP5H9vNvaJhRN-Vm-ubraA@mail.gmail.com> <4DF7A264.3030901@mit.edu>
 <20110614211613.GB12249@elte.hu> <BANLkTi=W1xFdoSFxnNBGX9gt_pYOH4oF=A@mail.gmail.com>
 <20110614213109.GA9725@elte.hu> <BANLkTimXYaf_14VbB6ex0kG6sPnTUfzu6g@mail.gmail.com>
 <BANLkTi=mwowbSy0M=rjdQW_cKDVf1tBBpA@mail.gmail.com> <20110615072553.GA26003@elte.hu>
 <BANLkTinSac=XHNk7jnsYGDo06B=ChXsnAQ@mail.gmail.com> <BANLkTinxKV-Kprm+ezfbt2a=C1fz+-7wrg@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 15 Jun 2011 12:32:42 -0700
Message-ID: <BANLkTinJimOb4CMQeDm+Ob60N5v4QAMWwg@mail.gmail.com>
Subject: Re: [PATCH] x86, vsyscall: Fix build warning in vsyscall_64.c
To: Andrew Lutomirski <luto@mit.edu>
Cc: Ingo Molnar <mingo@elte.hu>, Rakib Mullick <rakib.mullick@gmail.com>,
        hpa@zytor.com, tglx@linutronix.de, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 15, 2011 at 12:24 PM, Andrew Lutomirski <luto@mit.edu> wrote:
>
> Well, let's say that my logic is wrong and this particular BUG can be
> hit because some kernel bug allows some user program to trigger it.

Christ, we already check the particular address. And if a user can
generate the buggy situation, THEN THE BUG_ON() SURE AS HELL ISN'T
HELPING ANYTHING!

Guys, if that BUG_ON can ever be triggered, IT IS A SECURITY HOLE IN
ITSELF! What's so hard to understand about that?

BUG_ON's are not "good ways to figure out something went wrong". They
are an absolute last-case situation. They are NOT "let's fix that
security hole by halting the whole machine" kind of valid.

If you're really worried about it ever triggering, then dammit, HANDLE THE CASE.

Don't add a BUG_ON() for something you're afraid of. That is NEVER the
right thing to do. If you're worried that that situation can trigger,
then do the right code for that situation. Don't throw your hands in
the air and say "that's a bug".

                             Linus
