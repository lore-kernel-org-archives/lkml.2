Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753043Ab2HVIcg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 04:32:36 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:48105 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751447Ab2HVIcd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 04:32:33 -0400
Date: Wed, 22 Aug 2012 14:02:25 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev@lists.ozlabs.org, lkml <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
        michael@ellerman.id.au, Ingo Molnar <mingo@elte.hu>,
        peterz@infradead.org, Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: Re: [PATCH v3 2/2] powerpc: Uprobes port to powerpc
Message-ID: <20120822083224.GC29216@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20120726051902.GA29466@in.ibm.com> <20120726052029.GB29466@in.ibm.com> <20120815165931.GA10059@redhat.com> <1345066913.11751.4.camel@pasglop> <20120816050030.GA12060@in.ibm.com> <20120816152112.GA8874@redhat.com> <20120817051307.GA4782@in.ibm.com> <20120817150031.GA5029@redhat.com> <20120821112433.GB3519@in.ibm.com> <20120821130930.GA10382@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120821130930.GA10382@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12082208-1976-0000-0000-00001072C366
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2012 at 03:09:30PM +0200, Oleg Nesterov wrote:

...

> > This is true for Intel like architectures that have *one* swbp
> > instruction. On Powerpc, gdb for instance, can insert a trap variant at
> > the address. Therefore, is_swbp_insn() by definition should return true
> > for all trap variants.
> 
> Not in this case, I think.
> 
> OK, I was going to do this later, but this discussion makes me think
> I should try to send the patch sooner.
> 
> set_swbp()->is_swbp_at_addr() is simply unneeded and in fact should
> be considered as unnecessary pessimization.
> 
> set_orig_insn()->is_swbp_at_addr() makes more sense, but it can't fix
> all races with userpace. Still it should die.
> 
> > OK. I will separate out the is_swbp_insn() change into a separate patch.
> 
> Great thanks. And if we remove is_swbp_insn() from set_swbp() and
> set_orig_insn() then the semantics of is_swbp_insn() will much more
> clear, and in this case I powerpc probably really needs to change it.

Oleg,

I have posted a new version for review [1] without the is_swbp_insn()
change. I will await your changes around is_swbp_at_addr() and make
changes to the powerpc code if necessary.

Regards,
Ananth

[1] https://lists.ozlabs.org/pipermail/linuxppc-dev/2012-August/100524.html

