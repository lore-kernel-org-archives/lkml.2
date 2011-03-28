Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754334Ab1C1Qjb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 12:39:31 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52833 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739Ab1C1Qja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 12:39:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=MhBfYZH4J691reWnhVHxvPxxBsBqTh/fxzWneR9siOJbGcLvtQeaQQAiW62Gu0S7xl
         LVBf4msa8UQbpvNh9uHafVk8Dv1ZkCzzrgySrOCjHZrxmyu8/jPeF0icmbiKx0dkrDRA
         h+jqA0TDG78u9CLqC49EJf3/0ePpPucleTqSU=
MIME-Version: 1.0
Date: Mon, 28 Mar 2011 20:39:29 +0400
Message-ID: <AANLkTinFqqmE+fTMTLVU-_CwPE+LQv7CpXSQ5+CdAKLK@mail.gmail.com>
Subject: Very aggressive memory reclaim
From: John Lepikhin <johnlepikhin@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I use high-loaded machine with 10M+ inodes inside XFS, 50+ GB of
memory, intensive HDD traffic and 20..50 forks per second. Vanilla
kernel 2.6.37.4. The problem is that kernel frees memory very
aggressively.

For example:

25% of memory is used by processes
50% for page caches
7% for slabs, etc.
18% free.

That's bad but works. After few hours:

25% of memory is used by processes
62% for page caches
7% for slabs, etc.
5% free.

Most of files are cached, works perfectly. This is the moment when
kernel decides to free some memory. After memory reclaim:

25% of memory is used by processes
25% for page caches(!)
7% for slabs, etc.
43% free(!)

Page cache is dropped, server becomes too slow. This is the beginning
of new cycle.

I didn't found any huge mallocs at that moment. Looks like because of
large number of small mallocs (forks) kernel have pessimistic forecast
about future memory usage and frees too much memory. Is there any
options of tuning this? Any other variants?

Thanks!
