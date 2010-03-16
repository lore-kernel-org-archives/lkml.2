Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965453Ab0CPIcZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 04:32:25 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:32900 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450Ab0CPIcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 04:32:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=vEq0K7anzxiuOw0jXhighcI0eXA4GEzdFyrFDrJcMQbVa2RsvAFq12vl1aoF8bQURR
         /hpRJ6fUIDPjwNL+RNNUr6XuG9Kh7/2vMTk4LMOa8X3Dz74w+DEHayovtFvHOKZiBGY0
         US2KIBPu9wY5Q6QsIwF7D0rNZ5I5kivZVpjEo=
MIME-Version: 1.0
In-Reply-To: <20100316075726.GE18448@elte.hu>
References: <4B990496.4020002@kernel.org> <4B9F08AC.9030904@kernel.org>
	 <20100316061718.GA22651@elte.hu> <4B9F2B0A.70507@kernel.org>
	 <4B9F36C7.4020304@kernel.org> <20100316075726.GE18448@elte.hu>
Date: Tue, 16 Mar 2010 10:32:21 +0200
Message-ID: <b6fcc0a1003160132m62b2b2a1x28dbe6b99e74abf5@mail.gmail.com>
Subject: Re: [RFC] remove implicit slab.h inclusion from percpu.h
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Christoph Lameter <cl@linux-foundation.org>, penberg@cs.helsinki.fi
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 16, 2010 at 9:57 AM, Ingo Molnar <mingo@elte.hu> wrote:
> Well, that's the main question: do we want all-in-one big headers like
> kernel.h (and sched.h / mm.h) or not?

It's question only for you.

There are observations, like sched.h includes some VM routines which
better live in mm.h and some some cred/UID routines which better live
in cred.h and sched.h unnecessarily includes capability.h which wasn't
removed after "struct cred" inclusion.

> If we want to avoid combo .h files then we inevitably want to go for
> finegrained, per subsystem data type and API definitions - i.e. explicit
> slab.h inclusion in the .c file.

The problem is that slab.h is included unnecessarily in some other headers
conditionally and unconditionally.

It's amazing to see how much sidework people are willing to create
to _not_ do simple and obvious thing -- just remove slab.h.
