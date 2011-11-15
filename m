Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932450Ab1KOVUU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 16:20:20 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51800 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932405Ab1KOVUT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 16:20:19 -0500
Date: Tue, 15 Nov 2011 13:20:12 -0800
From: Greg KH <gregkh@suse.de>
To: Alessandro Rubini <rubini@gnudd.com>
Cc: linux-kernel@vger.kernel.org, giancarlo.asnaghi@st.com
Subject: Re: [RFC PATCH] debugfs: add tools to printk 32-bit registers
Message-ID: <20111115212012.GA5467@suse.de>
References: <20111115130230.GA23584@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111115130230.GA23584@mail.gnudd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 15, 2011 at 02:02:30PM +0100, Alessandro Rubini wrote:
> Some debugfs file I deal with are mostly blocks of registers,
> i.e. lines of the form "<name> = 0x<value>". Some files are only
> registers, some include registers blocks among other material.  This
> patch introduces data structures and functions to deal with both
> cases.  I expect more users of this over time.

Nice, but a few minor questions:

> +/*
> + * The regset32 stuff is used to print 32-bit registers using the
> + * seq_file utilities. We offer printing a register set in an already-opened
> + * sequential file or create a debugfs file that only prints a regset32.
> + */

Can this be part of the kerneldoc below somehow so that people are more
aware of it?

> +
> +/**
> + * debugfs_print_regs32 - use seq_print to describe a set of registers
> + * @s: the seq_file structure being used to generate output
> + * @regs: an array if struct debugfs_reg32 structures
> + * @mregs: the length of the above array
> + * @base: the base address to be used in reading the registers
> + * @prefix: a string to be prefixed to every output line
> + *
> + * This function outputs a text block describing the current values of
> + * some 32-bit hardware registers. It is meant to be used within debugfs
> + * files based on seq_file that need to show registers, intermixed with other
> + * information. The prefix argument may be used to specify a leading string,
> + * because some peripherals have several blocks of identical registers,
> + * for example configuration of dma channels
> + */
> +int debugfs_print_regs32(struct seq_file *s, struct debugfs_reg32 *regs,
> +			   int nregs, void __iomem *base, char *prefix)
> +{
> +	int i, ret = 0;
> +
> +	for (i = 0; i < nregs; i++, regs++) {
> +		if (prefix)
> +			ret += seq_printf(s, "%s", prefix);
> +		ret += seq_printf(s, "%s = 0x%08x\n", regs->name,
> +				  readl((void *)(base + regs->offset)));
> +	}
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(debugfs_print_regs32);

This function also needs to be part of debugfs.h in the "debugfs is not
enabled" section of the file, right?

thanks,

greg k-h
