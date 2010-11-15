Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932526Ab0KOCji (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 21:39:38 -0500
Received: from bld-mail19.adl2.internode.on.net ([150.101.137.104]:57191 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932257Ab0KOCjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 21:39:37 -0500
Date: Mon, 15 Nov 2010 13:39:32 +1100
From: Dave Chinner <david@fromorbit.com>
To: Rogier Wolff <R.E.Wolff@BitWizard.nl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Sync semantics.
Message-ID: <20101115023932.GD22876@dastard>
References: <20101111125219.GA945@bitwizard.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101111125219.GA945@bitwizard.nl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 11, 2010 at 01:52:19PM +0100, Rogier Wolff wrote:
> 
> Hi, 
> 
> What should I expect from a "sync" system call?
> 
> The manual says: 
> 
>    sync() first commits inodes to buffers, and then buffers to disk.
> 
> and then goes on to state: 
> 
>    ... since  version  1.3.20 Linux does actually wait.
> 
> [for the buffers to be handed over to the drive]
> 
> So how long can I expect a "sync" call to take? 
> 
> I would expect that all buffers that are dirty at the time of the
> "sync" call are written by the time that sync returns. I'm currently
> bombarding my fileserver with some 40-60Mbytes per second of data to
> be written (*). The fileserver has 8G of memory. So max 8000 Mb of
> dirty buffers can be stored, right? The server writes an average of
> (at least) 40Mb/second to disk. According to my calculator, I will
> have to wait up to 200 seconds for the sync system call to return....
> 
> 
> # time sync
> 0.000u 0.220s 2:22:23.96 0.0%   0+0k 0+0io 2pf+0w

Depending on the kernel, sync will keep writing if you keep
dirtying. This should be mostly fixed in 2.6.36....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
