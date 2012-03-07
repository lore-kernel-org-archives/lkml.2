Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758972Ab2CGRNG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 12:13:06 -0500
Received: from kanga.kvack.org ([205.233.56.17]:38006 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755945Ab2CGRNB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 12:13:01 -0500
X-Greylist: delayed 1360 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Mar 2012 12:13:01 EST
Date: Wed, 7 Mar 2012 11:50:18 -0500
From: Benjamin LaHaise <bcrl@kvack.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] aio: fix io_setup/io_destroy race
Message-ID: <20120307165018.GG29014@kvack.org>
References: <20120307051634.GR23916@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120307051634.GR23916@ZenIV.linux.org.uk>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2012 at 05:16:35AM +0000, Al Viro wrote:
> Have ioctx_alloc() return an extra reference, so that caller would drop it
> on success and not bother with re-grabbing it on failure exit.  The current
> code is obviously broken - io_destroy() from another thread that managed
> to guess the address io_setup() would've returned would free ioctx right
> under us; gets especially interesting if aio_context_t * we pass to
> io_setup() points to PROT_READ mapping, so put_user() fails and we end
> up doing io_destroy() on kioctx another thread has just got freed...
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Signed-off-by: Benjamin LaHaise <bcrl@kvack.org>

The fix looks good, and works with a quick test program checking the two cases 
involved (ioctx create success + failure due to PROT_READ).

		-ben
