Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565Ab1BXOz6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 09:55:58 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:65148 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141Ab1BXOzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 09:55:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=CiQui8kqgB0ozru7BSwRG8oWCiPIHxq+Vo9QJa8iE/2q/3y/EU2FvCeTSxZ2bQjUWz
         1z+XI1ERv8QCUOeIXVFvMsFgqWOT8q7hjFRV0bRLUZkqHVpsstb+G6gnC5iU+f+xY+7A
         mWQOCgGt1/59w3BuyzRUjDJA5ghIT7J5MDRW0=
Date: Thu, 24 Feb 2011 15:54:38 +0100
From: Tejun Heo <tj@kernel.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
        kovariadam@gmail.com, florian@mickler.org, rjw@sisk.pl,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: fix refcounting in BLKBSZSET
Message-ID: <20110224145438.GO7840@htj.dyndns.org>
References: <E1PscUb-0004a3-Qi@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1PscUb-0004a3-Qi@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 24, 2011 at 03:48:33PM +0100, Miklos Szeredi wrote:
> [and lkml cc-d too]
> 
> This fixes bug 29202 in the 2.6.38 regression list.
> 
> Please apply.
> 
> Thanks,
> Miklos
> 
> ----
> Subject: block: fix refcounting in BLKBSZSET
> 
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> Adam Kovari and others reported that disconnecting an USB drive with
> an ntfs-3g filesystem would cause "kernel BUG at fs/inode.c:1421!" to
> be triggered.
> 
> The BUG could be traced back to ioctl(BLKBSZSET), which would
> erroneously decrement the refcount on the bdev.  This is because
> blkdev_get() expects the refcount to be already incremented and either
> returns success or decrements the refcount and returns an error.
> 
> The bug was introduced by e525fd89 (block: make blkdev_get/put()
> handle exclusive access), which didn't take into account this behavior
> of blkdev_get().
> 
> Reported-by: Adam Kovari <kovariadam@gmail.com>
> CC: Tejun Heo <tj@kernel.org>
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>

Ah, it was me after all.  Sorry about that.

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
