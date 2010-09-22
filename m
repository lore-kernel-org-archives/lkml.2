Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755148Ab0IVPHy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 11:07:54 -0400
Received: from tomts10-srv.bellnexxia.net ([209.226.175.54]:40514 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755101Ab0IVPHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 11:07:52 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAL63mUxGGN6i/2dsb2JhbACiLnLEGIVBBI8w
Date: Wed, 22 Sep 2010 11:02:50 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andi Kleen <andi@firstfloor.org>
Cc: jbaron@redhat.com, rusty@rustcorp.co.au, rostedt@goodmis.com,
        linux-kernel@vger.kernel.org, mingo@elte.hu, hpa@zytor.com,
        tglx@linutronix.de, roland@redhat.com, rth@redhat.com,
        mhiramat@redhat.com, fweisbec@gmail.com, avi@redhat.com,
        davem@davemloft.net, vgoyal@redhat.com, sam@ravnborg.org,
        tony@bakeyournoodle.com, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 2/2] Rewrite jump_label.c to use binary search
Message-ID: <20100922150250.GB4897@Krystal>
References: <1285150102-5506-1-git-send-email-andi@firstfloor.org> <1285150102-5506-2-git-send-email-andi@firstfloor.org> <20100922113114.GA14179@Krystal> <4a8f3ad8416ed61cba1746883da1f839.squirrel@www.firstfloor.org> <589c3dd38437c80704d8224523efbccc.squirrel@www.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <589c3dd38437c80704d8224523efbccc.squirrel@www.firstfloor.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 11:01:29 up 168 days, 52 min,  3 users,  load average: 0.07,
	0.12, 0.09
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andi Kleen (andi@firstfloor.org) wrote:
> 
> >
> >>> +	for (; entry < stop && entry->key == key; entry++)
> >>> +		if (kernel_text_address(entry->code))
> >>
> >> This does not work for modules I'm afraid, only for the core kernel. You
> >> should test for __module_text_address() somewhere.
> >
> > I thought it was shared now, but ok.
> 
> Double checked. This is ok because kernel_text_address()
> already checks for modules. You were probably thinking
> of __kernel_text_address()

Ah right,

Although we have another problem:

__module_text_address() includes module init text, which defeats the
purpose of the check put in there by Jason.

So the check works for the core kernel, but not for modules.

Mathieu

> 
> -Andi
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
