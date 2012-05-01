Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758026Ab2EANon (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 09:44:43 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:62975 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869Ab2EANom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 09:44:42 -0400
Date: Tue, 1 May 2012 09:44:36 -0400
From: Greg KH <gregkh@linuxfoundation.org>
To: Jim Cromie <jim.cromie@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        Roland Dreier <roland@purestorage.com>,
        Jason Baron <jbaron@redhat.com>, Joe Perches <joe@perches.com>
Subject: Re: [PATCH] dynamic_debug: use printk(KERN_WARNING..) in stub
 function
Message-ID: <20120501134436.GA31954@kroah.com>
References: <1335871392-2222-1-git-send-email-jim.cromie@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335871392-2222-1-git-send-email-jim.cromie@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 01, 2012 at 05:23:12AM -0600, Jim Cromie wrote:
> drivers/infiniband/ulp/srp/ib_srp.c #defines pr_fmt() PFX fmt, but PFX
> is not #defined until after <linux/*> headers are included.
> 
> This results in a bad expansion of the pr_warn() in the stub function.
> 
> 2084c2084
> <   printk("<4>" PFX "dyndbg supported only in " "CONFIG_DYNAMIC_DEBUG builds\n")
> ---
> >   printk("<4>" "guano" "dyndbg supported only in " "CONFIG_DYNAMIC_DEBUG builds\n")
> (END)
> 
> While that use-case is less than ideal, it will probably happen again,
> and its easy to avoid by using raw printk().

Thanks, now applied.

greg k-h
