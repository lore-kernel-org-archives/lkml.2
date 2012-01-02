Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320Ab2ABR3t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 12:29:49 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53696 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752944Ab2ABR3d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 12:29:33 -0500
Date: Mon, 2 Jan 2012 09:29:03 -0800
From: Greg KH <gregkh@suse.de>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] tty: rework pty count limiting
Message-ID: <20120102172903.GB19782@suse.de>
References: <20120102172254.11535.2653.stgit@zurg>
 <20120102172301.11535.10338.stgit@zurg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120102172301.11535.10338.stgit@zurg>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 02, 2012 at 09:23:01PM +0400, Konstantin Khlebnikov wrote:
> After adding devpts multiple-insrances sysctl kernel.pty.max limit pty count for
> each devpts instance independently, while kernel.pty.nr shows total pty count.
> 
> This patch restores sysctl kernel.pty.max as global limit (4096 by default),
> adds pty reseve for main devpts (mounted without "newinstance" argument),
> and new sysctl to tune it: kernel.pty.reserve (1024 by default)
> 
> Also it adds devpts mount option "max=%d" to limit pty count for each devpts
> instance independently. (by default NR_UNIX98_PTY_MAX == 2^20)
> 
> Thus devpts instances in containers cannot eat up all available pty even if we didn't
> set any limits, while with "max" argument we can adjust limits more precisely.
> 
> Plus, now open("/dev/ptmx") return -ENOSPC in case lack of pty indexes,
> this is more informative than -EIO.

That's a userspace api change, why is this going to be allowed?

greg k-h
