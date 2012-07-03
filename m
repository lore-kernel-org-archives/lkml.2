Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757314Ab2GCXQS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 19:16:18 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:35825 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752452Ab2GCXQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 19:16:17 -0400
MIME-Version: 1.0
In-Reply-To: <4FF3662A.9070700@redhat.com>
References: <1340315835-28571-1-git-send-email-riel@surriel.com>
	<1340315835-28571-2-git-send-email-riel@surriel.com>
	<20120629234638.GA27797@google.com>
	<4FF3662A.9070700@redhat.com>
Date: Tue, 3 Jul 2012 16:16:15 -0700
Message-ID: <CANN689HchF15SfZKo6i9yD7k7NnSECm-7+wMq2EfjoyoCV7vaA@mail.gmail.com>
Subject: Re: [PATCH -mm v2 01/11] mm: track free size between VMAs in VMA rbtree
From: Michel Lespinasse <walken@google.com>
To: Rik van Riel <riel@redhat.com>
Cc: Rik van Riel <riel@surriel.com>, linux-mm@kvack.org,
        akpm@linux-foundation.org, aarcange@redhat.com, peterz@infradead.org,
        minchan@gmail.com, kosaki.motohiro@gmail.com, andi@firstfloor.org,
        hannes@cmpxchg.org, mel@csn.ul.ie, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 3, 2012 at 2:37 PM, Rik van Riel <riel@redhat.com> wrote:
> On 06/29/2012 07:46 PM, Michel Lespinasse wrote:
>> Basically, I think lib/rbtree.c should provide augmented rbtree support
>> in the form of (versions of) rb_insert_color() and rb_erase() being able
>> to
>> callback to adjust the augmented node information around tree rotations,
>> instead of using (conservative, overkill) loops to adjust the augmented
>> node information after the fact
>
> That is what I originally worked on.
>
> I threw out that code after people told me (at LSF/MM) in
> no uncertain terms that I should use the augmented rbtree
> code :)

Well, bummer. Could you summarize what their argument was ? In other
words, what are the constraints besides not adding overhead to the
scheduler rbtree use case and keeping the code size reasonable ?

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
