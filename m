Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751942Ab2KRMbL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 07:31:11 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:60218 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841Ab2KRMbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 07:31:09 -0500
MIME-Version: 1.0
Reply-To: kerolasa@gmail.com
Date: Sun, 18 Nov 2012 12:31:08 +0000
X-Google-Sender-Auth: uQiRRe4yQbZdZKDTeSxtzITm9Tk
Message-ID: <CAG27Bk1q5t590bvGg7Ka+2M-yWEMk_58sZsOxDKx-1XNn8mHww@mail.gmail.com>
Subject: ipc: object information data in proc and sysfs
From: Sami Kerola <kerolasa@iki.fi>
To: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Doug Ledford <dledford@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org
Cc: Karel Zak <kzak@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

While back I started to look how to get util-linux ipcs(1) tool to
read values from /proc instead of using IPC multiplex functions.  Most
of the data ipcs(1) is interested is available in /proc, but there are
few exceptions, such as

msgctl q_qbytes
semctl getval
semctl sempid
semctl semncnt
semctl semzcnt

The simplest thing to do would be to add values in /proc/sysvipc/msg
and /proc/sysvipc/sem as additional fields, but that does not seem
right, as it would result to ABI change.

More effort requiring change would be to add information in new sysfs
paths.  The IPC facilities are using id's which could be used as
placeholder directories for the data needed.  Something like

/proc/sys/kernel/ipc/{m,s,q}/id/info
                 ^^^^^^^^^^^^^^^^^^^

That sort of structure would allow future extensions IPC data without
much pain.  I also assume that subdirectories could allow a little
more precise controls, and perhaps some selected values might be made
writable in future.  If nothing else at least expressing in sensible
format semaphore lock wait queues could make debugging tools, such as
lslocks(8), more useful.

I could give a try this change, but not without hearing the concept
makes sense and could be considered part of upstream kernel (assuming
my coding meets the usual quality criteria).

Any thoughts, comments, recommendations?

--
   Sami Kerola
   http://www.iki.fi/kerolasa/
