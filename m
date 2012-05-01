Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751714Ab2EAGDZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 02:03:25 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:65308 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917Ab2EAGDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 02:03:24 -0400
MIME-Version: 1.0
Date: Mon, 30 Apr 2012 23:03:23 -0700
X-Google-Sender-Auth: pY4vTZWC9lWcjzzWwnOHX-LDibE
Message-ID: <CANkdjvZinRvHYPKLCFsd6z3FXgM4ScS1Ar9OjO3s1SLDFnridw@mail.gmail.com>
Subject: read() syscall slowing down due to other threads?
From: George Porter <gmporter@cs.ucsd.edu>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I've run into a weird phenomenon I was hoping someone could help me pin down.

I've got a multithreaded program which reads data off of 8 input
disks, and does some processing on it.  I have 8 Reader threads, each
of which reads data off of one of the eight input disks.  That data
gets passed to other threads, which do some processing (this is an 8
core machine).  If I do no or minimal processing in those other
threads, the read() calls go at the speed of the disks (~100 MBps).  I
measure that speed by taking a timestamp before the read syscall, then
afterwards, and dividing that into the read size (5MB).  All seems
good.

However, if I start doing more computation on those other threads, the
read() syscalls take longer to read the same amount of data,
eventually slowing down to 50 MBps (50% slower).  I've used
setaffinity() to isolate the Reader threads to one set of cores, and
the compute threads to a different set of cores, and so I don't think
it is CPU/scheduling interference.

Thoughts?  Has anyone run into this before?

Also, if you could CC me directly on any responses I would appreciate it.
Thanks, George
