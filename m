Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755818Ab2HFVgf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 17:36:35 -0400
Received: from casper.infradead.org ([85.118.1.10]:37591 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753617Ab2HFVge convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 17:36:34 -0400
Message-ID: <1344288982.27828.116.camel@twins>
Subject: Re: [PATCH v2 8/9] rbtree: faster augmented rbtree manipulation
From: Peter Zijlstra <peterz@infradead.org>
To: Michel Lespinasse <walken@google.com>
Cc: riel@redhat.com, daniel.santos@pobox.com, aarcange@redhat.com,
        dwmw2@infradead.org, akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Date: Mon, 06 Aug 2012 23:36:22 +0200
In-Reply-To: <CANN689GbB5Rj3FmgP_RWj5EJVxJKBZS1WavZCKg0tuYR4vMZpg@mail.gmail.com>
References: <1343946858-8170-1-git-send-email-walken@google.com>
	 <1343946858-8170-9-git-send-email-walken@google.com>
	 <1344263140.27828.59.camel@twins>
	 <CANN689GbB5Rj3FmgP_RWj5EJVxJKBZS1WavZCKg0tuYR4vMZpg@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-08-06 at 14:34 -0700, Michel Lespinasse wrote:
> On Mon, Aug 6, 2012 at 7:25 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Thu, 2012-08-02 at 15:34 -0700, Michel Lespinasse wrote:
> >> +struct rb_augment_callbacks {
> >> +       void (*propagate)(struct rb_node *node, struct rb_node *stop);
> >> +       void (*copy)(struct rb_node *old, struct rb_node *new);
> >> +       void (*rotate)(struct rb_node *old, struct rb_node *new);
> >> +};
> >
> > Should we make that const pointers? Daniel?
> 
> I don't think it would hurt, but note that each function taking this
> as an argument takes it as a const struct rb_augment_callbacks *, so I
> doubt the extra consts would help either.

IIRC Daniel found it allowed some older GCC to inline more if the
function pointer itself was constant.
