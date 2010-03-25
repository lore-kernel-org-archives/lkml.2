Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665Ab0CYOPT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 10:15:19 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:53255 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753815Ab0CYOPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 10:15:17 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Dan Carpenter <error27@gmail.com>
Subject: Re: [GIT, RFC] Killing the Big Kernel Lock
Date: Thu, 25 Mar 2010 15:14:58 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       Matthew Wilcox <matthew@wil.cx>, Thomas Gleixner <tglx@linutronix.de>,
       jblunck@suse.de, Alan Cox <alan@linux.intel.com>,
       Ingo Molnar <mingo@elte.hu>
References: <201003242240.54907.arnd@arndb.de> <20100325134002.GA15851@bicker>
In-Reply-To: <20100325134002.GA15851@bicker>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003251514.59256.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX184YbMgbg26KjVO61FK2iJpt/gjuG+f3sDOG7W
 pLF5qb592x0pYzVLRF9G4monN3n07An7ewi0wgKJEilInbTVUb
 KihsvPCKTdR7jMNNoeDNQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 25 March 2010, Dan Carpenter wrote:
> There is a typo in this one:

> @@ -1641,7 +1643,7 @@ static ssize_t sysfs_blk_trace_attr_store(struct device *dev,
>  
>         ret = -ENXIO;
>  
> -       lock_kernel();
> +       mutex_unlock(&blkdev_mutex);
>         p = dev_to_part(dev);
>         bdev = bdget(part_devt(p));
>         if (bdev == NULL)
> 

Fixed now, thanks for reporting!

	Arnd
