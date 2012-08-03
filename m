Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094Ab2HCXsL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 19:48:11 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:58160 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754025Ab2HCXsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 19:48:09 -0400
MIME-Version: 1.0
In-Reply-To: <20120803223634.GO15477@google.com>
References: <1344003788-1417-1-git-send-email-levinsasha928@gmail.com>
 <1344003788-1417-2-git-send-email-levinsasha928@gmail.com>
 <20120803171515.GH15477@google.com> <501C407D.9080900@gmail.com>
 <20120803213017.GK15477@google.com> <501C458E.7050000@gmail.com>
 <20120803214806.GM15477@google.com> <501C4E92.1070801@gmail.com>
 <20120803222339.GN15477@google.com> <CA+55aFyOst4c3WHbPVbYkSBdBmLJUui5OvoVOh5AuPMnigwnEA@mail.gmail.com>
 <20120803223634.GO15477@google.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 3 Aug 2012 16:47:47 -0700
X-Google-Sender-Auth: WjhUl7UeqK1B_FBr2DwCYdtbGRw
Message-ID: <CA+55aFwTa_kYgmFwoWa6hwAAM6=2xTgQQf-vEx_gCzpEMnxodQ@mail.gmail.com>
Subject: Re: [RFC v2 1/7] hashtable: introduce a small and naive hashtable
To: Tejun Heo <tj@kernel.org>
Cc: Sasha Levin <levinsasha928@gmail.com>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        paul.gortmaker@windriver.com, davem@davemloft.net, rostedt@goodmis.org,
        mingo@elte.hu, ebiederm@xmission.com, aarcange@redhat.com,
        ericvh@gmail.com, netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 3, 2012 at 3:36 PM, Tejun Heo <tj@kernel.org> wrote:
>
> I suppose you mean unsized.  I remember this working.  Maybe I'm
> confusing it with zero-sized array.  Hmm... gcc doesn't complain about
> the following.  --std=c99 seems happy too.

Ok, I'm surprised, but maybe it's supposed to work if you do it inside
another struct like that, exactly so that you can preallocate things..

Or maybe it's just a gcc bug. I do think this all is way hackier than
Sasha's original simple code that didn't need these kinds of games,
and didn't need a size member at all.

I really think all the extra complexity and overhead is just *bad*.
The first simple version was much nicer and likely generated better
code too.

               Linus
