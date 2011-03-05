Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754250Ab1CEUju (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 15:39:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64905 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752669Ab1CEUjs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 15:39:48 -0500
Date: Sat, 5 Mar 2011 21:30:40 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        pageexec@freemail.hu, Solar Designer <solar@openwall.com>,
        Eugene Teo <eteo@redhat.com>, Brad Spengler <spender@grsecurity.net>,
        Roland McGrath <roland@redhat.com>, Milton Miller <miltonm@bga.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH v4 0/4] exec: unify native/compat code
Message-ID: <20110305203040.GA7546@redhat.com>
References: <20110302162650.GA26810@redhat.com> <20110302162712.GB26810@redhat.com> <20110303114952.B94B.A69D9226@jp.fujitsu.com> <20110303154706.GA22560@redhat.com> <AANLkTimp=mhedXLdrZFqK2QWYvg7MdmUPj3-Q9m2vtTx@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimp=mhedXLdrZFqK2QWYvg7MdmUPj3-Q9m2vtTx@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03, Linus Torvalds wrote:
>
> On Thu, Mar 3, 2011 at 7:47 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> >> I _personally_ don't like "conditional". Its name is based on code logic.
> >> It's unclear what mean "conditional". From data strucuture view, It is
> >> "opaque userland pointer".
> >
> > I agree with any naming, just suggest a better name ;)
>
> Maybe just "struct user_arg_ptr" or something?

OK, nothing else was suggessted, I assume Kosaki agrees.

So rename conditional_ptr to user_arg_ptr.

Also rename get_user_ptr() to get_user_arg_ptr(). It was suggested to
use the same "user_arg_ptr" for this helper too, but this is not
grep-friendly. As for get_ in the name... Well, I can redo again ;)
But this matches get_user() and this is all what this helper does.

Otherwise unchanged.

Oleg.

