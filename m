Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756512Ab1BRKb3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 05:31:29 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:41851 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745Ab1BRKb0 (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:5:1>);
	Fri, 18 Feb 2011 05:31:26 -0500
Message-Id: <4D5E58C10200007800032A80@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Fri, 18 Feb 2011 10:32:17 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: <arjan@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>
Cc: <mingo@elte.hu>, <tony.luck@intel.com>, <tglx@linutronix.de>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] x86-64: use relative 32-bit pointers in
	 exception  tables
References: <4D5D62EE02000078000327E7@vpn.id2.novell.com>
 <4D5DFA41.9060207@zytor.com> 
In-Reply-To: 
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 18.02.11 at 10:34, Jan Beulich wrote:
> >>> On 18.02.11 at 05:49, "H. Peter Anvin" <hpa@zytor.com> wrote:
> > This breaks arch/x86/kernel/test_nx.c:
> > 
> > /home/hpa/kernel/linux-2.6-tip.asm/arch/x86/kernel/test_nx.c: In
> > function ‘fudze_exception_table’:
> > /home/hpa/kernel/linux-2.6-tip.asm/arch/x86/kernel/test_nx.c:62: error:
> > ‘struct exception_table_entry’ has no member named ‘insn’
> > make[4]: *** [arch/x86/kernel/test_nx.o] Error 1
> > make[3]: *** [arch/x86/kernel] Error 2
> > make[2]: *** [arch/x86] Error 2
> > make[2]: *** Waiting for unfinished jobs....
> 
> And rightly so: The code inserts pointers into stack and heap,
> which clearly can't be expressed as relative 32-bit pointers. The
> question now is whether I should drop the whole idea, or
> whether the hackish test code could get dropped (until someone
> can come up with a better idea than patching the module's
> exception table) for x86-64.

With CONFIG_DEBUG_SET_MODULE_RONX=y that test is broken
(it oopses) currently anyway, so I'm even more tempted to
suppress rather than fix it.

Jan

