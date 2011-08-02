Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666Ab1HBQrT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 12:47:19 -0400
Received: from smtp105.prem.mail.ac4.yahoo.com ([76.13.13.44]:35635 "HELO
	smtp105.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754628Ab1HBQrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 12:47:14 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: PX4am5sVM1knf_5VQJ3nliv1swyTkkFKZ.X5eE1Zkw.Jsjw
 6Fpm.277b6os3ow9JH5dolkrIkso0xynvrruyf2wNS2yLwhnw_ltYZNsP9dn
 WJu9Z14LTqY1HbSU5lw8tyFW1CY4M5Lhww_BNml_VnyQeKFmy7v9wKBBVeqn
 NhrhSAiQvfC9bYOIWVSUtF8s7MWXdmo3HuUuh.qsNWTIXaOkN02Bi9Hgw9fp
 W2b9Pl1qCmV61xz4dY0.VHG3Oa93_apvTQ8cFo6fKqezIZOBMs0QWgUOveAB
 ZU3nLyFrk9vs6y9RwUNvFK97.JYhLpeQ6HpQMN4ElmJOqW_qPjE86E8lLlZ9
 8jW54I7XYbWejcViyIfu4nckk
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 2 Aug 2011 11:47:10 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: David Rientjes <rientjes@google.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, Andi Kleen <andi@firstfloor.org>,
        tj@kernel.org, Metathronius Galabant <m.galabant@googlemail.com>,
        Matt Mackall <mpm@selenic.com>, Eric Dumazet <eric.dumazet@gmail.com>,
        Adrian Drzewiecki <z@drze.net>, linux-kernel@vger.kernel.org
Subject: Re: [slub p3 0/7] SLUB: [RFC] Per cpu partial lists V3
In-Reply-To: <alpine.DEB.2.00.1108020925110.1114@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1108021143310.21126@router.home>
References: <20110801162823.755182213@linux.com> <alpine.DEB.2.00.1108012112420.7373@chino.kir.corp.google.com> <alpine.DEB.2.00.1108020909100.18524@router.home> <alpine.DEB.2.00.1108020925110.1114@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Aug 2011, David Rientjes wrote:

> Aside from per-cpu partial lists, I think this particular benchmark would
> benefit from two other changes on my testing environment:
>
>  - remote cpu freeing so that objects allocated on a different cpu get
>    moved to a separate list that will eventually get flushed back to the
>    origin cpu to be reallocated later with sane heuristics to determine
>    when to take the necessary lock and cacheline bounce, and

Remote cpu should scale better now since we only need to acquire the
cacheline of the page struct exclusively. With per cpu partials the
pressure on the node lock is pretty much gone.

>  - a preference to only pull a slab from the partial lists if there are
>    a sane number of free objects risking perhaps a costly page allocation
>    that will nevertheless allow the fastpaths to be exercised a little
>    more either way (this benchmark suffers horribly when only one or two
>    objects can be allocated from a partial slab).

The partial patch will pull a large number of partial slabs off the per
node list if possible.

> > I am currently reworking the patches to operate on a linked list instead
> > of a very small array of pointers to page structs. That will allow much
> > larger per cpu partial lists and a dynamic configuration of the sizes.
> >
>
> Ok, so is the per-cpu partial list patch in this series worth the review
> or are you going to go under the hood and rework it?

No its not worth it right now. There are already too many changes. I can
send you my current patches if you want to get directly involved.
Certainly would appreciate the help.

