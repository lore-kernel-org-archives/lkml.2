Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752380Ab2DRIpW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 04:45:22 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:44699 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501Ab2DRIpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 04:45:18 -0400
MIME-Version: 1.0
Date: Wed, 18 Apr 2012 10:45:17 +0200
Message-ID: <CAKW9VBj-tyfgCTAip7jvwRP4v_LZe9jUtZRLewft81Rbb6y0yw@mail.gmail.com>
Subject: Inotify and UNIX domain sockets
From: alexandre p <ataaroap@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello list,

I have a simple daemon program that creates an AF_UNIX socket which it
uses for local communication, absolutely nothing fancy. A somewhat
minor annoyance with UNIX sockets is that the socket file may be
removed at the filesystem level, and the listening process isn't aware
of it. To that end I decided to use inotify to watch the socket and
kill the daemon if it gets removed.

This doesn't appear to work. Specifically, no inotify event is
generated for a *connected* UNIX domain socket on my system. If the
socket is unconnected, then a delete event is properly generated, and
a regular file with the same name of course works fine. But for a
connected socket, nothing (perhaps because the file is not in fact
unlinked in this instance, a reference to the inode being maintained
by the socket subsystem itself? This is a wild guess.)

The question is, is this by design?

Here at work I'm using a somewhat ancient version of the kernel, so my
apologies in advance if this was a known bug at some point that has
since been fixed. Unfortunately I cannot test it on a more recent
version easily.

Linux devx 2.6.18-128.el5 #1 SMP Wed Dec 17 11:41:38 EST 2008 x86_64
x86_64 x86_64 GNU/Linux

Best regards,

Alexander
