Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028Ab0EOCh5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 22:37:57 -0400
Received: from netrider.rowland.org ([192.131.102.5]:38318 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753026Ab0EOCh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 22:37:56 -0400
Date: Fri, 14 May 2010 22:37:55 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Nigel Cunningham <ncunningham@crca.org.au>
cc: Matt Reimer <mattjreimer@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [linux-pm] Is it supposed to be ok to call del_gendisk while
 userspace is frozen?
In-Reply-To: <4BEC8173.4070500@crca.org.au>
Message-ID: <Pine.LNX.4.44L0.1005142235580.11498-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 May 2010, Nigel Cunningham wrote:

> Hi.

> > Subject: [PATCH] fs: prevent hang on suspend/resume when MMC/SD card present
> >
> > Devices can come and go bus during suspend or resume, when the
> > writeback thread is frozen, resulting in a hang. Prevent the hang
> > by thawing the writeback thread in del_gendisk().

> Why not just make it unfreezeable to start with?

If the writeback thread were unfreezable, it might wake up and try to 
write dirty pages back to disks after they were already suspended.  
That would not lead to good consequences...

Alan Stern

