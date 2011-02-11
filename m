Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758038Ab1BKTY1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 14:24:27 -0500
Received: from casper.infradead.org ([85.118.1.10]:43394 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757377Ab1BKTY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 14:24:26 -0500
Subject: Re: [PATCH 0/2] jump label: 2.6.38 updates
From: Peter Zijlstra <peterz@infradead.org>
To: Jason Baron <jbaron@redhat.com>
Cc: mathieu.desnoyers@polymtl.ca, hpa@zytor.com, rostedt@goodmis.org,
        mingo@elte.hu, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        sam@ravnborg.org, ddaney@caviumnetworks.com, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org
In-Reply-To: <cover.1294239591.git.jbaron@redhat.com>
References: <cover.1294239591.git.jbaron@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 11 Feb 2011 20:25:28 +0100
Message-ID: <1297452328.5226.89.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-05 at 10:43 -0500, Jason Baron wrote:
> Hi,
> 
> The first patch uses the storage space of the jump label key address
> as a pointer into the update table. In this way, we can find all
> the addresses that need to be updated without hashing.
> 
> The second patch introduces:
> 
> static __always_inline bool static_branch(struct jump_label_key *key);
> 
> instead of the old JUMP_LABEL(key, label) macro.
> 
> In this way, jump labels become really easy to use:
> 
> Define:
> 
>         struct jump_label_key jump_key;
> 
> Can be used as:
> 
>         if (static_branch(&jump_key))
>                 do unlikely code
> 
> enable/disale via:
> 
>         jump_label_enable(&jump_key);
>         jump_label_disable(&jump_key);
> 
> that's it!
> 
> For perf, which also uses jump labels, I've left the reference counting
> out of the jump label layer, thus removing the 'jump_label_inc()' and
> 'jump_label_dec()' interface. Hopefully, this is a more palatable solution.

Right, lets go with this. Maybe we'll manage to come up with something
saner than _else_atomic_read(), but for now its an improvement over what
we have.

