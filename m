Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938Ab1DRNPz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 09:15:55 -0400
Received: from ozlabs.org ([203.10.76.45]:41969 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751068Ab1DRNPs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 09:15:48 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Christoph Hellwig <hch@infradead.org>,
        Jan Glauber <jang@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, castet.matthieu@free.fr,
        sliakh.lkml@gmail.com, jiang@cs.ncsu.edu, mingo@elte.hu
Subject: Re: Undoing module RONX protection
In-Reply-To: <20110418092801.GC3837@infradead.org>
References: <20110418092348.GB7786@hal> <20110418092801.GC3837@infradead.org>
User-Agent: Notmuch/0.3.1 (http://notmuchmail.org) Emacs/23.1.1 (i686-pc-linux-gnu)
Date: Mon, 18 Apr 2011 20:13:36 +0930
Message-ID: <874o5v6drb.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Apr 2011 11:23:48 +0200, Jan Glauber <jang@linux.vnet.ibm.com> wrote:
> While debugging I stumbled over two problems in the code that protects module
> pages.
> 
> First issue is that disabling the protection before freeing init or unload of
> a module is not symmetric with the enablement. For instance, if pages are set
> to RO the page range from module_core to module_core + core_ro_size is
> protected. If a module is unloaded the page range from module_core to
> module_core + core_size is set back to RW.
> So pages that were not set to RO are also changed to RW.
> This is not critical but IMHO it should be symmetric.
> 
> Second issue is that while set_memory_rw & set_memory_ro are used for
> RO/RW changes only set_memory_nx is involved for NX/X. One would await that
> the inverse function is called when the NX protection should be removed,
> which is not the case here, unless I'm missing something.
> 
> The following patch addresses both issues. Works on s390. Boot tested on x86.
> 
> Please comment,

Applied, minus the S/390 EXPORT_SYMBOL which Christoph pointed out.  I
turned your mail into the commit message, since it was clearer and more
verbose.  I don't see why they would be different.

Might have been nicer as three separate patches, in future.

Thanks!
Rusty.
