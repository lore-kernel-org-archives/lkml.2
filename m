Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756589Ab1DFSya (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 14:54:30 -0400
Received: from cantor.suse.de ([195.135.220.2]:34567 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756508Ab1DFSy3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 14:54:29 -0400
Date: Wed, 6 Apr 2011 11:55:25 -0700
From: Greg KH <gregkh@suse.de>
To: Jason Baron <jbaron@redhat.com>
Cc: Joe Perches <joe@perches.com>, LKML <linux-kernel@vger.kernel.org>,
        Roland Vossen <rvossen@broadcom.com>,
        devel <devel@linuxdriverproject.org>
Subject: Re: [Fwd: Fwd: Re: Why is dynamic debug disabled for staging drivers
 ?]
Message-ID: <20110406185525.GA12915@suse.de>
References: <1302104075.1683.46.camel@Joe-Laptop>
 <20110406184158.GA6981@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110406184158.GA6981@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 06, 2011 at 02:41:59PM -0400, Jason Baron wrote:
> The concern I would have in allowing tainted modules is that we are
> relying on a specific format for the dynamic debug section in the
> compiled module. For example, if a module was built with a format with an old
> section, we could potentially get confused. This can be solved with
> versioning, but that adds extra complexity. We can of course also make
> sure we don't change the format...

I wouldn't worry about that at all.  If you try to load a kernel module
that was not built against the kernel you are running, all bets are off
and lots of bad things can happen in other areas.

> Notice that tracepoints, which also rely on a specific module format,
> also employ a taint flag check.

Ok, but TAINT_CRAP shouldn't be part of that check, right?

thanks,

greg k-h
