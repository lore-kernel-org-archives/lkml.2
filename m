Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758255Ab2I1OjD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 10:39:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7153 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758038Ab2I1OjA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 10:39:00 -0400
Date: Fri, 28 Sep 2012 10:38:44 -0400
From: Dave Jones <davej@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] loop: Make explicit loop device destruction lazy
Message-ID: <20120928143844.GA1454@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Jens Axboe <axboe@kernel.dk>, Dave Chinner <david@fromorbit.com>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <1348812593-21344-1-git-send-email-david@fromorbit.com>
 <506562CE.2070500@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <506562CE.2070500@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 10:41:50AM +0200, Jens Axboe wrote:

 > > Turns out that blkid is running simultaneously with losetup -d, and
 > > so it sees an elevated reference count and returns EBUSY.  But why
 > > is blkid running? It's obvious, isn't it? udev has decided to try
 > > and find out what is on the block device as a result of a creation
 > > notification. And it is racing with mkfs, so might still be scanning
 > > the device when mkfs finishes and we try to tear it down.
 > > 
 > I hear that %^#@#! blkid behavior, it is such a pain in the neck. I
 > don't know how many times I've had to explain that behaviour to people
 > who run write testing with tracing, wonder wtf there are reads in the
 > trace.
 
Could this problem explain this bug too ? https://bugzilla.redhat.com/show_bug.cgi?id=853674

	Dave

