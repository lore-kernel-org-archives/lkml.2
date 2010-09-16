Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755323Ab0IPPkG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 11:40:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3010 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754867Ab0IPPkE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 11:40:04 -0400
Date: Thu, 16 Sep 2010 11:39:39 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, nauman@google.com, dpshah@google.com,
        guijianfeng@cn.fujitsu.com
Subject: Re: [RFC PATCH] Block device bio throttling support [V3]
Message-ID: <20100916153939.GC16147@redhat.com>
References: <1284584798-10264-1-git-send-email-vgoyal@redhat.com>
 <4C91BDA5.2090308@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C91BDA5.2090308@kernel.dk>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 16, 2010 at 08:48:05AM +0200, Jens Axboe wrote:
> On 2010-09-15 23:06, Vivek Goyal wrote:
> > Hi,
> > 
> > This is V3 of the bio throttling patches. Following are changes since V2.
> > 
> > - Added the support for throttling in terms of IOPS (READ/WRITE). If one
> >   specifies both bandwidth as well as IOPS rules on a device then IO is
> >   subjected to both the rules.
> > 
> > - Did few bug fixes.
> > 
> > - Did some cleanups in blk-cgroup code.
> 
> Vivek, I have merged these patches now to get some exposure and
> testing before .37 gets too close.

Thanks Jens.

Few things I had in mind.

- I have not implemented any barrier or ordering mechanism in throttling
  logic. I am assuming that all the barrier work to get rid of ordering
  semantics will also go in 2.6.37 and then we really should not need
  to implement any ordering in throttling logic. So it should be a non-issue.

- All throttling logic can simply be disabled by setting
  CONFIG_BLK_DEV_THROTTLING=n. It is already disabled by default. I will
  do some performance testing on faster storage to see what is the cost
  if CONFIG_BLK_DEV_THROTTLING=y and bandwidth is unlimited.

- I am still trying to figure out what to do about max number of bios which
  can be throttled and pending and how to gel it well with request queue
  congestion logic.

Thanks
Vivek
