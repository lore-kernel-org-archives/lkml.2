Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758585Ab1CCSGl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 13:06:41 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53527 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758311Ab1CCSGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 13:06:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=LkwVGSZOWvxm770wzoroiOsFQ6L/jZ+FA9DGtQJy0AarDFjbpnC3TF/dN3HzJMIvjW
         AqgAK1S7ulyqJ733LIsRPpBuqNzU69D6YB3IkizVnP+SaQC91PFuVR/AvQvI4QVVjrv0
         6IfydUJtJJxAtNdQy6w72N89cP8zLqCAMV9b0=
Date: Thu, 3 Mar 2011 19:06:27 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: David Ahern <daahern@cisco.com>
Cc: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        acme@ghostprotocols.net, mingo@elte.hu, peterz@infradead.org,
        paulus@samba.org, tglx@linutronix.de
Subject: Re: [PATCH 3/3] perf script: dump software events and samples from
 hardware-based profiling
Message-ID: <20110303180624.GD1807@nowhere>
References: <1299086960-26964-1-git-send-email-daahern@cisco.com>
 <1299086960-26964-4-git-send-email-daahern@cisco.com>
 <20110303030515.GD1946@nowhere>
 <4D6FA39A.60203@cisco.com>
 <20110303171940.GC1807@nowhere>
 <4D6FD027.3080704@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D6FD027.3080704@cisco.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 03, 2011 at 10:30:15AM -0700, David Ahern wrote:
> On 03/03/11 10:19, Frederic Weisbecker wrote:
> > to use perf_session__resolve_callchain() that resolves the raw struct ip_callchain
> > (only made of raw ips) into a cursor (list of ips resolved into symbols and so) and
> > walk through the cursor with the two accessors.
> > 
> > Ah I forgot, you first need to use callchain_cursor_commit() in order to initialize
> > the position in the cursor.
> > 
> > So:
> > 
> > 1) Resolve with perf_session__resolve_callchain()
> > 2) commit with callchain_cursor_commit()
> > 3) iterate with callchain_cursor_current(), callchain_cursor_advance()
> 
> yes, I figured out the missing commit, and I changed the loop to:
> while (1) {
>     node = callchain_cursor_current(cursor);
>     if (!node)
>         break;
> 
>       ... (print chain)
> 
>     callchain_cursor_advance(cursor);
> }

Yep.

> 
> Thanks for the comments.
> 
> What about the python and perl engines? Right now they are tracepoint
> specific. I do not have a sufficient background in either to expand to
> other sample types.

Not a problem, the new parameters layout paves the way to make it later feasible
if someone is interested.

