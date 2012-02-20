Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753115Ab2BTLPh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 06:15:37 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:59106 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686Ab2BTLPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 06:15:36 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of jirislaby@gmail.com designates 10.14.188.134 as permitted sender) smtp.mail=jirislaby@gmail.com; dkim=pass header.i=jirislaby@gmail.com
Message-ID: <4F422B53.5060001@suse.cz>
Date: Mon, 20 Feb 2012 12:15:31 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120215 Thunderbird/10.0.2
MIME-Version: 1.0
To: Sasha Levin <levinsasha928@gmail.com>
CC: Jiri Slaby <jirislaby@gmail.com>, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] TTY: fix PTY hangup vs close race
References: <1329683796.10124.21.camel@lappy> <1329686346-16752-1-git-send-email-jslaby@suse.cz> <4F416C9D.3030302@gmail.com> <CA+1xoqfEUkVjRdE3BYnUVhvuPGCLhgbraZAEE9A9tfCKAXg9sQ@mail.gmail.com>
In-Reply-To: <CA+1xoqfEUkVjRdE3BYnUVhvuPGCLhgbraZAEE9A9tfCKAXg9sQ@mail.gmail.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2012 11:20 AM, Sasha Levin wrote:
>> [*] Your dump reveals that the code fetches tty->driver_data (mov
>> 0x428(%rdi),%rbx) and traps at a fetch of inode->i_sbm because inode is
>> NULL (mov    0x28(%rbx),%rax).
> 
> It actually looks even more complex than that. I reverted the patch
> above, but still got the error. A quick bisection pointed me to
> a50f724a432997321cabb6c9e665c28e34850f78.

> Looks like reverting both actually solves the problem. Reverting just
> one of them doesn't.

Ah, I see. I suppose you have CONFIG_LEGACY_PTYS=y. I somehow overlooked
that case.

So both of them should be reverted in upstream:
d3bda5298aad98c7a27678bdd0dd9d008ab9e685
a50f724a432997321cabb6c9e665c28e34850f78

thanks,
-- 
js
suse labs
