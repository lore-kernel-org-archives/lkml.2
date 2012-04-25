Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758851Ab2DYUdk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 16:33:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15674 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758800Ab2DYUdj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 16:33:39 -0400
Date: Wed, 25 Apr 2012 16:03:32 -0400
From: Josef Bacik <josef@redhat.com>
To: Jim Meyering <jim@meyering.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] Btrfs: avoid buffer overrun in mount option handling
Message-ID: <20120425200330.GC17006@localhost.localdomain>
References: <87mx5z1teu.fsf@rho.meyering.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87mx5z1teu.fsf@rho.meyering.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2012 at 09:51:53PM +0200, Jim Meyering wrote:
> 
> There is an off-by-one error: allocating room for a maximal result
> string but without room for a trailing NUL.  That, can lead to
> returning a transformed string that is not NUL-terminated, and then
> to a caller reading beyond end of the malloc'd buffer.
> 
> Worse still, we could write one non-NUL byte beyond the end of that
> malloc'd result buffer when given a mount option of "subvol=," (i.e.,
> no arg after the "=") because here the replacement "subvolid=0" is 3
> bytes longer, not just 2.

So this can't happen, since it would be caught by btrfs_parse_early_options
which expects subvolid=%d, and if it doesn't get that it would just error out,
so while adding another byte isn't bad, it's not correct either, so fix that and
I'd say it's good to go.  Thanks,

Josef
