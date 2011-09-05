Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751647Ab1IEQiM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 12:38:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39363 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751448Ab1IEQiG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 12:38:06 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <87liu37z3x.fsf@tucsk.pomaz.szeredi.hu>
References: <87liu37z3x.fsf@tucsk.pomaz.szeredi.hu>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: dhowells@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Leonardo Chiquitto <leonardo.lists@gmail.com>,
        Ian Kent <raven@themaw.net>, Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        autofs@linux.kernel.org
Subject: Re: [PATCH] vfs: automount should ignore LOOKUP_FOLLOW
Date: Mon, 05 Sep 2011 17:37:39 +0100
Message-ID: <17416.1315240659@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi <miklos@szeredi.hu> wrote:

> After 2.6.38, with the introduction of the ->d_automount()
> infrastructure, stat(2) and others would start triggering automount
> while lstat(2), etc. still would not.  This is a regression and a
> userspace ABI change.

It doesn't necessarily mean it's wrong.  The main class of program that needs
to be prevented from automounting are things that do bulk stat'ing (e.g. ls) -
and they should probably be doing lstat() anyway.

> +	/* We don't want to mount if someone's just doing a stat -
> +	 * unless they're stat'ing a directory and appended a '/' to
> +	 * the name.

Btw, line length is 80 chars.  This comment could easily use one fewer line.

If you use emacs you can do:

	ESC 7 9 C-x f

to set the right margin and then:

	M-q

whilst the cursor is in the comment paragraph to be rearranged and it will
'fill' the paragraph to 79 characters.

David
