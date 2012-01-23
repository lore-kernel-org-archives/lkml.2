Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804Ab2AWSwA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 13:52:00 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47760 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753641Ab2AWSv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 13:51:58 -0500
Date: Mon, 23 Jan 2012 10:51:53 -0800
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/17] blkcg: shoot down blkio_groups on elevator switch
Message-ID: <20120123185153.GJ12652@google.com>
References: <1327202725-3383-9-git-send-email-tj@kernel.org>
 <20120123152055.GD25986@redhat.com>
 <20120123153913.GB12652@google.com>
 <20120123155216.GF25986@redhat.com>
 <20120123155745.GD12652@google.com>
 <20120123161042.GG25986@redhat.com>
 <20120123161619.GE12652@google.com>
 <20120123162553.GI25986@redhat.com>
 <20120123171049.GH12652@google.com>
 <20120123183207.GL25986@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120123183207.GL25986@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 23, 2012 at 01:32:07PM -0500, Vivek Goyal wrote:
> This is not just specific to blk-throttle. If in future throttling policy
> is removable like elevator, then it will be fine to reset the throttling
> related configuration upon removal of throttling policy. But resetting
> throttling configuration without policy going anywhere does not sound good.

Yeah, that is a compromise.  As long as those configurations are
per-queue, which is the way it's gonna be after the clean up, I don't
think it's a big deal tho.  We'll be saying "if you make changes to
the set of blkcg policies applied to a device, all blkcg
configurations regarding the device will be reset" instead of "if any
change to blkcg policies happen system-wide, all blkcg configurations
will be reset", and the former doesn't sound crazy to me.  Anyways,
let's see how complex doing the finer grained thing gets.

-- 
tejun
