Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753755Ab0EPTeM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 15:34:12 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34319 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752930Ab0EPTeL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 15:34:11 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Nigel Cunningham <ncunningham@crca.org.au>
Subject: Re: [linux-pm] Is it supposed to be ok to call del_gendisk while userspace is frozen?
Date: Sun, 16 May 2010 21:35:18 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc7-rjw; KDE/4.3.5; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Matt Reimer <mattjreimer@gmail.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       "linux-pm" <linux-pm@lists.linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <Pine.LNX.4.44L0.1005142235580.11498-100000@netrider.rowland.org> <4BEE0CC5.60804@crca.org.au>
In-Reply-To: <4BEE0CC5.60804@crca.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005162135.18767.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 15 May 2010, Nigel Cunningham wrote:
> Hi.
> 
> On 15/05/10 12:37, Alan Stern wrote:
> > On Fri, 14 May 2010, Nigel Cunningham wrote:
> >
> >> Hi.
> >
> >>> Subject: [PATCH] fs: prevent hang on suspend/resume when MMC/SD card present
> >>>
> >>> Devices can come and go bus during suspend or resume, when the
> >>> writeback thread is frozen, resulting in a hang. Prevent the hang
> >>> by thawing the writeback thread in del_gendisk().
> >
> >> Why not just make it unfreezeable to start with?
> >
> > If the writeback thread were unfreezable, it might wake up and try to
> > write dirty pages back to disks after they were already suspended.
> > That would not lead to good consequences...
> 
> If it syncs data as it should when we freeze processes, there won't be 
> any problem. Perhaps this is just an argument against making syncing 
> optional?

No, there is a problem.  The writeback threads were made freezable after some
people had reported hangs during suspend that had been tracked down to that
issue.  IIRC.

Rafael

