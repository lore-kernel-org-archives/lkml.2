Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756642Ab2I2Fvq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2012 01:51:46 -0400
Received: from casper.infradead.org ([85.118.1.10]:45796 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753696Ab2I2Fvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2012 01:51:44 -0400
Message-ID: <50668C4F.8010300@kernel.dk>
Date: Sat, 29 Sep 2012 07:51:11 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Dave Chinner <david@fromorbit.com>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] loop: Make explicit loop device destruction lazy
References: <1348812593-21344-1-git-send-email-david@fromorbit.com> <506562CE.2070500@kernel.dk> <20120928143844.GA1454@redhat.com>
In-Reply-To: <20120928143844.GA1454@redhat.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-09-28 16:38, Dave Jones wrote:
> On Fri, Sep 28, 2012 at 10:41:50AM +0200, Jens Axboe wrote:
> 
>  > > Turns out that blkid is running simultaneously with losetup -d, and
>  > > so it sees an elevated reference count and returns EBUSY.  But why
>  > > is blkid running? It's obvious, isn't it? udev has decided to try
>  > > and find out what is on the block device as a result of a creation
>  > > notification. And it is racing with mkfs, so might still be scanning
>  > > the device when mkfs finishes and we try to tear it down.
>  > > 
>  > I hear that %^#@#! blkid behavior, it is such a pain in the neck. I
>  > don't know how many times I've had to explain that behaviour to people
>  > who run write testing with tracing, wonder wtf there are reads in the
>  > trace.
>  
> Could this problem explain this bug too ? https://bugzilla.redhat.com/show_bug.cgi?id=853674

It certainly looks like it!

-- 
Jens Axboe

