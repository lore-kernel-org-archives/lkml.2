Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855Ab0JSBMN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 21:12:13 -0400
Received: from verein.lst.de ([213.95.11.210]:55120 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754077Ab0JSBMM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 21:12:12 -0400
Date: Tue, 19 Oct 2010 03:11:25 +0200
From: Christoph Hellwig <hch@lst.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Richard Weinberger <richard@nod.at>, linux-kernel@vger.kernel.org,
        jdike@addtoit.com, user-mode-linux-devel@lists.sourceforge.net,
        viro@zeniv.linux.org.uk, toralf.foerster@gmx.de,
        Christoph Hellwig <hch@lst.de>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 1/1] hostfs: fix UML crash
Message-ID: <20101019011125.GA3905@lst.de>
References: <1287419814-20086-1-git-send-email-richard@nod.at> <20101018114039.503233da.akpm@linux-foundation.org> <201010182053.58496.richard@nod.at> <20101018130208.7b552527.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101018130208.7b552527.akpm@linux-foundation.org>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 18, 2010 at 01:02:08PM -0700, Andrew Morton wrote:
> > > 
> > > Is there any reason for hostfs to be playing with the f_spare field at all?

No, there is no reason at all.  do_statfs is only called by
hostfs_statfs, which is the hostfs implementation of ->statfs.  zeroing
of the spare fields is done by common code (vfs_statfs_native).

Can you submit a patch to just remove the spare_out argument to do_statfs?

> 365b1818 added f_flags to `struct statfs' but didn't carry that over to
> `struct compat_statfs' and hence didn't copy f_flags over into
> compat_statfs.  Deliberate, or oversight?

Oversight.
