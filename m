Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401Ab1ATKvU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 05:51:20 -0500
Received: from matrixpower.ru ([195.178.208.66]:45653 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755210Ab1ATKvQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 05:51:16 -0500
Date: Thu, 20 Jan 2011 13:51:13 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Tejun Heo <tj@kernel.org>,
        Ruslan Pisarev <ruslan@rpisarev.org.ua>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pohmelfs/dir.c: Remove unneeded mutex_unlock() from
 pohmelfs_rename()
Message-ID: <20110120105113.GA24827@ioremap.net>
References: <40908.91.79.118.36.1295471624.squirrel@mail.ispras.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <40908.91.79.118.36.1295471624.squirrel@mail.ispras.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 20, 2011 at 12:13:44AM +0300, Alexey Khoroshilov (khoroshilov@ispras.ru) wrote:
> I do not see any reason for the mutex_unlock(&inode->i_mutex); in
> pohmelfs_rename().
> 
> 
> Found by Linux Driver Verification project (linuxtesting.org).

Yes, that's a bug, we already unlocked i_mutex in common path and should
not do that on error.

Thank you. Greg, please apply.

> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>

Acked-by: Evgeniy Polyakov <zbr@ioremap.net>

-- 
	Evgeniy Polyakov
