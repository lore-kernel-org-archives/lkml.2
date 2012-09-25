Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753820Ab2IYSPV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 14:15:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48850 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751602Ab2IYSPU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 14:15:20 -0400
Subject: Re: ktest.pl always returns 0?
From: Steven Rostedt <srostedt@redhat.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20120925180028.GA22896@kroah.com>
References: <20120925180028.GA22896@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat
Date: Tue, 25 Sep 2012 14:15:17 -0400
Message-ID: <1348596917.6786.12.camel@fedora>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-09-25 at 11:00 -0700, Greg KH wrote:
> Hi Steven,

Note, emailing my RH account is hit or miss. If I'm traveling I don't
read it, and I wont return messages until I'm back. It's best to email
my rostedt@goodmis.org account, as I have better access to that account.
I author my patches by the email of the people that pay me to write
them. This isn't for your "who wrote the kernel" scripts. This is for
anyone that happens to do a git log.

> 
> I'm trying to use ktest to do build tests of the stable patch series to
> verify I didn't mess anything up, but I'm finding that ktest always
> returns 0 when finished, no matter if the build test was successful or
> failed.

Hmm, I should fix that. Yeah, I agree, if it fails a test it should
return something other than zero. But I think that only happens if you
have DIE_ON_FAILURE = 0. As IIRC, the perl "die" command should exit the
application with an error code.

But yeah, I agree, if one of the tests fail, the error code should not
be zero. I'll write up a patch to fix that. Or at least add an option to
make that happen.


> 
> Is this right?  Is there some other way to determine if ktest fails
> other than greping the output log?

If you have DIE_ON_FAILURE = 1 (default) it should exit with non zero.

> 
> Oh, and any hints on kicking off a ktest process on a remote machine in
> a "simple" way?  I'm just using ssh to copy over a script that runs
> there, wrapping ktest.pl up with other stuff, I didn't miss the fact
> that ktest itself can run remotely already, did I?

I'm a little confused by this question. Do you want a server ktest? That
is, have a ktest daemon that listens for clients that sends it config
files and then runs them? That would actually be a fun project ;-)

You're not running ktest on the target machine are you? The way I use it
is the following:

I have a server that I ssh to and run ktest from. It does all the builds
there on the server and this server has a means to monitor some target.
I use ttywatch that connects to the serial of the target, in which ktest
uses to read from.

Sometimes this "server" is the machine I'm logged in to.  And I just run
ktest directly.

Can you explain more of what you are looking for?

Thanks!

-- Steve


