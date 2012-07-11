Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756022Ab2GKGOx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 02:14:53 -0400
Received: from mail-yw0-f52.google.com ([209.85.213.52]:39378 "EHLO
	mail-yw0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755672Ab2GKGOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 02:14:52 -0400
X-Greylist: delayed 25463 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Jul 2012 02:14:52 EDT
MIME-Version: 1.0
In-Reply-To: <op.wg8cv6x53l0zgt@mpn-glaptop>
References: <1341876923-12469-1-git-send-email-walken@google.com>
	<1341876923-12469-6-git-send-email-walken@google.com>
	<op.wg8cv6x53l0zgt@mpn-glaptop>
Date: Tue, 10 Jul 2012 23:14:51 -0700
Message-ID: <CANN689EEHe+_W=pnnvf1u+BxpvY+BK6bLNZ-0Y-eoKNS=9L+rg@mail.gmail.com>
Subject: Re: [PATCH 05/13] rbtree: performance and correctness test
From: Michel Lespinasse <walken@google.com>
To: Michal Nazarewicz <mina86@mina86.com>
Cc: aarcange@redhat.com, dwmw2@infradead.org, riel@redhat.com,
        peterz@infradead.org, daniel.santos@pobox.com, axboe@kernel.dk,
        ebiederm@xmission.com, linux-mm@kvack.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 10, 2012 at 5:27 AM, Michal Nazarewicz <mina86@mina86.com> wrote:
> On Tue, 10 Jul 2012 01:35:15 +0200, Michel Lespinasse <walken@google.com> wrote:
>> +       u32 prev_key = 0;
>> +
>> +       for (rb = rb_first(&root); rb; rb = rb_next(rb)) {
>> +               struct test_node *node = rb_entry(rb, struct test_node,
>> rb);
>> +               WARN_ON_ONCE(node->key < prev_key);
>
> What if for some reason we generate node with key equal zero or two keys
> with the same value?  It may not be the case for current code, but someone
> might change it in the future.  I think <= is safer here.

No, it's not illegal for two nodes to have the same key; the second
one to be inserted will just get placed after the first one. The
rbtree library doesn't care either way as it's not even aware of the
key values :)

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
