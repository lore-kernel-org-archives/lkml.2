Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865Ab2DRO5T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 10:57:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36194 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753802Ab2DRO5R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 10:57:17 -0400
Message-ID: <4F8ED646.1040100@redhat.com>
Date: Wed, 18 Apr 2012 09:57:10 -0500
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Andreas Dilger <adilger@whamcloud.com>
CC: Zheng Liu <gnehzuil.liu@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        Zheng Liu <wenqing.lz@taobao.com>
Subject: Re: [RFC][PATCH 0/3] add FALLOC_FL_NO_HIDE_STALE flag in fallocate
References: <1334681618-9452-1-git-send-email-wenqing.lz@taobao.com> <4F8DAAFE.40500@redhat.com> <D225F088-A53F-4962-97AD-13C850BBA722@whamcloud.com>
In-Reply-To: <D225F088-A53F-4962-97AD-13C850BBA722@whamcloud.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/17/12 11:59 PM, Andreas Dilger wrote:

...

> Secondly, your test program is not doing random writes to disk, but
> rather doing writes at 64kB intervals. There is logic in the
> uninitialized extent handling that will write zeros to an entire
> extent, rather than create many fragmented uninitialized extents.  It
> may be possible that you are zeroing out the entire file, and writing
> 16x as much data as you expect.
> 
> Cheers, Andreas

I don't think the testcase as written is triggering that behavior, though
other similar testcases might.  In this case the left-over uninit extents
are large enough that they don't get zeroed:

File size of /mnt/scratch/test is 268435456 (65536 blocks, blocksize 4096)
 ext logical physical expected length flags
   0       0    34816               1 
   1       1    34817              15 unwritten
   2      16    34832               1 
   3      17    34833              15 unwritten
   4      32    34848               1 
   5      33    34849              15 unwritten
...

Good guess though :)

-Eric
