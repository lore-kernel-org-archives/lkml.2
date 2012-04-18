Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753221Ab2DRLjR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 07:39:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55568 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752064Ab2DRLjQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 07:39:16 -0400
Date: Wed, 18 Apr 2012 13:39:06 +0200 (CEST)
From: Lukas Czerner <lczerner@redhat.com>
X-X-Sender: lukas@dhcp-27-109.brq.redhat.com
To: Zheng Liu <gnehzuil.liu@gmail.com>
cc: Andreas Dilger <adilger@whamcloud.com>, Eric Sandeen <sandeen@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        Zheng Liu <wenqing.lz@taobao.com>
Subject: Re: [RFC][PATCH 0/3] add FALLOC_FL_NO_HIDE_STALE flag in fallocate
In-Reply-To: <20120418113810.GA3447@gmail.com>
Message-ID: <alpine.LFD.2.00.1204181336440.5310@dhcp-27-109.brq.redhat.com>
References: <1334681618-9452-1-git-send-email-wenqing.lz@taobao.com> <4F8DAAFE.40500@redhat.com> <D225F088-A53F-4962-97AD-13C850BBA722@whamcloud.com> <20120418113810.GA3447@gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Apr 2012, Zheng Liu wrote:

> > I auspect the real problem may be the lazy inode table zeroing being done in the kernel. If the test is run immediately after formatting the filesystem, then the kernel thread is busy writing to the disk in the background and interfering with your benchmark.
> > 
> > Please format the filesystem with "-E lazy-itable-init=0", to avoid this behavior.  
> 
> I format the filesystem with this option, but it seems that it is
> useless.

What do you mean by that ? It does not work as it's supposed to ?
ext4lazyinit kernel thread is still running ? Or the slowdown was not
caused by the lazy init in the first place ?

Thanks!
-Lukas
