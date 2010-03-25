Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753720Ab0CYNk6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 09:40:58 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:55719 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283Ab0CYNkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 09:40:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=xuIjiGvE1tVcrDS53y9dTZcdRB2axbhaSE3nOk4pGBl2hBLUzcIYLDwaRVL4bqWdA1
         tNIjkQm1y/WL3VzEMbrKqzQPA96qCDiYug4Kbc++uVCEZU9yERzPvLn0GracD3xkCo7O
         f6Hv0JipmUgg36WDdxkzm9hNBKPj7L2QeLT8s=
Date: Thu, 25 Mar 2010 16:40:38 +0300
From: Dan Carpenter <error27@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       Matthew Wilcox <matthew@wil.cx>, Thomas Gleixner <tglx@linutronix.de>,
       jblunck@suse.de, Alan Cox <alan@linux.intel.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [GIT, RFC] Killing the Big Kernel Lock
Message-ID: <20100325134002.GA15851@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	linux-kernel@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>,
	Thomas Gleixner <tglx@linutronix.de>, jblunck@suse.de,
	Alan Cox <alan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>
References: <201003242240.54907.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201003242240.54907.arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a typo in this one:

commit 12c8fcce56c0de4fdcacf048fe723c8778af940d
Author: Arnd Bergmann <arnd@relay.de.ibm.com>
Date:   Wed Mar 24 20:08:55 2010 +0100

    block: replace BKL with global mutex
    
    It doesn't seem to interact with much else, so give
    this a try.

    Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index d9d6206..9c1277a 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c

	[ snip ]

@@ -1641,7 +1643,7 @@ static ssize_t sysfs_blk_trace_attr_store(struct device *dev,
 
        ret = -ENXIO;
 
-       lock_kernel();
+       mutex_unlock(&blkdev_mutex);
        p = dev_to_part(dev);
        bdev = bdget(part_devt(p));
        if (bdev == NULL)


