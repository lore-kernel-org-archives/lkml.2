Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753054Ab2JPJ0H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 05:26:07 -0400
Received: from mail.unix-scripts.info ([46.21.114.223]:38581 "EHLO
	mail.unix-scripts.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735Ab2JPJ0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 05:26:05 -0400
Date: Tue, 16 Oct 2012 11:26:01 +0200
From: Laurent CARON <lcaron@unix-scripts.info>
To: Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org
Subject: Re: Strange crash on Dell R720xd
Message-ID: <20121016112301.lavahnga@trusted.unix-scripts.info>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
References: <20121015213522.kaiyahro@trusted.unix-scripts.info>
 <20121016090353.GB7428@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121016090353.GB7428@liondog.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2012 at 11:03:53AM +0200, Borislav Petkov wrote:
> That's:
> 
>                 BUG_ON(async_tx_test_ack(depend_tx) || txd_next(depend_tx) ||
> 			txd_parent(tx));
> 
> but probably the b0rkage happens up the stack. And this __raid_run_ops
> is probably starting the whole TX so maybe we should add
> linux-raid@vger.kernel.org to CC. Added.


Hi,

The machines seem stable after disabling I/O AT DMA at the BIOS level.

> What is that "r510" thing in the kernel version? You have your patches
> ontop? If yes, please try reproducing this with a kernel.org kernel
> without anything else ontop.

My kernel is vanilla from Kernel.org. The -r510 string is because I
tried it on a -r510 also.

> Also, it might be worth trying plain 3.6 to rule out a regression
> introduced in the stable 3.6 series.

I tried 3.5.x, 3.6, 3.6.1, 3.6.2 with exactly the same results.

For now, I did create more volumes, rsync lors of data over the network
to the disks with no crashs (after disabling I/O AT DMA).

...snip...

