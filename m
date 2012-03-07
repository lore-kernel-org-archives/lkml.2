Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759550Ab2CGSQX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 13:16:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40304 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759447Ab2CGSQW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 13:16:22 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Benjamin LaHaise <bcrl@kvack.org>, linux-kernel@vger.kernel.org,
        linux-aio@kvack.org
Subject: Re: [PATCH] aio: fix io_setup/io_destroy race
References: <20120307051634.GR23916@ZenIV.linux.org.uk>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 07 Mar 2012 13:16:18 -0500
In-Reply-To: <20120307051634.GR23916@ZenIV.linux.org.uk> (Al Viro's message of
	"Wed, 7 Mar 2012 05:16:35 +0000")
Message-ID: <x49obs8uvil.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro <viro@ZenIV.linux.org.uk> writes:

> Have ioctx_alloc() return an extra reference, so that caller would drop it
> on success and not bother with re-grabbing it on failure exit.  The current
> code is obviously broken - io_destroy() from another thread that managed
> to guess the address io_setup() would've returned would free ioctx right
> under us; gets especially interesting if aio_context_t * we pass to
> io_setup() points to PROT_READ mapping, so put_user() fails and we end
> up doing io_destroy() on kioctx another thread has just got freed...

Al, you certainly are creative.  ;-) I agree with the problem and the
fix.  It would be nice, though if you had added comments.

I ran xfstests ./check -g aio, and there were no problems.

Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
