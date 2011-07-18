Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752430Ab1GRNww (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 09:52:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45051 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751251Ab1GRNwv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 09:52:51 -0400
Date: Mon, 18 Jul 2011 14:52:44 +0100
From: Mel Gorman <mgorman@suse.de>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Andi Kleen <andi@firstfloor.org>, linux-mm@kvack.org
Subject: Re: [Patch] mm: make CONFIG_NUMA depend on CONFIG_SYSFS
Message-ID: <20110718135243.GA5349@suse.de>
References: <1310987909-3129-1-git-send-email-amwang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1310987909-3129-1-git-send-email-amwang@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 18, 2011 at 07:18:29PM +0800, Amerigo Wang wrote:
> On ppc, we got this build error with randconfig:
> 
> drivers/built-in.o:(.toc1+0xf90): undefined reference to `vmstat_text': 1 errors in 1 logs
> 
> This is due to that it enabled CONFIG_NUMA but not CONFIG_SYSFS.
> 
> And the user-space tool numactl depends on sysfs files too.
> So, I think it is very reasonable to make CONFIG_NUMA depend on CONFIG_SYSFS.
> 

That looks a bit awful. There is no obvious connection between SYSFS
and NUMA. One is exporting information to userspace and the other is
the memory model. Without sysfs, NUMA support might be less useful
but the memory policies should still work and set_mempolicy() should
still be an option.

You didn't post where the buggy reference to vmstat_text but I'm
assuming it is in drivers/base/node.c . It would be preferable that
it be fixed to not reference vmstat_text unless either CONFIG_PROC_FS
or CONFIG_SYSFS is defined similar to what is in mm/vmstat.c .

-- 
Mel Gorman
SUSE Labs
