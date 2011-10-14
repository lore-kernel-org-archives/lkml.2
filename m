Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419Ab1JNQwV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 12:52:21 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:44917 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754629Ab1JNQwV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 12:52:21 -0400
MIME-Version: 1.0
In-Reply-To: <CAB4+JYJYVFouMYZMX4bGVA+vPm1rD3KY3GvwVjKBZS7bwf6-zQ@mail.gmail.com>
References: <CAB4+JYLiF4wr+U5s_m15baC=Ktf8NnAYFKfcyhM3AxG9PZ4YPA@mail.gmail.com>
	<CAB4+JYJYVFouMYZMX4bGVA+vPm1rD3KY3GvwVjKBZS7bwf6-zQ@mail.gmail.com>
Date: Fri, 14 Oct 2011 12:52:19 -0400
Message-ID: <CAB4+JYLjjdo_nmwPqWTmd9YFk=4x4AVcprr-b7LoEc9JDqGthQ@mail.gmail.com>
Subject: Q.: Why does tty_ioctl.c: set_termios return EINTR instead of ERESTARTSYS?
From: Godmar Back <godmar@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A student in my OS class noticed during their shell assignment that
tcsetattr() is being interrupted with EINTR even though they had set
SA_RESTART.

Upon taking a closer look, I noticed that
drivers/char/tty_ioctl.c:set_termios(), which lies on the code path
for the POSIX tcsetattr() function, returns -EINTR when a signal is
pending. Consequently, the SA_RESTART flag is not honored and user
code must check for and handle EINTR.

I don't immediately see what would prevent this system call from being
restartable.

Is there a particular reason why it cannot be made restartable?

Thank your for any insight.

 - Godmar

--
please cc: me on any replies.
