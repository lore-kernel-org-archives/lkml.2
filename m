Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521Ab2DNLyB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 07:54:01 -0400
Received: from casper.infradead.org ([85.118.1.10]:59567 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754952Ab2DNLx7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 07:53:59 -0400
Message-ID: <1334404423.2528.75.camel@twins>
Subject: Re: [Lsf] [RFC] writeback and cgroup
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>, ctalbott@google.com, rni@google.com,
        andrea@betterlinux.com, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, lsf@lists.linux-foundation.org,
        linux-mm@kvack.org, jmoyer@redhat.com, lizefan@huawei.com,
        linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org
Date: Sat, 14 Apr 2012 13:53:43 +0200
In-Reply-To: <20120404184909.GB29686@dhcp-172-17-108-109.mtv.corp.google.com>
References: <20120403183655.GA23106@dhcp-172-17-108-109.mtv.corp.google.com>
	 <20120404145134.GC12676@redhat.com>
	 <20120404184909.GB29686@dhcp-172-17-108-109.mtv.corp.google.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-04-04 at 11:49 -0700, Tejun Heo wrote:
> > - How to handle NFS.
> 
> As said above, maybe through network based bdi pressure propagation,
> Maybe some other special case mechanism.  Unsure but I don't think
> this concern should dictate the whole design. 

NFS has a custom bdi implementation and implements congestion control
based on the number of outstanding writeback pages.

See fs/nfs/write.c:nfs_{set,end}_page_writeback

All !block based filesystems have their own BDI implementation, I'm not
sure on the congestion implementation of anything other than NFS though.
