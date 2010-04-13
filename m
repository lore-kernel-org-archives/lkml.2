Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346Ab0DMUYL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 16:24:11 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:47092 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750893Ab0DMUYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 16:24:10 -0400
Date: Tue, 13 Apr 2010 16:24:09 -0400
To: Prabhu Chawandi <prabhu.chavandi@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org
Subject: Re: Writing to NAND, Which is not visible to USER
Message-ID: <20100413202409.GA4309@caffeine.csclub.uwaterloo.ca>
References: <j2k241b8f7b1004090431r8a83ad66y7704e679ab79812b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <j2k241b8f7b1004090431r8a83ad66y7704e679ab79812b@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 09, 2010 at 05:01:58PM +0530, Prabhu Chawandi wrote:
>   I want to write someting to the NAND flash, which is not a part of
> partitioning.
> 
> say , out of 128 MB , I am using 64 MB which I have partitioned using
> MTD, but I have to access the other  64 MB.
> 
> Can any one help me or give me any ideas ?
> 
> Is it possible to write using assmbly code. I am using MIPS board.

I suspect you can't do that.

Most devices have registers needed to access them, in the case of a NAND
flash, commands like 'erase block', 'read', 'write', etc.  If you try to
do erase block from your program and then the kernel tries to do something
in its half of the flash, who owns the registers of the NAND flash?

You probably will have to just use the kernel's driver to provide another
partition and then access that directly (without a filesystem) from
your program.  At least that way one driver is in charge of accessing
the device.

-- 
Len Sorensen
