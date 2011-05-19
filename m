Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755536Ab1ESLGp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 07:06:45 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:49171 "EHLO duck.linux-mips.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754254Ab1ESLGn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 07:06:43 -0400
Date: Thu, 19 May 2011 12:06:38 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Kevin Cernekee <cernekee@gmail.com>
Cc: dediao@cisco.com, ddaney@caviumnetworks.com, dvomlehn@cisco.com,
        sshtylyov@mvista.com, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] MIPS: HIGHMEM DMA on noncoherent MIPS32 processors
Message-ID: <20110519110638.GA11371@linux-mips.org>
References: <002fbbeb01a5a51fff8015af85d5d101@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <002fbbeb01a5a51fff8015af85d5d101@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 13, 2010 at 04:57:35PM -0700, Kevin Cernekee wrote:

> [v4: Patch applies to linux-queue.git with kmap_atomic patches:
>  https://patchwork.kernel.org/patch/189932/
>  https://patchwork.kernel.org/patch/194552/
>  https://patchwork.kernel.org/patch/189912/ ]
> 
> The MIPS DMA coherency functions do not work properly (i.e. kernel oops)
> when HIGHMEM pages are passed in as arguments.  Use kmap_atomic() to
> temporarily map high pages for cache maintenance operations.
> 
> Tested on a 2.6.36-rc7 1GB HIGHMEM SMP no-alias system.

And I don't think it's going to work on an alias system.  __dma_sync maps
a page but it doesn't know the previous mapping (or could there be any
other mappings at the same time?).  That's going to fail with aliases.
Not that this was previously working so I don't blame you for it.

Who is the author of this patch, you or Dezhong Diao?

  Ralf
