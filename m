Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753412Ab2GBNdf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 09:33:35 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:40268 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155Ab2GBNdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 09:33:33 -0400
Date: Mon, 2 Jul 2012 14:33:29 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        ". James Morris" <jmorris@namei.org>,
        linux-security-module@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 0/4] Was: deferring __fput()
Message-ID: <20120702133329.GH22927@ZenIV.linux.org.uk>
References: <1341014197.2342.7.camel@falcor.watson.ibm.com>
 <20120630050238.GZ14083@ZenIV.linux.org.uk>
 <1341172202.2556.13.camel@falcor>
 <20120701205722.GD22927@ZenIV.linux.org.uk>
 <1341193591.2249.3.camel@falcor>
 <20120702034310.GE22927@ZenIV.linux.org.uk>
 <20120702051155.GF22927@ZenIV.linux.org.uk>
 <1341229790.2350.1.camel@falcor>
 <20120702120259.GG22927@ZenIV.linux.org.uk>
 <1341234091.2166.5.camel@falcor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341234091.2166.5.camel@falcor>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 02, 2012 at 09:01:31AM -0400, Mimi Zohar wrote:
> ok, it calls delayed_fput(), but never makes it into the delayed_fput()
> while statement.

That's because I'm a blind idiot and managed to miss the idiocy in
delayed_fput() -  that
	list_splice(&head, &delayed_fput_list);
should've been
	list_splice_init(&delayed_fput_list, &head);

Even more embarrassingly, I've actually screwed up the build scripts
and hadn't discovered until now that I'd been testing without initramfs;
as soon as I'd found that, the bug had promptly reproduced itself.

Anyway, I've pushed the fix into vfs.git#master.  Should propagate
to git.kernel.org in a few (commit 2ae9632 is the branch head)
