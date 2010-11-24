Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755739Ab0KXTH4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 14:07:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13541 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754317Ab0KXTHz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 14:07:55 -0500
Date: Wed, 24 Nov 2010 14:07:07 -0500
From: Jason Baron <jbaron@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Steven Rostedt <rostedt@goodmis.org>, mingo@elte.hu, hpa@zytor.com,
        tglx@linutronix.de, andi@firstfloor.org, roland@redhat.com,
        rth@redhat.com, masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com,
        avi@redhat.com, davem@davemloft.net, sam@ravnborg.org,
        ddaney@caviumnetworks.com, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] jump label: add enabled/disabled state to jump
	label key entries
Message-ID: <20101124190707.GG2815@redhat.com>
References: <cover.1290546539.git.jbaron@redhat.com> <d03959060763fecdf2523a3f1353e1fc59f8f4a1.1290546539.git.jbaron@redhat.com> <20101123234355.GA21549@Krystal> <1290556830.30543.415.camel@gandalf.stny.rr.com> <20101124002411.GA29158@Krystal> <20101124182424.GF2815@redhat.com> <1290623970.2072.504.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290623970.2072.504.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 24, 2010 at 07:39:30PM +0100, Peter Zijlstra wrote:
> On Wed, 2010-11-24 at 13:24 -0500, Jason Baron wrote:
> > By storing the state of the jump label with each key, we make
> > sure that when modules are added, they are updated to the correct
> > state. For example, if the kmalloc tracepoint is enabled and
> > a module is added which has kmalloc, we make sure that the tracepoint
> > is properly enabled on module load.
> > 
> > Also, if jump_label_enable(key), is called but the key has not yet
> > been added to the hashtable of jump label keys, add 'key' to the table.
> > In this way, if key value has its state updated, but we have not
> > yet encountered a JUMP_LABEL() definition for it (if its located in
> > a module), we ensure that the jump label is set to the correct
> > state when it finally is encountered.
> > 
> > When modules are unloaded, we traverse the jump label hashtable,
> > and remove any entries that have a key value that is contained
> > by that module's text section. In this way key values are properly
> > unregistered, and can be re-used.
> 
> So why again are we adding all this complexity? Does this really need to
> be optimized in the face of how expensive text pokes are?

perhaps, not. But I would like to better understand how expensive text
pokes are on some other arches such as powerpc first.

Obviously, I want the best implementation - the last posted version of
binary search, had a deadlock with the module_mutex, which I saw no
resolution for...

So, with this 1 additinal patch, we have a complete working implemenation of
jump labels within the current framework. We can iterate from there if ppl want
to simpify/optimize various parts. That's how I envision proceeding.

thanks,

-Jason
