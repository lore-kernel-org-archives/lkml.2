Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218Ab1BGQ6b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 11:58:31 -0500
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:29256 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753880Ab1BGQ63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 11:58:29 -0500
Date: Mon, 7 Feb 2011 08:58:29 -0800
From: Dmitry Torokhov <dtor@vmware.com>
To: David Miller <davem@davemloft.net>
Cc: "schwab@linux-m68k.org" <schwab@linux-m68k.org>,
        "geert@linux-m68k.org" <geert@linux-m68k.org>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-m68k@vger.kernel.org" <linux-m68k@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
Subject: Re: Early crash
Message-ID: <20110207165829.GA13101@dtor-ws.eng.vmware.com>
References: <m2bp2udllv.fsf@igel.home>
 <20110203002459.GA26729@dtor-ws.eng.vmware.com>
 <20110207081933.GA11855@dtor-ws.eng.vmware.com>
 <20110207.005010.28814928.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110207.005010.28814928.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 07, 2011 at 12:50:10AM -0800, David Miller wrote:
> From: Dmitry Torokhov <dtor@vmware.com>
> Date: Mon, 7 Feb 2011 00:19:33 -0800
> 
> > So here is the patch that explicitly specifies alignment for struct
> > module_version_attribute. I tested it on i386 and x86_64 and I believe
> > it will fix the issue with m68k but I do not have access to such a box.
> 
> While this may or may not fix the m68k issue, this isn't really
> sufficient to make this thing work in all cases.  And the older
> tracepoint commits referenced in this thread are known to cause
> problems with platforms such as sparc64.
> 
> You can't reliably put structures into independent objects, put them
> into a special section, and then expect array access over them (via
> the section boundaries) after linking the objects together to just
> "work".
> 
> Your attribute specification is only a lower-bound.

Right.

> 
> GCC can and does use variable alignment choices in different situations,
> so the align directive in the various objects can all be different.  So
> the array iteration will assume the iterations should use one object
> size, but within the linked together section the alignments are all
> different so the inter-struct gap is different.
> 
> The only portable mechanism that will work in all cases, as we've
> found recently for tracepoints and similar, is to make an array of
> plain pointers to the objects in the special section.

But, theoretically speaking, nothing stops GCC to align pointers with
"gaps" as well? Let's say having everything (or some) aligned on
quadword boundary even though arch is 32 bit?


Thanks,

Dmitry
