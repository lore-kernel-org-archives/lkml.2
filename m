Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755618Ab3AENFb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 08:05:31 -0500
Received: from mail.skyhub.de ([78.46.96.112]:43765 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755422Ab3AENF2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 08:05:28 -0500
Date: Sat, 5 Jan 2013 14:05:42 +0100
From: Borislav Petkov <bp@alien8.de>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7u1 01/31] x86, mm: Fix page table early allocation
 offset checking
Message-ID: <20130105130542.GB4297@x1.alien8.de>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Yinghai Lu <yinghai@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jan Kiszka <jan.kiszka@web.de>,
	Jason Wessel <jason.wessel@windriver.com>,
	linux-kernel@vger.kernel.org
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
 <1357260531-11115-2-git-send-email-yinghai@kernel.org>
 <20130104071737.GA20905@x1.alien8.de>
 <CAE9FiQXpAJgS_ADW-c23QsqywsX=vL_PSg=crYgLgep5nzVpxg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAE9FiQXpAJgS_ADW-c23QsqywsX=vL_PSg=crYgLgep5nzVpxg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 04, 2013 at 01:50:18PM -0800, Yinghai Lu wrote:
> On Thu, Jan 3, 2013 at 11:17 PM, Borislav Petkov <bp@alien8.de> wrote:
> > On Thu, Jan 03, 2013 at 04:48:21PM -0800, Yinghai Lu wrote:
> >> During debugging loading kernel above 4G, found one page if is not used
> >> in BRK with early page allocation.
> >>
> >> pgt_buf_top is address that can not be used, so should check if that new
> >> end is above that top, otherwise last page will not be used.
> >>
> >> Fix that checking and also add print out for every allocation from BRK.
> >
> > This commit message still bothers the hell out of me. Please, fix it up
> > to something more readable like the below, for example:
> >
> > "pgt_buf_top is an address which cannot be used so we should check
> > whether the new 'end' is above it. Otherwise, the last BRK page remains
> > unused.
> >
> > Fix that check and add a debug printout of every BRK allocation."
> 
> but your changelog is wrong.
> 
> it is NOT last BRK page.

"...otherwise last page will not be used." ??? Is it the current last
page? Which is it?

The fact that I need ot ask twice and cannot simply read it out from
your commit message should tell you one thing and one thing only: you
need to write out in more detail what you're doing so that people can
understand it. I admit, I'm not the smartest but that's even better -
you need to explain your code even to dumb people :-).

> it is NOT every BRK allocation.

Ok, so it is not every BRK allocation but it is for "every allocation
from BRK." But why do we need to print it out then? Why is it important
to print out every PGTABLE allocation we do from BRK? The answer to
*that* question should definitely go into the commit message.

So I hope you can catch my drift: this code needs very good explanation
because no one can take a look into your brain and read it out from
there. So please, let's give that commit message another try.

Thanks.

-- 
Regards/Gruss,
Boris.
