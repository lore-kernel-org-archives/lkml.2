Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754996Ab1C3AnL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 20:43:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51939 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753442Ab1C3AnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 20:43:09 -0400
Date: Tue, 29 Mar 2011 17:43:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Travis <travis@sgi.com>, Thomas Gleixner <tglx@linutronix.de>,
        Jack Steiner <steiner@sgi.com>,
        Lee Schermerhorn <lee.schermerhorn@hp.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] bitmap, irq: Add smp_affinity_list interface to
 /proc/irq
Message-Id: <20110329174314.80cf7b50.akpm@linux-foundation.org>
In-Reply-To: <20110329165612.bd6ad7e4.akpm@linux-foundation.org>
References: <4D926F6C.8010705@sgi.com>
	<20110329165612.bd6ad7e4.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Mar 2011 16:56:12 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> On Tue, 29 Mar 2011 16:46:52 -0700
> Mike Travis <travis@sgi.com> wrote:
> 
> > +	/* create /proc/irq/<irq>/smp_affinity_list */
> > +	proc_create_data("smp_affinity_list", 0600, desc->dir,
> > +			 &irq_affinity_list_proc_fops, (void *)(long)irq);
> 
> Always document your interfaces, please.  `grep -r smp_affinity
> Documentation' shows where.
> 
> And one we've seen a description of the proposed new interface, we can
> review the patch!

Also, the patch adds a new interface which duplicates an existing one,
only the formats are different, yes?  This is, of course, bad.

The only justification we've seen for being bad is "Manually adjusting
the smp_affinity for IRQ's becomes unwieldy when the cpu count is
large".  A more thorough description of how painful this is might help
motivate people to do bad things to the kernel.

Also, if it's just a matter of an alternative presentation of the data,
why not implement the desired user interface with a little userspace
tool then feed the results down into the existing kernel interface?

