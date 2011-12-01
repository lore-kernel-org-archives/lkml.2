Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615Ab1LAViT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 16:38:19 -0500
Received: from gate.crashing.org ([63.228.1.57]:46394 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753822Ab1LAViS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 16:38:18 -0500
Message-ID: <1322775468.3729.26.camel@pasglop>
Subject: Re: [BUG?]3.0-rc4+ftrace+kprobe: set kprobe at instruction 'stwu'
 lead to system crash/freeze
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "tiejun.chen" <tiejun.chen@windriver.com>
Cc: Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Anton Blanchard <anton@au1.ibm.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Yong Zhang <yong.zhang0@gmail.com>, paulus@samba.org,
        yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linuxppc-dev@lists.ozlabs.org
Date: Fri, 02 Dec 2011 08:37:48 +1100
In-Reply-To: <4ED75A9A.1030100@windriver.com>
References: <BANLkTi=gx73d6-s-jqeke05SQYorpnzLVw@mail.gmail.com>
	 <1308911347.531.56.camel@gandalf.stny.rr.com>
	 <4E074671.7060100@hitachi.com> <20110627100104.GA24705@in.ibm.com>
	 <BANLkTimYej4_dmBqvPBCLej=JA5atLrZVA@mail.gmail.com>
	 <4E0D9B5E.3010901@windriver.com> <1322626752.21641.22.camel@pasglop>
	 <4ED60E2B.8030603@windriver.com> <1322686809.29041.10.camel@pasglop>
	 <4ED75A9A.1030100@windriver.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-12-01 at 18:44 +0800, tiejun.chen wrote:

> Do you mean we should push the original pt_regs (or that whole exception stack)
> downwards the location the new r1 point? Then its safe to perform this real
> emulated stw instruction. At last we will reroute r1 to that copied exception
> frame to restore as normal. Right?

Right. That way we don't have to modify the (sensitive) restore path, we
only hook around the do_work branch which is a lot easier and less
risky.

> Here I suppose so, I implement this for PPC32 based on the above understanding.
> I take a validation for kprobing do_fork()/show_interrupts(), now looks fine.
> Tomorrow I will go PPC64, and hope its fine as well.
> 
> If everything is good I'll send these patches to linuxppc-dev next week.

Excellent, thanks !

Cheers,
Ben.


