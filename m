Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751252Ab1F1VKz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 17:10:55 -0400
Received: from smtp-out.google.com ([216.239.44.51]:54413 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819Ab1F1VKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 17:10:51 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=oqYv0WtRgZqpDvsExj7h6NxYYx/L5alMGFAr1GQmRe30EH12RSWUXCxL+JSxshjag
	1vOfAIZ06fi5a2JTJiTuQ==
Date: Tue, 28 Jun 2011 14:10:42 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Ben Greear <greearb@candelatech.com>
cc: David Daney <ddaney.cavm@gmail.com>, Christoph Lameter <cl@linux.com>,
        Marcin Slusarz <marcin.slusarz@gmail.com>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH] slub: reduce overhead of slub_debug
In-Reply-To: <4E0A41CB.1020908@candelatech.com>
Message-ID: <alpine.DEB.2.00.1106281405000.4229@chino.kir.corp.google.com>
References: <20110626193918.GA3339@joi.lan> <alpine.DEB.2.00.1106281431370.27518@router.home> <4E0A2E26.5000001@gmail.com> <alpine.DEB.2.00.1106281355010.4229@chino.kir.corp.google.com> <4E0A41CB.1020908@candelatech.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Jun 2011, Ben Greear wrote:

> > SLUB debugging is useful only to diagnose issues or test new code, nobody
> > is going to be enabling it in production environment.  We don't need 30
> > new lines of code that make one thing slightly faster, in fact we'd prefer
> > to have as simple and minimal code as possible for debugging features
> > unless you're adding more debugging coverage.
> 
> If your problem happens under load, then the overhead of slub could
> significantly
> change the behaviour of the system.

You're talking about slub debugging and not slub in general, I assume.

> Anything that makes it more efficient
> without
> unduly complicating code should be a win.  That posted patch wasn't all that
> complicated, and even if it has bugs, it could be fixed easily enough.
> 

"Even if it has bugs"?  Ask Pekka to merge this and be on the receiving 
end of every other kernel development's flames when slub debugging no 
longer finds their problems but instead has bugs of its own.

Again, we want simple and minimal slub debugging code unless you're adding 
a new feature.
