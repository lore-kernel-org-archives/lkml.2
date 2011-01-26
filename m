Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754434Ab1AZX5y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 18:57:54 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55027 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754279Ab1AZX5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 18:57:53 -0500
Date: Wed, 26 Jan 2011 15:57:06 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Kees Cook <kees.cook@canonical.com>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        Tejun Heo <tj@kernel.org>, Marcus Meissner <meissner@suse.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        Eugene Teo <eugeneteo@kernel.org>, Joe Perches <joe@perches.com>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>, Len Brown <len.brown@intel.com>,
        Changli Gao <xiaosuo@gmail.com>,
        Dan Rosenberg <drosenberg@vsecurity.com>
Subject: Re: [PATCH] use %pK for /proc/kallsyms and /proc/modules
Message-Id: <20110126155706.0188fe02.akpm@linux-foundation.org>
In-Reply-To: <20110125181058.GA25670@outflux.net>
References: <20110125181058.GA25670@outflux.net>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Jan 2011 10:10:58 -0800
Kees Cook <kees.cook@canonical.com> wrote:

> Instead of messing with permissions on these files,

This implies that the patch alters permission handling, only it
doesn't.  But I worked it out!

> use %pK for kernel
> addresses to reduce potential information leaks that might be used to
> help target kernel privilege escalation exploits.
> 
> Note that this changes %x to %p, so some legitimately 0 values in
> /proc/kallsyms would have changed from 00000000 to "(null)". To avoid
> this, "(null)" is not used when using the "K" format. Anything parsing
> such addresses should have no problem with this change. (Thanks to Joe
> Perches for the suggestion.)
> 
> Note that when compiling with -Wformat, these harmless warnings will
> be emitted, and can be ignored:
>   warning: '0' flag used with ___%p___ gnu_printf format

OK, so what applications did this patch just break?
