Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758367Ab0CaWu4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 18:50:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49018 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758335Ab0CaWuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 18:50:54 -0400
Date: Wed, 31 Mar 2010 15:49:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>, Yinghai Lu <yinghai@kernel.org>,
       Rabin Vincent <rabin@rab.in>, lkml <linux-kernel@vger.kernel.org>,
       penberg@cs.helsinki.fi, linux-arch@vger.kernel.org
Subject: Re: start_kernel(): bug: interrupts were enabled early
Message-Id: <20100331154955.54176e5e.akpm@linux-foundation.org>
In-Reply-To: <1270075071.7101.79.camel@pasglop>
References: <20100325194100.GA2364@debian>
	<20100331134048.da4e35a7.akpm@linux-foundation.org>
	<4BB3B4DB.7040904@kernel.org>
	<20100331210145.GB32165@parisc-linux.org>
	<4BB3B8FC.1020608@zytor.com>
	<20100331211754.GC32165@parisc-linux.org>
	<alpine.DEB.2.00.1003311640410.30456@router.home>
	<20100331215411.GB17715@flint.arm.linux.org.uk>
	<4BB3C540.9000405@zytor.com>
	<1270075071.7101.79.camel@pasglop>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 01 Apr 2010 09:37:51 +1100
Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> On Wed, 2010-03-31 at 14:57 -0700, H. Peter Anvin wrote:
> > 
> > The question still remains what the incremental cost is of doing
> > irqsave/irqrestore. 
> 
> The only other option is to have local_irq_enable() check a global
> (system_state ?) before enabling. Almost as gross ...
> 

Add an irq-disable-depth counter to the task_struct, fix all the bugs
which that exposes..

But these things are all utterly gross.  The bottom line is that
radix_tree_init() is manifestly unsuited to being called with local
interrupts disabled.  773e3eb7b81e5ba13b5155dfb3bb75b8ce37f8f9 was just
a wrong patch.

