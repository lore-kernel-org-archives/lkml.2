Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752965Ab2HNK7t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 06:59:49 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:37009 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321Ab2HNK7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 06:59:48 -0400
MIME-Version: 1.0
Date: Tue, 14 Aug 2012 12:59:48 +0200
Message-ID: <CAAv8mH3kukd-ii04hQbMZGj7iTwQhpFDwFtnz0h3JBMe6gaGxA@mail.gmail.com>
Subject: Mmap on SSD (directly mapping the device vs. mapping a file)
From: Daniel Noack <fsf.deathman@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, folks!

First of all I have to say sorry that I'm not a subscriber of the list now,
but I will subscribe in the near future (need an extra email account for it
;) ). It would be nice if you could put me on CC for an answer to my
question.

Like you can see on the subject I experimented a little bit with mmap in the
last time. I've written a little B+tree library which uses mmap to store
the tree to a file or the whole device (means it is also possible to map
the hwole device (i.e. /dev/sdb)). I used msync after every successfull
change on the tree. Next thing I did was to use this for a little benchmark
on performance of different storage devices (ramdisk, HDD, and a very fast
flashcard directly atteched to the PCIe bus). I recognized that in allmost
all cases when directly mapping teh device without a filesystem the
file-mapped version was a little bit slower. But when I tried it on an SSD
device the file-mapped version was an order of magnitude faster. I also
tried secure erase and did the benchmarks many times and in many
configurations, but I came to the same results. Can anyone explain me
what's happening here or have I something missed. Is this behavior correct?

Thanks,
Daniel
