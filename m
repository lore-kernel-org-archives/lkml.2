Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752382Ab2A3RXB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 12:23:01 -0500
Received: from smtp107.prem.mail.ac4.yahoo.com ([76.13.13.46]:20085 "HELO
	smtp107.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751749Ab2A3RXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 12:23:00 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: pGISlH4VM1ldIaVzwHrU7jDgdBcFadlytYDmEg.UuFqH7qW
 q6cxlpY.Y6iqtVxpeL0cZqWfvi_vqQU2j4cG2Pi7yYzT3ZpM3qVKcvU2._bx
 3limNQ0qdT.ro0jVNrDp2swl6PXjwUenook.KbPfxBYEiNd2VMtW3qAXFKHK
 kURHS6GbI1UO3cWTyEU.u8_xWi04Mr28gGnpKUXaMpSmao7xmyjuw4yNPGzQ
 yqX8DnjCYjCow8vUvSRaRrfz8o6Djhqt1Q6Nnj.3iYw7ulv7Fr.r1kWher6D
 22PuJAsQU66QgEvGxuqmlguOLct96mgZ8cDKGbKILTA6s8y.SH_YypcdRzAc
 MCjq_eUNGILKA_U.oU4g0RR9hhHBhui5IFnF4TzTGs5IHo8CWJiqLjdQXmG4
 Q
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Mon, 30 Jan 2012 11:22:57 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Tejun Heo <tj@kernel.org>
cc: Dmitry Antipov <dmitry.antipov@linaro.org>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, patches@linaro.org,
        linaro-dev@lists.linaro.org
Subject: Re: [PATCH 1/3] percpu: use ZERO_SIZE_PTR / ZERO_OR_NULL_PTR
In-Reply-To: <20120130171919.GC3355@google.com>
Message-ID: <alpine.DEB.2.00.1201301122410.28693@router.home>
References: <1327912654-8738-1-git-send-email-dmitry.antipov@linaro.org> <20120130171558.GB3355@google.com> <20120130171919.GC3355@google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jan 2012, Tejun Heo wrote:

> On Mon, Jan 30, 2012 at 09:15:58AM -0800, Tejun Heo wrote:
> > Percpu pointers are in a different address space and using
> > ZERO_SIZE_PTR directly will trigger sparse address space warning.
> > Also, I'm not entirely sure whether 16 is guaranteed to be unused in
> > percpu address space (maybe it is but I don't think we have anything
> > enforcing that).
>
> Another thing is that percpu address dereferencing always goes through
> rather unintuitive translation and 1. we can't (or rather currently
> don't) guarantee that fault will occur for any address 2. even if it
> does, the faulting address wouldn't be anything easily
> distinguishible.  So, unless the above shortcomings is resolved, I
> don't really see much point of using ZERO_SIZE_PTR for percpu
> allocator.

The same is true for the use of NULL pointers.

