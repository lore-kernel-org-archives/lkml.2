Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759672Ab0JGCNX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 22:13:23 -0400
Received: from smtp.outflux.net ([198.145.64.163]:46821 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752477Ab0JGCNW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 22:13:22 -0400
Date: Wed, 6 Oct 2010 19:13:11 -0700
From: Kees Cook <kees.cook@canonical.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>, "David S. Miller" <davem@davemloft.net>,
        stable@kernel.org
Subject: Re: [PATCH] ipc: initialize structure memory to zero for shmctl
Message-ID: <20101007021311.GZ14666@outflux.net>
References: <20101007001031.GX14666@outflux.net>
 <20101007012136.GS19804@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101007012136.GS19804@ZenIV.linux.org.uk>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Al,

On Thu, Oct 07, 2010 at 02:21:36AM +0100, Al Viro wrote:
> On Wed, Oct 06, 2010 at 05:10:31PM -0700, Kees Cook wrote:
> > The old shm interface will leak a few bytes of stack contents. Explicitly
> > initialize the structure to zero-fill the untouched fields.
> 
> Umm...  I wonder if we ever have gaps in there; note that gaps between
> the fields are _not_ initialized in compound literals.  Yes, I realize
> that it's a separate problem, but explicit memset() prior to initializations
> of fields might be a better solution, covering both.

Excellent point. I'll resend with a memset.

-- 
Kees Cook
Ubuntu Security Team
