Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756027Ab1AaT2V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 14:28:21 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:52314 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753746Ab1AaT2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 14:28:19 -0500
Subject: Re: Q: perf_install_in_context/perf_event_enable are racy?
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Alan Stern <stern@rowland.harvard.edu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>, Prasad <prasad@linux.vnet.ibm.com>,
        Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20110131191109.GA10906@redhat.com>
References: <1296134077.15234.161.camel@laptop>
	 <20110127165712.GC25060@redhat.com> <1296148294.15234.242.camel@laptop>
	 <20110127221856.GA10539@redhat.com> <1296215577.15234.333.camel@laptop>
	 <1296226667.15234.337.camel@laptop> <20110128162847.GA25088@redhat.com>
	 <1296238278.15234.340.camel@laptop> <20110131172626.GA5407@redhat.com>
	 <1296498205.26581.54.camel@laptop>  <20110131191109.GA10906@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 31 Jan 2011 20:29:14 +0100
Message-ID: <1296502154.26581.72.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-01-31 at 20:11 +0100, Oleg Nesterov wrote:
> 
> > > >   raw_spin_lock(&ctx->lock);
> > > > - ctx->is_active = 1;
> > > > + WARN_ON_ONCE(!ctx->is_active);
> > >
> > > This looks wrong if ctx->task == NULL.
> >
> > cpuctx->ctx should still have ->is_active = 1 I think.
> 
> Unless this is the first cpu counter, no? 

Ah, indeed.. 

