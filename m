Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755106Ab0GLGll (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 02:41:41 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:49530 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754684Ab0GLGlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 02:41:39 -0400
Date: Mon, 12 Jul 2010 15:41:26 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ian Munsie <imunsie@au.ibm.com>,
        Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [PATCH] perf: Add DWARF register lookup for SH
Message-ID: <20100712064126.GA3716@linux-sh.org>
References: <e55812819ad18c2ceca5651ac7698a2af46180d7.1278774279.git.matt@console-pimps.org> <4C3A75E3.6070803@hitachi.com> <87lj9h8bgv.fsf@linux-g6p1.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87lj9h8bgv.fsf@linux-g6p1.site>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 12, 2010 at 07:23:44AM +0100, Matt Fleming wrote:
> On Mon, 12 Jul 2010 10:54:43 +0900, Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
> > Matt Fleming wrote:
> > > Implement get_arch_regstr() for SH so that, given a DWARF register
> > > number, the corresponding symbolic name of that register can be looked
> > > up.
> > 
> > OK, the patch itself looks good, but I don't know whether SH kernel
> > supports KPROBE_EVENT which is required for perf-probe. Or, SH kernel
> > repository already has it?
> 
> No, SH doesn't support KPROBE_EVENT yet. It's on my list of things to
> do. However, this patch also stops the "DWARF register mappings have not
> been defined" warning when building perf.

It does now, by virtue of HAVE_REGS_AND_STACK_ACCESS_API. The initial
support for this was checked in on June 14th, so you should be able to
use it already as long as you're working with current HEAD.
