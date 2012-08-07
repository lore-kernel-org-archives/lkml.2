Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757007Ab2HGAEV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 20:04:21 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:36659 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756161Ab2HGAEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 20:04:20 -0400
MIME-Version: 1.0
In-Reply-To: <1344262930.27828.57.camel@twins>
References: <1343946858-8170-1-git-send-email-walken@google.com>
	<1343946858-8170-4-git-send-email-walken@google.com>
	<1344262930.27828.57.camel@twins>
Date: Mon, 6 Aug 2012 17:04:18 -0700
Message-ID: <CANN689GZQ4pYuqzB9ZQ0QBatvsDgj60_ciG5MBHqsKdb5CYtyQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/9] rbtree: add __rb_change_child() helper function
From: Michel Lespinasse <walken@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: riel@redhat.com, daniel.santos@pobox.com, aarcange@redhat.com,
        dwmw2@infradead.org, akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 6, 2012 at 7:22 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, 2012-08-02 at 15:34 -0700, Michel Lespinasse wrote:
>> +static inline void
>
> I would make that __always_inline, just to make sure GCC doesn't go
> creative on us.

How strongly do you care ? I'm not sure it makes sense to change it
unless we also change every other inline function in that file. I'd
rather not do that until we hear of gcc actually breaking things.

(BTW, did you know that sometimes gcc generates different code when
you change from inline to always_inline, even though things were
already inlined before ? I really hate dealing with gcc crap like
that, makes me want to forget about inline functions and just do it
all with preprocessor abuse...)

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
