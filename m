Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755560Ab1BNOzq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 09:55:46 -0500
Received: from cantor.suse.de ([195.135.220.2]:53332 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754108Ab1BNOzp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 09:55:45 -0500
Subject: Re: FUSE triggering BUG through blkdev_put()
From: Miklos Szeredi <mszeredi@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
        kovariadam@gmail.com
In-Reply-To: <20110214105659.GB18742@htj.dyndns.org>
References: <20110214105659.GB18742@htj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Feb 2011 15:55:40 +0100
Message-ID: <1297695340.19726.294.camel@tucsk.pomaz.szeredi.hu>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-02-14 at 11:56 +0100, Tejun Heo wrote:
> Please take a look at the following bug.
> 
>  https://bugzilla.kernel.org/show_bug.cgi?id=28642
> 
> The bug title and description are completely misleading but the
> problem seems to have been caused by the recent eviction related
> changes.  FUSE ends up blkdev_put'ting while I_CLEAR is still set on
> the blkdev's inode triggering BUG_ON() in iput().

Thanks for forwarding.

It doesn't look to me that it's related to changes in fuse inode
eviction.  More likely something from the recent inode locking changes.

Thanks,
Miklos

