Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754292Ab1A0Ari (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 19:47:38 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33523 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753679Ab1A0Arh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 19:47:37 -0500
Date: Wed, 26 Jan 2011 16:46:50 -0800
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
Message-Id: <20110126164650.ef5bd302.akpm@linux-foundation.org>
In-Reply-To: <20110127002936.GG4981@outflux.net>
References: <20110125181058.GA25670@outflux.net>
	<20110126155706.0188fe02.akpm@linux-foundation.org>
	<20110127002936.GG4981@outflux.net>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Jan 2011 16:29:36 -0800
Kees Cook <kees.cook@canonical.com> wrote:

> > > Note that this changes %x to %p, so some legitimately 0 values in
> > > /proc/kallsyms would have changed from 00000000 to "(null)". To avoid
> > > this, "(null)" is not used when using the "K" format. Anything parsing
> > > such addresses should have no problem with this change. (Thanks to Joe
> > > Perches for the suggestion.)
> > 
> > OK, so what applications did this patch just break?
> 
> I'm not aware of any breakage as a result of this yet.

There will be some - there always are :( But users will only see
problems if they've set kptr_restrict.

Which they shall do.  How come we defaulted kptr_restrict to "true"?
