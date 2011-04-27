Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642Ab1D0GzS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 02:55:18 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:37405 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658Ab1D0GzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 02:55:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ILld7Yynribtn64lL/786KMJl0B9nZw8QM8i8YYQze7BejfXn8t9v7hMv35u7SwF4B
         cHWa5dmg6eY/lVnk0uShBN0gXSb9nx3K8Zk+SjfqNruidigPfsyauxVeeLMeTFT8QYL+
         ckwgi1PfNC8IBtEuDjg6RGmiLs1XtJ38s81J0=
Subject: Re: [PATCH] Applying inappropriate ioctl operation on socket
 should return ENOTTY
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Lifeng Sun <lifongsun@gmail.com>
Cc: linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>
In-Reply-To: <20110427063730.GA20313@md5.ntu.edu.sg>
References: <1303882625-28115-1-git-send-email-lifongsun@gmail.com>
	 <1303883910.2699.53.camel@edumazet-laptop>
	 <20110427063730.GA20313@md5.ntu.edu.sg>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 27 Apr 2011 08:55:09 +0200
Message-ID: <1303887309.2699.58.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 27 avril 2011 à 14:37 +0800, Lifeng Sun a écrit :
> On 07:58 Wed 04/27/11 Apr, Eric Dumazet wrote:
> > Really ?
> > 
> > EINVAL is ok too : Request or argp is not valid.
> 
> I'm afraid not. SUSv4 specifies, say,
> 
>   int tcsetattr(int fildes, int optional_actions,
>          const struct termios *termios_p);
> 
>  ERROR:
>   [EINVAL]
>       The optional_actions argument is not a supported value, or an
>       attempt was made to change an attribute represented in the
>       termios structure to an unsupported value.
> 
>   [ENOTTY]
>       The file associated with fildes is not a terminal.
> 
> which means when we apply tcsetattr (implemented by ioctl) to _any_
> non-terminal file descriptor, it should set errno to ENOTTY rather
> than EINVAL.

Thats not so simple. This is a known and documented artifact.

In old days, ioctl() had a meaning for TTYS (mostly).



man isatty

ERRORS
       EBADF  fd is not a valid file descriptor.

       EINVAL fd refers to a file other than a terminal.  POSIX.1-2001 specifies the error ENOTTY for this case.


This is not because POSIX changes rules that we must change kernel and break applications.

Conformant applications use isatty(fd) and test result code being 1 or not 1

This way, they work with linux 1.0, 2.0, 2.2, 2.4, .... and other OSes as well.



