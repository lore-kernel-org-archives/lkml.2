Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932409Ab3AISNt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 13:13:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52616 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932241Ab3AISNs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 13:13:48 -0500
Date: Wed, 9 Jan 2013 19:13:10 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, Frank Eigler <fche@redhat.com>,
        Josh Stone <jistone@redhat.com>,
        "Suzuki K. Poulose" <suzuki@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] uprobes: Teach handler_chain() to filter out the
	probed task
Message-ID: <20130109181310.GA488@redhat.com>
References: <20121229173554.GA2145@redhat.com> <20121229173614.GA2154@redhat.com> <20130108111814.GA1325@linux.vnet.ibm.com> <20130108190018.GA4408@redhat.com> <20130109173918.GL1325@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130109173918.GL1325@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09, Srikar Dronamraju wrote:
>
> * Oleg Nesterov <oleg@redhat.com> [2013-01-08 20:00:18]:
>
> > They shouldn't in any case. To remind, we can optimize filter_chain()
> > for example and avoid the potentially costly uc->filter() call. Say,
> > we can detect/remember the fact that at least one consumre has
> > ->filter == NULL.
> >
> > OTOH, UPROBE_HANDLER_REMOVE is not really pre-filtering (although I think
> > it helps to make the things better). It is more like uprobe_unapply_mm()
> > which (perhaps) we need as well. But doing uprobe_unapply_mm() from
> > uc->handler is a) deadlockable and b) not optimal because it has to
> > consult other consumers.
> >
> > Anyway I agree, the folks writing handlers should understand what do they
> > do ;) and this needs some documentation.
>
> If we document explicitly that filter wont be called, then this should
> be okay.

OK.

Can I take this as your ACK? 

Oleg.

