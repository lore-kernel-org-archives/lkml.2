Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756290Ab2HFVe3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 17:34:29 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:49368 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753898Ab2HFVe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 17:34:28 -0400
MIME-Version: 1.0
In-Reply-To: <1344263140.27828.59.camel@twins>
References: <1343946858-8170-1-git-send-email-walken@google.com>
	<1343946858-8170-9-git-send-email-walken@google.com>
	<1344263140.27828.59.camel@twins>
Date: Mon, 6 Aug 2012 14:34:26 -0700
Message-ID: <CANN689GbB5Rj3FmgP_RWj5EJVxJKBZS1WavZCKg0tuYR4vMZpg@mail.gmail.com>
Subject: Re: [PATCH v2 8/9] rbtree: faster augmented rbtree manipulation
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

On Mon, Aug 6, 2012 at 7:25 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, 2012-08-02 at 15:34 -0700, Michel Lespinasse wrote:
>> +struct rb_augment_callbacks {
>> +       void (*propagate)(struct rb_node *node, struct rb_node *stop);
>> +       void (*copy)(struct rb_node *old, struct rb_node *new);
>> +       void (*rotate)(struct rb_node *old, struct rb_node *new);
>> +};
>
> Should we make that const pointers? Daniel?

I don't think it would hurt, but note that each function taking this
as an argument takes it as a const struct rb_augment_callbacks *, so I
doubt the extra consts would help either.

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
