Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643Ab0IVMwK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 08:52:10 -0400
Received: from one.firstfloor.org ([213.235.205.2]:60126 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344Ab0IVMwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 08:52:09 -0400
Date: Wed, 22 Sep 2010 14:52:02 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <andi@firstfloor.org>, jbaron@redhat.com, rostedt@goodmis.com,
        linux-kernel@vger.kernel.org, mingo@elte.hu,
        mathieu.desnoyers@polymtl.ca, hpa@zytor.com, roland@redhat.com,
        rth@redhat.com, mhiramat@redhat.com, fweisbec@gmail.com,
        avi@redhat.com, davem@davemloft.net, vgoyal@redhat.com,
        sam@ravnborg.org, tony@bakeyournoodle.com,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/2] Add for_each_module iterator function
Message-ID: <20100922125202.GC5766@basil.fritz.box>
References: <1285150102-5506-1-git-send-email-andi@firstfloor.org>
 <alpine.LFD.2.00.1009221424590.2416@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1009221424590.2416@localhost6.localdomain6>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +void for_each_module(void (*op)(struct module *, void *arg), void *arg)
> > +{
> > +	struct module *mod;
> > +
> > +	preempt_disable();
> 
>   That wants rcu_read_lock()

Thanks. It was wrong anyways for the intended use case, 
switched to module_mutex now.

BTW I think i copied this from somewhere else in module.c
Probably should be fixed there too.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
