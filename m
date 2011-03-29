Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508Ab1C2VH5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 17:07:57 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60098 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751285Ab1C2VH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 17:07:57 -0400
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 29 Mar 2011 14:07:35 -0700
Message-ID: <AANLkTikwbY5mm10ZWg7B6XeSBkZXFqKcYVZfJCi2QGx_@mail.gmail.com>
Subject: Merge window closed - 2.6.39-rc1 out
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So 2.6.39-rc1 is out there, and the merge window is closed. I still
have to look over the cleancache pull request (which I got in plenty
of time, but decided that I want to review after the merge window
craziness is over), but other than that, we're done.

What to say about the merge window? It _feels_ like it was all
drivers, filesystems and irq cleanups. The dirstat backs up the
drivers part (65%), but claims that we had way more arch updates than
filesystem stuff (and the bulk of that is ARM, and while _some_ of
that was the irq conversions, most of it is just the normal board
churn). On the arch side, the first steps of unifying m68k and
m68knommu is a nice sign, let's see how that all pans out in the long
run. Oh, and there's the new unicore32 architecture.

Elsewhere, we had a fair amount of VFS cleanup, and also introduced
the "filehandle" interfaces (along with open(..,O_PATH)). Although
most people won't care.

Perhaps a bit more interesting to a larger part of the kernel
community is the new block device plugging model - it makes plugging a
per-thread thing and cleaned up the code considerably. It also avoids
lots of locking in a very hot path, and should generally be a really
good idea. That said, it also at one point ate XFS filesystems for
breakfast, but that's fixed and it's hopefully all good now.

Anything else? I'm sure I've forgotten something really exciting. But
on the whole I think this should be one of those "solid, boring
progress" releases.

Knock wood. I like boring.

                    Linus
