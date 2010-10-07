Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933217Ab0JGBVk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 21:21:40 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:57258 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653Ab0JGBVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 21:21:39 -0400
Date: Thu, 7 Oct 2010 02:21:36 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Kees Cook <kees.cook@canonical.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>, "David S. Miller" <davem@davemloft.net>,
        stable@kernel.org
Subject: Re: [PATCH] ipc: initialize structure memory to zero for shmctl
Message-ID: <20101007012136.GS19804@ZenIV.linux.org.uk>
References: <20101007001031.GX14666@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101007001031.GX14666@outflux.net>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 06, 2010 at 05:10:31PM -0700, Kees Cook wrote:
> The old shm interface will leak a few bytes of stack contents. Explicitly
> initialize the structure to zero-fill the untouched fields.

Umm...  I wonder if we ever have gaps in there; note that gaps between
the fields are _not_ initialized in compound literals.  Yes, I realize
that it's a separate problem, but explicit memset() prior to initializations
of fields might be a better solution, covering both.
