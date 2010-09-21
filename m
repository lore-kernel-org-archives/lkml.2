Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595Ab0IUNMg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 09:12:36 -0400
Received: from one.firstfloor.org ([213.235.205.2]:57624 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753478Ab0IUNMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 09:12:35 -0400
Date: Tue, 21 Sep 2010 15:12:32 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, mathieu.desnoyers@polymtl.ca,
        hpa@zytor.com, tglx@linutronix.de, rostedt@goodmis.org,
        andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
        mhiramat@redhat.com, fweisbec@gmail.com, avi@redhat.com,
        davem@davemloft.net, vgoyal@redhat.com, sam@ravnborg.org,
        tony@bakeyournoodle.com
Subject: Re: [PATCH 03/10] jump label v11: base patch
Message-ID: <20100921131232.GA3024@one.firstfloor.org>
References: <cover.1284733808.git.jbaron@redhat.com> <ee8b3595967989fdaf84e698dc7447d315ce972a.1284733808.git.jbaron@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ee8b3595967989fdaf84e698dc7447d315ce972a.1284733808.git.jbaron@redhat.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 17, 2010 at 11:09:00AM -0400, Jason Baron wrote:
> +extern void arch_jump_label_transform(struct jump_entry *entry,
> +				 enum jump_label_type type);
> +extern void jump_label_update(unsigned long key, enum jump_label_type type);
> +extern void jump_label_apply_nops(struct module *mod);
> +extern void arch_jump_label_text_poke_early(jump_label_t addr);

These function names are too long.

Also it would be better if the types for the pointers are kept
instead of casting to unsigned long. All the variables
are ints right?

> +#define JUMP_LABEL_HASH_BITS 6
> +#define JUMP_LABEL_TABLE_SIZE (1 << JUMP_LABEL_HASH_BITS)
> +static struct hlist_head jump_label_table[JUMP_LABEL_TABLE_SIZE];

It's not clear to me why this hash table is needed. There should
not be that many trace points, is it that big a problem to simply
walk all the sections when something is changed?

Or maybe the sections could be just sorted and a binary search used
like with exception tables.

I suspect that would simplify a lot of code.

Overall I like the idea, but the current code is too complicated
for the benefit I think.

Can it be put on a diet?

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
