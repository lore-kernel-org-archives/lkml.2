Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758092Ab2GFRpr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 13:45:47 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64744 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757795Ab2GFRpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 13:45:45 -0400
MIME-Version: 1.0
Date: Fri, 6 Jul 2012 20:45:44 +0300
Message-ID: <CAGoecWyMKF4gC7FaoBCrBs+rD=u6oJRHS5Q2qVkkwoZZ1_4RCg@mail.gmail.com>
Subject: Bug 44211 - /proc/kmsg does not (always) block for 1-byte reads
From: Jukka Ollila <jiiksteri@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: kay@vrfy.org, jbeulich@novell.com, alan@lxorguk.ukuu.org.uk,
        greg@kroah.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

A few days ago I filed a kernel regression report concerning a change
in /proc/kmsg behaviour with short reads:

https://bugzilla.kernel.org/show_bug.cgi?id=44211

The comments suggest that this is probably intentional, but that it
would be best make sure that the current semantics wrt short reads are
as intended.

The problem appears on a Debian (unstable) system that drains
/proc/kmsg into a separate fifo read by klogd(8):

/bin/dd bs=1 if=/proc/kmsg  of=/var/run/klogd/kmsg

With the recent kernel logging changes this /bin/dd exits immediately,
as 1-byte reads are shorter than any log message could possibly be and
read() returns 0. No dd feeding the fifo results in no logging and a
rather unhappy klogd on the reading end of /var/run/klogd/kmsg.

I suppose a safe solution is to only do reads that are big enough for
any single kernel message, but this is still a change that affects
user space being shipped, so some might find it surprising.

I don't know what other distros do. Is it just Debian being the odd one out?

-J
