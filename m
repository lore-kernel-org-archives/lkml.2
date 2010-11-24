Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751812Ab0KXPUa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 10:20:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2288 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751056Ab0KXPU3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 10:20:29 -0500
Date: Wed, 24 Nov 2010 10:19:36 -0500
From: Jason Baron <jbaron@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: rostedt@goodmis.org, mingo@elte.hu, mathieu.desnoyers@polymtl.ca,
        hpa@zytor.com, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        sam@ravnborg.org, ddaney@caviumnetworks.com, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] jump label: add enabled/disabled state to jump
	label key entries
Message-ID: <20101124151936.GB2815@redhat.com>
References: <cover.1290546539.git.jbaron@redhat.com> <d03959060763fecdf2523a3f1353e1fc59f8f4a1.1290546539.git.jbaron@redhat.com> <1290586809.2072.424.camel@laptop> <20101124145401.GA2815@redhat.com> <1290611478.2072.482.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290611478.2072.482.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 24, 2010 at 04:11:18PM +0100, Peter Zijlstra wrote:
> On Wed, 2010-11-24 at 09:54 -0500, Jason Baron wrote:
> > On Wed, Nov 24, 2010 at 09:20:09AM +0100, Peter Zijlstra wrote:
> > > On Tue, 2010-11-23 at 16:27 -0500, Jason Baron wrote:
> > > >         struct hlist_head modules;
> > > >         unsigned long key;
> > > > +       u32 nr_entries : 31,
> > > > +              enabled :  1;
> > > >  }; 
> > > 
> > > I still don't see why you do this, why not simply mandate that the key
> > > is of type atomic_t* and use *key as enabled state?
> > > 
> > 
> > Because I want to use *key as a pointer directly to 'struct jump_label_entry'.
> > In this way jump_label_enable(), jump_label_disable(), become O(1) operations.
> > That way we don't need any hashing.
> 
> But but but, you're doing a friggin stop_machine to poke text, that's
> way more expensive than anything else.
> 

Yes, but other arches do not require stop_machine(). Also, there is work
for x86 to make the code patching happen without stop_machine().

> You can do away with the hash by using the bsearch stuff Andi has been
> proposing.
> 
> Also, I'd actually like to have more than 1 bit of storage, I'm using it
> as a general refcount.
> 
> 

Not a problem, we can have a few fields, the first of which can be a
pointer, the rest can be used for other purposes.

thanks,

-Jason

