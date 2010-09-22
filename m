Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754301Ab0IVNrw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 09:47:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55934 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752543Ab0IVNrv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 09:47:51 -0400
Date: Wed, 22 Sep 2010 09:46:50 -0400
From: Jason Baron <jbaron@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, rusty@rustcorp.co.au,
        rostedt@goodmis.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
        hpa@zytor.com, tglx@linutronix.de, roland@redhat.com, rth@redhat.com,
        mhiramat@redhat.com, fweisbec@gmail.com, avi@redhat.com,
        davem@davemloft.net, vgoyal@redhat.com, sam@ravnborg.org,
        tony@bakeyournoodle.com, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 2/2] Rewrite jump_label.c to use binary search
Message-ID: <20100922134650.GA2816@redhat.com>
References: <1285150102-5506-1-git-send-email-andi@firstfloor.org> <1285150102-5506-2-git-send-email-andi@firstfloor.org> <20100922113114.GA14179@Krystal> <4a8f3ad8416ed61cba1746883da1f839.squirrel@www.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4a8f3ad8416ed61cba1746883da1f839.squirrel@www.firstfloor.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 22, 2010 at 01:56:48PM +0200, Andi Kleen wrote:
> 
> >> +	for (; entry < stop && entry->key == key; entry++)
> >> +		if (kernel_text_address(entry->code))
> >
> > This does not work for modules I'm afraid, only for the core kernel. You
> > should test for __module_text_address() somewhere.
> 
> I thought it was shared now, but ok.
> 
> > Dumb question: why do you need this test at all ?
> 
> I just copied that from the original code. In fact I was wondering
> too why it's needed. Jason?
> 
> 

It was put there for jump labels that are in __init sections. Without 
this check the code will corrupt itself when we toggle a jump label 
after the __init sections have been freed.

thanks,

-Jason

