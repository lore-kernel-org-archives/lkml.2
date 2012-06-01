Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758803Ab2FACns (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 22:43:48 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:48431 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758775Ab2FACnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 22:43:47 -0400
MIME-Version: 1.0
In-Reply-To: <20120601023107.GA19445@redhat.com>
References: <20120530163317.GA13189@redhat.com> <20120531005739.GA4532@redhat.com>
 <20120601023107.GA19445@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 31 May 2012 19:43:25 -0700
X-Google-Sender-Auth: tpl3gwMFanlH_ZOBf-7ku_28mh0
Message-ID: <CA+55aFyNSUbTfY4YdH4OcrrRnwkw-sHy3aT18ynf-YXRXSJQ8Q@mail.gmail.com>
Subject: Re: WARNING: at mm/page-writeback.c:1990 __set_page_dirty_nobuffers+0x13a/0x170()
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Cong Wang <amwang@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 31, 2012 at 7:31 PM, Dave Jones <davej@redhat.com> wrote:
>
> So I bisected it anyway, and it led to ...

Ok, that doesn't sound entirely unlikely, but considering that you're
nervous about the bisection, please just try to revert it and see if
that fixes your testcase.

You'll obviously need to revert the commit that removes
vmtruncate_range() too, since reverting 3f31d07571ee will re-introduce
the use of it (it's the next one:
17cf28afea2a1112f240a3a2da8af883be024811), but it looks like those two
commits revert cleanly and the end result seems to compile ok.

               Linus
