Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162160Ab2CSQo6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 12:44:58 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:33306 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030659Ab2CSQo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 12:44:57 -0400
Date: Mon, 19 Mar 2012 16:44:51 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Richard Weinberger <richard@nod.at>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for Mar 19 (uml)
Message-ID: <20120319164451.GI6589@ZenIV.linux.org.uk>
References: <20120319184830.fce597a16eaf7206195a7a45@canb.auug.org.au>
 <4F674A2D.5080504@xenotime.net>
 <4F675B78.8060300@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F675B78.8060300@nod.at>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2012 at 05:14:48PM +0100, Richard Weinberger wrote:
> Looks like this commit introduced the issue:
> 
> commit 1ed71e0439cba3609d3c69bf04795e0389cd35e4
> Author: Al Viro <viro@zeniv.linux.org.uk>
> Date:   Thu Feb 23 01:33:19 2012 -0500
> 
>     um: embed ->stub_pages[] into mmu_context
> 
>     seriously, kmalloc() for two-element array of pointers?
> 
>     Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> 
> The size of struct page is not known to all users of asm/mmu.h

Aaargh...  Dumb braino, fixed in the local queue back in Feb 25, fix
not folded into commit and missed on cherry-pick ;-/

It's
        struct page *stub_pages[2];
of course...

OK, fix properly folded into that sucker, for-next repushed.
