Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756785Ab3AHR6x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 12:58:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26414 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756231Ab3AHR6w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 12:58:52 -0500
Date: Tue, 8 Jan 2013 18:58:22 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, Frank Eigler <fche@redhat.com>,
        Josh Stone <jistone@redhat.com>,
        "Suzuki K. Poulose" <suzuki@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] uprobes: Move alloc_page() from xol_add_vma() to
	xol_alloc_area()
Message-ID: <20130108175822.GA1048@redhat.com>
References: <20121231175150.GA32066@redhat.com> <20121231175212.GA32088@redhat.com> <20130108114607.GD1325@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130108114607.GD1325@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08, Srikar Dronamraju wrote:
>
> (One simple check below)
>
> Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

Thanks,

> > @@ -1072,11 +1064,8 @@ static int xol_add_vma(struct xol_area *area)
> >  	smp_wmb();	/* pairs with get_xol_area() */
> >  	mm->uprobes_state.xol_area = area;
> >  	ret = 0;
> > -
> > -fail:
> > + fail:
>
> Not sure if the space before label is intentional?
> Its true of other labels below also.

Yes, this was intentional although almost subconscious.

Personally I prefer to add a space before the label, this helps
/usr/bin/diff to not confuse this label with the function name.

But I can stop this if you dislike.

Oleg.

