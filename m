Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753073Ab0KYLuk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 06:50:40 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:54452 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753037Ab0KYLui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 06:50:38 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAPvb7Ux5LcZJ/2dsb2JhbACjCnK+KIVHBA
Date: Thu, 25 Nov 2010 22:50:33 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Nick Piggin <npiggin@kernel.dk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
        Roman Zippel <zippel@linux-m68k.org>,
        "Tigran A. Aivazian" <tigran@aivazian.fsnet.co.uk>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
        Bob Copeland <me@bobcopeland.com>, reiserfs-devel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Evgeniy Dushistov <dushistov@mail.ru>, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] exofs: simple fsync race fix
Message-ID: <20101125115033.GA3643@amd>
References: <20101125074909.GA4160@amd>
 <4CEE2C2E.4010003@panasas.com>
 <20101125100603.GA3164@amd>
 <4CEE3F9F.9070108@panasas.com>
 <4CEE3FD8.6080202@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CEE3FD8.6080202@panasas.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is fine, we'll get it merged before 2.6.37, just give a couple of
days for review, I haven't had much confirmation from other vfs people
about these problems.

Thanks,
Nick

On Thu, Nov 25, 2010 at 12:52:08PM +0200, Boaz Harrosh wrote:
> From: Nick Piggin <npiggin@kernel.dk>
> 
> It is incorrect to test inode dirty bits without participating in the inode
> writeback protocol. Inode writeback sets I_SYNC and clears I_DIRTY_?, then
> writes out the particular bits, then clears I_SYNC when it is done. BTW. it
> may not completely write all pages out, so I_DIRTY_PAGES would get set
> again.
> 
