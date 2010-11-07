Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250Ab0KGPGG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 10:06:06 -0500
Received: from cantor.suse.de ([195.135.220.2]:45494 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752938Ab0KGPGD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 10:06:03 -0500
Date: Sun, 7 Nov 2010 16:06:01 +0100
From: Jan Kara <jack@suse.cz>
To: Alessio Igor Bogani <abogani@texware.it>
Cc: Jan Kara <jack@suse.cz>, Arnd Bergmann <arnd@arndb.de>,
        Christoph Hellwig <hch@infradead.org>, Tim Bird <tim.bird@am.sony.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] udf: Add missed protection for s_lvid_dirty
Message-ID: <20101107150601.GG5126@quack.suse.cz>
References: <1289065631-2256-1-git-send-email-abogani@texware.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289065631-2256-1-git-send-email-abogani@texware.it>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 06-11-10 18:47:08, Alessio Igor Bogani wrote:
> As reported in udf_sb.h the udf_sb_infoi's structure member s_lvid_dirty should
> be protected by s_alloc_mutex. Added that mutex on a couple of places where it
> miss.
> 
> This work was supported by a hardware donation from the CE Linux Forum.
  Thanks for doing the work! I actually did some work on BKL removal in UDF
before I learned that you also started working on it. My series is not
complete and needs testing but the sb-locking is better explained there I
think so it should address Christoph's comments. So could you maybe base your
changes on patches I already have?
  I've pushed the branch with my BKL patches to:
git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-udf-2.6
  to branch
bkl_removal
  Basically it is missing removal of BKL usage for protection of extents
in a buffer. I wanted to use inode->i_alloc_sem for that if it won't be too
ugly, otherwise some fs-private rw semaphore. I specifically didn't want to
use mutex because that would unnecessarily serialize parallel readers.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
