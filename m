Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755892Ab2KZUMi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 15:12:38 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:57488 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755547Ab2KZUMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 15:12:37 -0500
MIME-Version: 1.0
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 26 Nov 2012 12:12:16 -0800
Message-ID: <CALCETrW=0gQMBW=nLKCWS-O7H5q6zYFCbFGOcC2PTS668=Z_NA@mail.gmail.com>
Subject: mmap_sem contention issues
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm having serious latency problems due to mmap_sem contention.  I
have a real-time thread that has (soft) page faults on locked pages,
and it blocks for multiple milliseconds on
(call_rwsem_down_read_failed do_page_fault page_fault).  Can this be
fixed?

Some ideas:

1. Drop mmap_sem during the filesystem part of mmap and munmap.
(MAP_POPULATE in particular is a disaster -- using it will easily
increase latency from a few milliseconds to a respectable fraction of
a second.)

2. Come up with some way to lock specific vm_area_structs for read
access without taking mmap_sem at all.  This looks unpleasant with the
current rbtree structure -- something like a radix tree might work
much better if the nodes were to contain their own locks.

--Andy

-- 
Andy Lutomirski
AMA Capital Management, LLC
