Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932501Ab2JUS2K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 14:28:10 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:64707 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932387Ab2JUS2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 14:28:08 -0400
Date: Sun, 21 Oct 2012 20:27:56 +0200
From: Rabin Vincent <rabin@rab.in>
To: Dave Martin <dave.martin@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>, oleg@redhat.com
Subject: Re: [PATCH 9/9] ARM: add uprobes support
Message-ID: <20121021182742.GB4840@ubuntu>
References: <1350242593-17761-1-git-send-email-rabin@rab.in>
 <1350242593-17761-9-git-send-email-rabin@rab.in>
 <20121015173147.GA18614@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121015173147.GA18614@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15, 2012 at 06:31:47PM +0100, Dave Martin wrote:
> On Sun, Oct 14, 2012 at 09:23:13PM +0200, Rabin Vincent wrote:
> > +static int uprobe_trap_handler(struct pt_regs *regs, unsigned int instr)
> > +{
> > +	unsigned long flags;
> > +
> > +	local_irq_save(flags);
> > +	if ((instr & 0x0fffffff) == UPROBE_SWBP_INSN)
> 
> Is the check unnecessary here?  I think the same comparison will
> happen as a result of evaluating the associated undef_hook.

The check is there because this uprobe_trap_handler() is registered for
two different undefined instructions: UPROBE_SWBP_INSN (the one which is
used to insert the probe) and UPROBE_SS_INSN (the one placed in the XOL
area for simulating single-stepping).
