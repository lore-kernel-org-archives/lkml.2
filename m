Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692Ab2BMJkO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 04:40:14 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:59466 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244Ab2BMJkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 04:40:13 -0500
Message-ID: <4F38DA79.2040803@suse.cz>
Date: Mon, 13 Feb 2012 10:40:09 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120129 Thunderbird/10.0.1
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Jiri Slaby <jirislaby@gmail.com>, Richard Weinberger <richard@nod.at>,
        linux-kernel@vger.kernel.org,
        user-mode-linux-devel@lists.sourceforge.net, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, gregkh@linuxfoundation.org
Subject: Re: your mail
References: <1329006070-4275-1-git-send-email-richard@nod.at> <20120212010211.GN23916@ZenIV.linux.org.uk> <4F37B34F.1040307@suse.cz> <20120212190611.GP23916@ZenIV.linux.org.uk>
In-Reply-To: <20120212190611.GP23916@ZenIV.linux.org.uk>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2012 08:06 PM, Al Viro wrote:
> Yecchhh...  If I'm reading (and grepping) it right, there are only two
> non-default instance of tty_operations ->shutdown() - pty and vt ones.
> Lovely...  And while we are at it, vt instance is definitely not safe
> from interrupts - calls console_lock().  Not that it was relevant in
> this case...

Thanks for looking into that. I was too lazy to do that on Sunday.

You're right that it may cause problems. Fortunately vt doesn't refcount
ttys. Hence con_shutdown can be called only from release_tty (close
path) in the user context.

Adding to my TODO list, unless somebody beats me to fix it.

thanks,
-- 
js
suse labs
