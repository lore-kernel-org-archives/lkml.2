Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756918Ab3AHSNn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 13:13:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24388 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756712Ab3AHSNm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 13:13:42 -0500
Date: Tue, 8 Jan 2013 19:13:03 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, Frank Eigler <fche@redhat.com>,
        Josh Stone <jistone@redhat.com>,
        "Suzuki K. Poulose" <suzuki@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7] uprobes: Do not allocate current->utask unnecessary
Message-ID: <20130108181303.GB1048@redhat.com>
References: <20121231175150.GA32066@redhat.com> <20121231175229.GA32115@redhat.com> <20130108122013.GI1325@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130108122013.GI1325@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08, Srikar Dronamraju wrote:
>
> * Oleg Nesterov <oleg@redhat.com> [2012-12-31 18:52:29]:
>
> >  static void handle_swbp(struct pt_regs *regs)
> >  {
> > -	struct uprobe_task *utask;
> >  	struct uprobe *uprobe;
> >  	unsigned long bp_vaddr;
> >  	int uninitialized_var(is_swbp);
> > @@ -1512,19 +1515,12 @@ static void handle_swbp(struct pt_regs *regs)
> >  	if (unlikely(!test_bit(UPROBE_COPY_INSN, &uprobe->flags)))
> >  		goto out;
> >
> > -	utask = get_utask();
> > -	if (!utask)
> > -		goto out;	/* re-execute the instruction. */
> > -
>
> If get_utask fails with the above change, Dont we end up calling
> handler_chain twice(or more)?.

After restart, yes.

> I think this is probably true with
> previous patch too.

And this can happen with the current code too, if xol_alloc_area()
fails. So I think this is probably fine. Besides, if GFP_KERNEL
fails the task should be oom-killed in practice.

Oleg.

