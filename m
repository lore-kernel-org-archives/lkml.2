Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355Ab2FKPSF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 11:18:05 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:59656 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006Ab2FKPSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 11:18:02 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, torvalds@linux-foundation.org, dhowells@redhat.com
Subject: Re: [PATCH 00/21] vfs: atomic open v6 (part 2)
References: <1338901832-14049-1-git-send-email-miklos@szeredi.hu>
	<20120610034921.GB30000@ZenIV.linux.org.uk>
Date: Mon, 11 Jun 2012 17:18:46 +0200
In-Reply-To: <20120610034921.GB30000@ZenIV.linux.org.uk> (Al Viro's message of
	"Sun, 10 Jun 2012 04:49:21 +0100")
Message-ID: <877gvdho6h.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro <viro@ZenIV.linux.org.uk> writes:

>
> I'm more or less OK with that; one major exception is your struct opendata.
> I think it needs to go.  Really.  You are using it to store three references -
> file, vfsmount and dentry.

That's not the real purpose.  We can store those in struct file, I can
see that.

The real reason I went with a separate and opaque type there is that
that thing is simply not an open file.  If it was a struct file and the
filesystem would do an fput() on it by accident it would lead to really
ugly problems, and the complier would have no chance at detecting it.

If it's a separate type (and it can have just that struct file embedded
into it) then such mistakes are instantly detected by the compiler

So I really don't see the downsides of having a new type for that.

Thanks,
Miklos
