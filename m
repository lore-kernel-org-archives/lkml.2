Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934849Ab2JXNoc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 09:44:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27701 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932462Ab2JXNob (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 09:44:31 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: MITSUNARI Shigeo <herumi@nifty.com>
Cc: linux-fsdevel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: fs: page cache wrongly left invalidated after revalidate_disk
References: <28086318.27561350944959337.herumi@nifty.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 24 Oct 2012 09:44:23 -0400
In-Reply-To: <28086318.27561350944959337.herumi@nifty.com> (MITSUNARI Shigeo's
	message of "Tue, 23 Oct 2012 07:29:19 +0900 (JST)")
Message-ID: <x491ugo6l3c.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MITSUNARI Shigeo <herumi@nifty.com> writes:

> Hi, 
>
> We found that bdev->bd_invalidated was left set once revalidate_disk() 
> is called, which results in page cache flush every time that device 
> is open. 
>
> Specifically, we found this problem in MD block device.  Once we 
> resize a MD device, mdadm --monitor periodically flush all page cache 
> for that device every 60 or 1000 seconds when it opens the device. 
>
> This bug lies since at least 3.2.0 till the latest kernel(3.6.2). 
> Patch is attached. 
>
> Anyone please review this?  Thanks in advance.

rescan_partitions (called in the bdev open path) should reset
bd_invalidated.  I think you need to dig into why that isn't happening.

Cheers,
Jeff
