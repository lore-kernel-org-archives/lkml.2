Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758172Ab2BXV7n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 16:59:43 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:60156 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755462Ab2BXV7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 16:59:42 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.134.228 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
Date: Fri, 24 Feb 2012 13:57:32 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Sasha Levin <levinsasha928@gmail.com>, Jiri Slaby <jirislaby@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] TTY: fix PTY hangup vs close race
Message-ID: <20120224215732.GD25330@kroah.com>
References: <1329683796.10124.21.camel@lappy>
 <1329686346-16752-1-git-send-email-jslaby@suse.cz>
 <4F416C9D.3030302@gmail.com>
 <CA+1xoqfEUkVjRdE3BYnUVhvuPGCLhgbraZAEE9A9tfCKAXg9sQ@mail.gmail.com>
 <4F422B53.5060001@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F422B53.5060001@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 20, 2012 at 12:15:31PM +0100, Jiri Slaby wrote:
> On 02/20/2012 11:20 AM, Sasha Levin wrote:
> >> [*] Your dump reveals that the code fetches tty->driver_data (mov
> >> 0x428(%rdi),%rbx) and traps at a fetch of inode->i_sbm because inode is
> >> NULL (mov    0x28(%rbx),%rax).
> > 
> > It actually looks even more complex than that. I reverted the patch
> > above, but still got the error. A quick bisection pointed me to
> > a50f724a432997321cabb6c9e665c28e34850f78.
> 
> > Looks like reverting both actually solves the problem. Reverting just
> > one of them doesn't.
> 
> Ah, I see. I suppose you have CONFIG_LEGACY_PTYS=y. I somehow overlooked
> that case.
> 
> So both of them should be reverted in upstream:
> d3bda5298aad98c7a27678bdd0dd9d008ab9e685
> a50f724a432997321cabb6c9e665c28e34850f78

Both now reverted, thanks.

greg k-h
