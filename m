Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757053Ab1KJLvv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 06:51:51 -0500
Received: from a.relay.invitel.net ([62.77.203.3]:50573 "EHLO
	a.relay.invitel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799Ab1KJLvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 06:51:50 -0500
Date: Thu, 10 Nov 2011 12:51:44 +0100
From: =?iso-8859-1?B?R+Fib3IgTOlu4XJ0?= <lgb@lgb.hu>
To: linux-kernel@vger.kernel.org
Subject: capabilities question(s)
Message-ID: <20111110115144.GD10997@vega.lgb.hu>
Reply-To: lgb@lgb.hu
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Operating-System: vega Linux 2.6.38-12-generic i686
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

I have the problem that I can't find too much informations about
capabilities implemented by the Linux kernel, and its usage. 
I even don't have header file sys/capability.h suggested by man
page of capget (on ubuntu, if it does count). However it's not the major
problem, as I've found example to use syscall() from sys/syscall.h and
stuffs in linux/capability.h. Well, ignore it, I've just found out
that I need libcap-dev to install. However the problem remains:

What I want to do: I need user to be able to do chroot() once, then I want
to drop that capability (to be safe?).  My program (a server) runs as root,
but after initialization it changes uid/gid (in a forked process).  However
I want to keep chroot capability even after the uid/gid change so I can do a
chroot() even as non-root.  It it possible at all? I need this so I feel
more secure not to run things as root, since I need to do many things before
I can call chroot(). So I guessed, it's more secure to use non-root user
to do these, before I can do chroot().

As far as I can see, I can set capability as root, but after uid/gid change,
I lost that capability, and - of course - I cannot set it as a user then.

Or should I use root user anyway, just drop all of the capabilities I don't
need just keep uid/gid change and chroot? Anyway, then I have the problem
that I am still root for the filesystem permission checks, and it's
something I don't want to do, because the things my server do before chroot
is not so secure ...

Any ideas are welcome.

Best regards,

Gábor
