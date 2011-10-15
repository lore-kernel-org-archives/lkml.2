Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752026Ab1JOIzN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Oct 2011 04:55:13 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53416 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575Ab1JOIzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Oct 2011 04:55:11 -0400
Message-ID: <4E994A65.7000509@suse.cz>
Date: Sat, 15 Oct 2011 10:55:01 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Godmar Back <godmar@gmail.com>
CC: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Greg KH <gregkh@suse.de>
Subject: Re: Q.: Why does tty_ioctl.c: set_termios return EINTR instead of
 ERESTARTSYS?
References: <CAB4+JYLiF4wr+U5s_m15baC=Ktf8NnAYFKfcyhM3AxG9PZ4YPA@mail.gmail.com> <CAB4+JYJYVFouMYZMX4bGVA+vPm1rD3KY3GvwVjKBZS7bwf6-zQ@mail.gmail.com> <CAB4+JYLjjdo_nmwPqWTmd9YFk=4x4AVcprr-b7LoEc9JDqGthQ@mail.gmail.com>
In-Reply-To: <CAB4+JYLjjdo_nmwPqWTmd9YFk=4x4AVcprr-b7LoEc9JDqGthQ@mail.gmail.com>
X-Enigmail-Version: 1.4a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2011 06:52 PM, Godmar Back wrote:
> A student in my OS class noticed during their shell assignment that
> tcsetattr() is being interrupted with EINTR even though they had set
> SA_RESTART.
> 
> Upon taking a closer look, I noticed that
> drivers/char/tty_ioctl.c:set_termios(), which lies on the code path
> for the POSIX tcsetattr() function, returns -EINTR when a signal is
> pending. Consequently, the SA_RESTART flag is not honored and user
> code must check for and handle EINTR.
> 
> I don't immediately see what would prevent this system call from being
> restartable.
> 
> Is there a particular reason why it cannot be made restartable?

EINTR is used when there is no way to rollback already performed
actions. In this case, a flush could be performed. (This holds only for
TCSETSF, TCSETSF2 and similar.) So I think this is the reason we cannot
return ERESTARTSYS.

However I CCed tty fellows, they may have a different opinion.

regards,
-- 
js
suse labs
