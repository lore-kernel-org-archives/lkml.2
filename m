Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102Ab2HOJ0L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 05:26:11 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:40095 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753305Ab2HOJ0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 05:26:07 -0400
MIME-Version: 1.0
Date: Wed, 15 Aug 2012 11:26:06 +0200
Message-ID: <CAAv8mH2_MYPGOZ2Qed51jfBhd0vmovWeW6sJDyYKjgAyX9-KKw@mail.gmail.com>
Subject: Mmap on SSD (directly mapping the device vs. mapping a file)
From: Daniel Noack <fsf.deathman@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, folks!

Like you can see on the subject I experimented a little with mmap in
the last time. I've written a little B+tree library which uses mmap to
store the tree to a file or the whole device (means it is also
possible to map the raw device (i.e. /dev/sdb)). I used msync after
every successfull change on the tree. Next thing I did was to use this
for a little benchmark on performance of different storage devices
(ramdisk, HDD, and a very fast flashcard directly atteched to the PCIe
bus). I recognized that in allmost all cases when directly mapping the
device without a filesystem the file-mapped version was a little bit
slower. But when I tried it on an SSD device the file-mapped version
was an order of magnitude faster. I also tried secure erase and did
the benchmarks many times and in many configurations, but I came to
the same results.
Last thing I tried were the different queue schedulers, without any changes.

In one of the posts from january I read that there is a performance
bug when directly reading from the raw SSD device, but I didn't find
any else comment which stated this as true. For the benchmarks I used
a current Ubuntu with a 3.2.16 kernel (from kernel.org). Is this
behavior normal, or did I miss something.
