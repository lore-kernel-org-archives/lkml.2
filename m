Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756658Ab2DKKak (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 06:30:40 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:53615 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756546Ab2DKKaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 06:30:39 -0400
MIME-Version: 1.0
From: Tomer Margalit <tomermargalit@gmail.com>
Date: Wed, 11 Apr 2012 13:30:18 +0300
Message-ID: <CAG3n4CQYZEtYfCjQ_n=iWhwFoaW4x-ovXZh3bNiwbGVtgq+jVg@mail.gmail.com>
Subject: Synchronizing userspace and kernel using mmaped memory
To: linux-kernel@vger.kernel.org
Cc: scipioenterprises@yahoo.com, Nezer Zaidenberg <nzaidenberg@mac.com>,
        "Zaidenberg, Nezer" <Nezer.Zaidenberg@edfenergy.com>,
        Amir Averbuch <amir@math.tau.ac.il>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

I was wondering whether it is possible to use an mmaped byte to
synchronize userspace and kernel.
To elaborate, I have a line of buffers that need to be transfered from
a kernel driver into a userspace daemon, so they can be sent to the
internet.
My current communication scheme is to use a series of mmaped buffers,
copy the data to them, and then when done, set a bit (in that same
memory mapped region), that indicates the page was filled and is ready
for transmission.

I have implemented this scheme in two ways - one is to change the bit
both from kernel and userspace (set the bit when a page is filled and
clear it when emptied).
The other is to only change the bit from kernel, and only read the bit
from userspace (when the page is to be cleared, a custom ioctl is
used).

The problem is that this only works 99% of time. I.e. once in every
million pages, there is a page that the kernel says it has filled
(according to logs), but userspace sees as cleared.
My initial instinct was that this is a bug, and I have tried debugging
it for a long time - with no results.
Figuring it was some kind of "illegal" memory access, I put guard
bytes around the problematic byte - but after checking, they remain
untouched.

So, before I continue debugging, I thought to ask whether this is a
good approach?
Specifically, when writing/reading a memory mapped page from kernel
(or userspace for that matter) - is there any action that needs to be
taken to flush the data or protect it?

Thanks,
  Tomer
