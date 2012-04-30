Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755667Ab2D3NmT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 09:42:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3441 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752432Ab2D3NmS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 09:42:18 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Jan Kara <jack@suse.cz>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-man@vger.kernel.org,
        linux-mm@kvack.org, mgorman@suse.de
Subject: Re: [PATCH] Describe race of direct read and fork for unaligned buffers
References: <1335778207-6511-1-git-send-email-jack@suse.cz>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 30 Apr 2012 09:41:50 -0400
In-Reply-To: <1335778207-6511-1-git-send-email-jack@suse.cz> (Jan Kara's
	message of "Mon, 30 Apr 2012 11:30:07 +0200")
Message-ID: <x49haw1jq01.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kara <jack@suse.cz> writes:

> This is a long standing problem (or a surprising feature) in our implementation
> of get_user_pages() (used by direct IO). Since several attempts to fix it
> failed (e.g.
> http://linux.derkeiler.com/Mailing-Lists/Kernel/2009-04/msg06542.html, or
> http://lkml.indiana.edu/hypermail/linux/kernel/0903.1/01498.html refused in
> http://comments.gmane.org/gmane.linux.kernel.mm/31569) and it's not completely
> clear whether we really want to fix it given the costs, let's at least document
> it.
>
> CC: mgorman@suse.de
> CC: Jeff Moyer <jmoyer@redhat.com>
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>
> --- a/man2/open.2	2012-04-27 00:07:51.736883092 +0200
> +++ b/man2/open.2	2012-04-27 00:29:59.489892980 +0200
> @@ -769,7 +769,12 @@
>  and the file offset must all be multiples of the logical block size
>  of the file system.
>  Under Linux 2.6, alignment to 512-byte boundaries
> -suffices.
> +suffices. However, if the user buffer is not page aligned and direct read
> +runs in parallel with a
> +.BR fork (2)
> +of the reader process, it may happen that the read data is split between
> +pages owned by the original process and its child. Thus effectively read
> +data is corrupted.
>  .LP
>  The
>  .B O_DIRECT

I think this sufficiently distills the problem.  Thanks, Jan.

Acked-by: Jeff Moyer <jmoyer@redhat.com>
