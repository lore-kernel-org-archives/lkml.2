Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937503Ab0CPHOR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 03:14:17 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:38271 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756111Ab0CPHOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 03:14:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=NirlvPTop92Esq9TTXcNNlMJnXslD8wMvvNgkKz/mbETQZIZJPNRL0PGwNVzEsXx+i
         lQ67YRK7e/yNSCNjsaGHQEdfG9Frj5ipjdX3rKxWmHtqowVtgXM130BY+WJyrXoEgXXe
         CByRFPyZCRvUS0EGgy4KgqwKZoAidKsAhLie0=
MIME-Version: 1.0
In-Reply-To: <20100316061718.GA22651@elte.hu>
References: <4B990496.4020002@kernel.org> <4B9F08AC.9030904@kernel.org>
	 <20100316061718.GA22651@elte.hu>
Date: Tue, 16 Mar 2010 09:14:12 +0200
Message-ID: <b6fcc0a1003160014h79098b50t87a448285350b3e@mail.gmail.com>
Subject: Re: [RFC] remove implicit slab.h inclusion from percpu.h
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Christoph Lameter <cl@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 16, 2010 at 8:17 AM, Ingo Molnar <mingo@elte.hu> wrote:
> Also, why should we make this opt-in and expose a wide range of configs to
> build breakages?

Because we want to #include less, not the same amount.

> A more gradual approach would be to write a simple script
> that adds a slab.h include to all .c's that include percpu.h, directly or
> indirectly.

As a defensive measure, one can explicitly add slab.h to every file
which uses kmalloc/kfree.

But, who cares, since one still has to compile test regardless.
