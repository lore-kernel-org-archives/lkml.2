Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892Ab2AWUsE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 15:48:04 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:51524 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353Ab2AWUsC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 15:48:02 -0500
Date: Mon, 23 Jan 2012 12:47:57 -0800
From: Tejun Heo <tj@kernel.org>
To: Lennart Poettering <mzxreary@0pointer.de>
Cc: Vivek Goyal <vgoyal@redhat.com>, axboe@kernel.dk, ctalbott@google.com,
        rni@google.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/17] blkcg: shoot down blkio_groups on elevator switch
Message-ID: <20120123204757.GM12652@google.com>
References: <20120123153913.GB12652@google.com>
 <20120123155216.GF25986@redhat.com>
 <20120123155745.GD12652@google.com>
 <20120123161042.GG25986@redhat.com>
 <20120123161619.GE12652@google.com>
 <20120123162553.GI25986@redhat.com>
 <20120123171049.GH12652@google.com>
 <20120123182745.GK25986@redhat.com>
 <20120123184336.GI12652@google.com>
 <20120123204352.GB21822@tango.0pointer.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120123204352.GB21822@tango.0pointer.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Lennart.

On Mon, Jan 23, 2012 at 09:43:52PM +0100, Lennart Poettering wrote:
> I didn't really follow the whole discussion here, but if this is about
> adjusting parameters of a block device as the block device shows up this
> must necessarily happen in an udev rule (and not in a daemon watching
> block devices using libudev), since you most likely need the
> synchronicity: i.e. you want to avoid that normal (libudev-using)
> userspace code ever sees the device before those params are written to
> the device. A daemon asynchronously watching the devices with libudev
> for adjusting such tunables is necessarily racy.

Yeap, this needs to be synchronous so that it's configured before the
rest of system notices the device.  Vivek, can you please ask the
tuned guys to take a look?

Thanks.

-- 
tejun
