Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760719Ab2D0Qeg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 12:34:36 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58389 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754460Ab2D0Qef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 12:34:35 -0400
Date: Fri, 27 Apr 2012 09:34:30 -0700
From: Tejun Heo <tj@kernel.org>
To: Yanmin Zhang <yanmin_zhang@linux.intel.com>
Cc: ShuoX Liu <shuox.liu@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: percpu: Add PCPU_FC_FIXED to pcpu_fc for setting
 fixed pcpu_atom_size.
Message-ID: <20120427163430.GQ27486@google.com>
References: <4F97BA98.6010001@intel.com>
 <20120425222429.GE8989@google.com>
 <1335405672.14538.135.camel@ymzhang.sh.intel.com>
 <20120426224946.GG27486@google.com>
 <1335488964.14538.159.camel@ymzhang.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335488964.14538.159.camel@ymzhang.sh.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Apr 27, 2012 at 09:09:24AM +0800, Yanmin Zhang wrote:
> > > We can't fix FC_PAGE power regression. If we do so, we need contact many
> > > hardware architects. Current kernel supports FC_PAGE and PMD_SIZE, why
> > > not to allow admin to choose other values?
> > 
> > If this is something which is met in the field commonly, we need to
> > fix the default behavior rather than introducing some arcane boot
> > param.
>
> We just add a new value input method instead of introducing new parameter.

Ummm... I don't know what you meant by the above sentence but adding a
new magic kernel param whether it's part of an existing one or not, is
not a good solution.  They're difficult to discover and not many
actually understand what they do.  If you *have* to add some, then you
better make it clear where it's being applied for what.  ie. in this
case, add something like x86_percpu_embed_unit_size.

> >   IIRC, the reasons PMD_SIZE is used for atom_size are so that
> > percpu areas are aligned to PSE mapping, maybe later we can make use
> > of PSE mapping in vmalloc area too, and it didn't seem to hurt
> > anything.
>
> Well, vmalloc area might use different prot to map physical pages.
> So sharing one PMD huge page by many vmalloc areas might be not good.

Percpu allocator uses the whole vmalloc chunk, so there's no prot
problem.  They're all percpu memory.

Thanks.

-- 
tejun
