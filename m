Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754991Ab2BWJJn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 04:09:43 -0500
Received: from seven.medozas.de ([188.40.89.202]:59542 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752265Ab2BWJJg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 04:09:36 -0500
Date: Thu, 23 Feb 2012 10:09:33 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] treewide: fix memory corruptions when TASK_COMM_LEN
 != 16
In-Reply-To: <20120222125810.50cd5789.akpm@linux-foundation.org>
Message-ID: <alpine.LNX.2.01.1202222303190.15465@frira.zrqbmnf.qr>
References: <1327183785-27023-1-git-send-email-jengelh@medozas.de> <20120124135443.2772d455.akpm@linux-foundation.org> <alpine.LNX.2.01.1201250121260.20692@frira.zrqbmnf.qr> <20120131172334.7f26f164.akpm@linux-foundation.org> <alpine.LNX.2.01.1202010224510.29848@frira.zrqbmnf.qr>
 <20120131174914.8ce5291d.akpm@linux-foundation.org> <alpine.LNX.2.01.1202010257240.29848@frira.zrqbmnf.qr> <20120131190109.b53347fd.akpm@linux-foundation.org> <alpine.LNX.2.01.1202221343530.10125@frira.zrqbmnf.qr>
 <20120222125810.50cd5789.akpm@linux-foundation.org>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 2012-02-22 21:58, Andrew Morton wrote:

>On Wed, 22 Feb 2012 13:48:08 +0100 (CET)
>Jan Engelhardt <jengelh@medozas.de> wrote:
>
>> task: provide a larger task command buffer
>
><scratches head>
>
>Why are we bothering ourselves about this?

Some prefer to know what's going on in the system. Every other or 
so kernel release there are some new happy kthreads, such as

24930 ?        S      0:00  \_ [btrfs-endio-1]
24931 ?        S      0:00  \_ [btrfs-endio-met]
24932 ?        S      0:00  \_ [btrfs-endio-met]
24933 ?        S      0:00  \_ [btrfs-endio-wri]
24934 ?        S      0:00  \_ [btrfs-freespace]

at which point one is curious to find out the rest of the met and why 
there are two of them. If expanded one actually sees they are different 
kthreads (rather than just per-cpu instances for a WQ, for example)

$ grep Name /proc/{29431,29432}/stat*
/proc/29431/status:Name: btrfs-endio-meta-1
/proc/29432/status:Name: btrfs-endio-meta-write-1

That's all.
