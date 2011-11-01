Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001Ab1KALa4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 07:30:56 -0400
Received: from mga03.intel.com ([143.182.124.21]:64354 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753850Ab1KALay (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 07:30:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,437,1315206000"; 
   d="scan'208";a="32103841"
Date: Tue, 1 Nov 2011 11:41:38 +0000
From: Alan Cox <alan@linux.intel.com>
To: Ilya Zykov <ilya@ilyx.ru>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] TTY: tty flip buffer change reserve memory strategy.
Message-ID: <20111101114138.1debca90@bob.linux.org.uk>
In-Reply-To: <4EA69BE2.3020703@ilyx.ru>
References: <4EA48474.4010101@ilyx.ru>
	<20111025084543.09432276@pyx>
	<4EA69BE2.3020703@ilyx.ru>
Organization: Intel
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Organisation: Intel Corporation UK Ltd, registered no. 1134945 (England),
 Registered office Pipers Way, Swindon, SN3 1RJ
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Pty use chunk more 256 bytes very often. More program for communicate
> with pppd use pty master - slave. If often kmalloc()-kfree() calls
> don't provoke memory fragmentation and flush TLB, I agree it isn't
> important.

I think any work of this nature ought to involve benchmarking. That
would answer the questions better. kmalloc/kfree is a smart allocator
so shouldn't cause problems, and it doesn't manipulate address space so
shouldn't cause TLB misses.

You want to make these changes, you say they are needed, but what
actually talks is real numbers.

Alan
