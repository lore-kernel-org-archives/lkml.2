Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047Ab1FUMp6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 08:45:58 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:49527 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834Ab1FUMp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 08:45:57 -0400
Date: Tue, 21 Jun 2011 13:45:56 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Greg Dietsche <greg@gregd.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org
Subject: Re: 3.0 rc3 bug & warning fs/inode.c && fs/fs-writeback.c
Message-ID: <20110621124556.GZ11521@ZenIV.linux.org.uk>
References: <4E008DD0.2090809@gregd.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E008DD0.2090809@gregd.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 21, 2011 at 07:25:52AM -0500, Greg Dietsche wrote:
> from the just missed rc4 department:
> I recieved this BUG last night on my laptop and it was shortly
> followed by a warning from the kernel. I doubt that I can reproduce
> this. It happened under a light load. I was doing some emailing
> using thunderbird (er.... icedove.....). let me know if there's
> anything I can do to help debug or if there's more info I can get
> that would help you figure out what went wrong.

Which filesystems had been mounted?  That looks like a stray pointer
to struct inode (i.e. outliving the inode eviction on final iput());
might be the one fixed by commit 50338b889dc504c69e0cb316ac92d1b9e51f3c8a,
might be something else...
