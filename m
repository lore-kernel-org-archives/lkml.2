Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755672Ab2DJJuS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 05:50:18 -0400
Received: from gw.stuttgart.de.funkwerk-ec.com ([85.93.64.96]:60013 "EHLO
	gw.stuttgart.de.funkwerk-ec.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753053Ab2DJJuN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 05:50:13 -0400
X-Greylist: delayed 482 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Apr 2012 05:50:13 EDT
Message-ID: <4F840064.70201@teldat.de>
Date: Tue, 10 Apr 2012 11:41:56 +0200
From: Nils Rennebarth <nils.rennebarth@teldat.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: How to do buffered File IO event-based programs?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (gw.stuttgart.de.funkwerk-ec.com [0.0.0.0]); Tue, 10 Apr 2012 11:42:06 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am writing a daemon that mostly reads and writes over network connections,
and uses a single threaded event-loop based design using epoll.

Now the daemon occasionally needs to read and write to disk, because it
gets data that is too big to keep in memory. The corresponding request
gets slowed down of course, that is ok. What I would like to avoid
however, is slowing down other client connections to the same
daemon.

As I understand it, just adding the disk-io filedescriptor to the epoll
does not work because it always is ready for reading and writing.

I could use aio, but that is cumbersome as it sets serious alingment
restrictions on the buffers that get written/get read into. Also that
way, the data will circumvent the buffer cache which is not what
I want, to the contrary: data written to a file is very likely to be
read again soon, so if there happens to be enogh free RAM available,
I would like to use it.

I could use a second worker process connected to the other via
a pipe or a unix domain socket. That does work but adds another
userspace-kernel copy plus context switch to each read and write.
This is probably irrelevant in the presence of actual disk io,
and will be the route to go in the absence of other ideas.

Do I ask something unreasonable, is my design flawed anyway, or
is there a concept/unofficial kernel patch flowing around that I
missed?

-- 

Mit freundlichen Grüßen / with kind regards

Nils Rennebarth, Software Developer

--
Funkwerk IP-Appliances GmbH
Mönchhaldenstraße 28
D-70191 Stuttgart

Tel: +49 711 900300 - 0
Fax: +49 711 900300 - 90

E-Mail: Nils.Rennebarth@funkwerk-ec.com

Location: GmbH Nuernberg, Local Court Nuernberg, HRB 25481
Managing Directors: Torsten Urban
--------------------------------
The information contained in this e-mail has been carefully researched,
but the possibility of it being inapplicable in individual cases cannot
be ruled out. We therefore regret that we cannot accept responsibility
or liability of any kind whatsoever for the correctness of the
information given. Please notify us if you discover that information is
inapplicable.

