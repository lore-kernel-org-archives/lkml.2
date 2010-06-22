Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752542Ab0FVP7t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 11:59:49 -0400
Received: from lirone.symas.net ([64.71.152.235]:59104 "EHLO lirone.symas.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751701Ab0FVP7s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 11:59:48 -0400
Message-ID: <4C20DDEA.1090209@symas.com>
Date: Tue, 22 Jun 2010 08:59:38 -0700
From: Howard Chu <hyc@symas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; rv:1.9.3a5pre) Gecko/20100607 Firefox 3.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: alan@lxorguk.ukuu.org.uk, greg@kroah.com
Subject: Re: [PATCH] tty: Add EXTPROC support for LINEMODE
References: <E1OPhUs-0000W7-M9@lirone.symas.net>
In-Reply-To: <E1OPhUs-0000W7-M9@lirone.symas.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping... any other issues with this patch?

hyc@symas.com wrote:
> This patch is against the 2.6.34 source.
>
> Paraphrased from the 1989 BSD patch by David Borman @ cray.com:
>
>       These are the changes needed for the kernel to support
>       LINEMODE in the server.
>
>       There is a new bit in the termios local flag word, EXTPROC.
>       When this bit is set, several aspects of the terminal driver
>       are disabled.  Input line editing, character echo, and mapping
>       of signals are all disabled.  This allows the telnetd to turn
>       off these functions when in linemode, but still keep track of
>       what state the user wants the terminal to be in.
>
>       New ioctl:
>           TIOCSIG         Generate a signal to processes in the
>                           current process group of the pty.
>
>       There is a new mode for packet driver, the TIOCPKT_IOCTL bit.
>       When packet mode is turned on in the pty, and the EXTPROC bit
>       is set, then whenever the state of the pty is changed, the
>       next read on the master side of the pty will have the TIOCPKT_IOCTL
>       bit set.  This allows the process on the server side of the pty
>       to know when the state of the terminal has changed; it can then
>       issue the appropriate ioctl to retrieve the new state.
>
> Since the original BSD patches accompanied the source code for telnet I've
> left that reference here, but obviously the feature is useful for any remote
> terminal protocol, including ssh.
>
> The corresponding feature has existed in the BSD tty driver since 1989. For
> historical reference, a good copy of the relevant files can be found here:
>
> http://anonsvn.mit.edu/viewvc/krb5/trunk/src/appl/telnet/?pathrev=17741
>
> Signed-off-by: Howard Chu<hyc@symas.com>


-- 
   -- Howard Chu
   CTO, Symas Corp.           http://www.symas.com
   Director, Highland Sun     http://highlandsun.com/hyc/
   Chief Architect, OpenLDAP  http://www.openldap.org/project/
