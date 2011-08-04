Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754958Ab1HDWya (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 18:54:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50426 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753288Ab1HDWyY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 18:54:24 -0400
Date: Thu, 4 Aug 2011 15:54:18 -0700
From: Greg KH <gregkh@suse.de>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] devtmpfs: Fix section mismatch on devtmpfsd()
Message-ID: <20110804225418.GA2505@suse.de>
References: <1312497371-25685-1-git-send-email-grant.likely@secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312497371-25685-1-git-send-email-grant.likely@secretlab.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 04, 2011 at 11:36:11PM +0100, Grant Likely wrote:
> devtmpfsd_init() references setup_done which is __initdata, but
> devtmpfsd() is not an __init function.  The code is fine, because it
> is never referenced after discarding __init sections, but it leaves
> some additional code that can be discarded with the rest of __init and
> it causes gcc to complain with a section mismatch warning.

I have a simpler patch here that just removes the __initdata function,
which is simpler.

I hate the initdata stuff, it's almost always pointless...

Would that solve the problem for you as well?

thanks,

greg k-h
