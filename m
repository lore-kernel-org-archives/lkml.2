Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757608Ab2EKPKH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 11:10:07 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:51554 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754367Ab2EKPKD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 11:10:03 -0400
MIME-Version: 1.0
In-Reply-To: <20120511145243.GE5958@kroah.com>
References: <20120503212151.568.91854.stgit@bob.linux.org.uk>
 <20120503212219.568.15653.stgit@bob.linux.org.uk> <CA+1xoqezLCQh_fqJ1iNAs25X7Fm24W=-0J8zTZuVVJQnWTtSLg@mail.gmail.com>
 <20120507171126.5beddc27@pyramind.ukuu.org.uk> <1336408208.3638.15.camel@lappy>
 <20120507174240.4209c5cb@pyramind.ukuu.org.uk> <CA+1xoqez0PaX2KBHHN-etztwbFoU1cKx3NwMXX+PO4SguA3bRg@mail.gmail.com>
 <4FA838D2.9000908@suse.cz> <CA+1xoqdi1Jdkrjtj9bmnDfs4Ok=o=AsmpP=MY0V8cDXjcSNm1w@mail.gmail.com>
 <CA+1xoqcZnxGoo=_X1idCPTk9gR=drnAKhULGzgkH33zYGnAgOA@mail.gmail.com> <20120511145243.GE5958@kroah.com>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Fri, 11 May 2012 17:09:42 +0200
Message-ID: <CA+1xoqdgckzNAtHFwgjVHj169ZYn5rna1HNwudrQKegr4DAqVw@mail.gmail.com>
Subject: Re: [PATCH 3/3] tty_lock: Localise the lock
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Jiri Slaby <jirislaby@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2012 at 4:52 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> The printk rework should now be working again in linux-next.  Is it
> still causing problems for you?

Mostly does, there's still a minor issue regarding showing timestamps
on each line in the log, I've commented about it in the original
thread (
http://permalink.gmane.org/gmane.linux.kernel/1295580).

It's fairly visible in the lockdep spew, since lockdep does lots of
this "printk("\nsomething\n");"
