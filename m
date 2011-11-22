Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754982Ab1KVM5x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 07:57:53 -0500
Received: from casper.infradead.org ([85.118.1.10]:33928 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137Ab1KVM5w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 07:57:52 -0500
Message-ID: <1321966662.5148.35.camel@twins>
Subject: Re: [PATCH 3/5] writeback: fix dirtied pages accounting on sub-page
 writes
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jan Kara <jack@suse.cz>
Cc: Wu Fengguang <fengguang.wu@intel.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Tue, 22 Nov 2011 13:57:42 +0100
In-Reply-To: <20111122122157.GB8058@quack.suse.cz>
References: <20111121130342.211953629@intel.com>
	 <20111121131215.905222115@intel.com> <20111122001127.GG4017@quack.suse.cz>
	 <20111122092110.GB12864@localhost> <20111122122157.GB8058@quack.suse.cz>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-22 at 13:21 +0100, Jan Kara wrote:
> > +             __get_cpu_var(bdp_ratelimits)++;
>   I think you need preempt_disable() and preempt_enable() pair around
> __get_cpu_var(). Otherwise a process could get rescheduled in the middle of
> read-modify-write cycle... 

there's of course the this_cpu_inc(bdp_ratelimits); thing.

On x86 that'll turn into a single insn, on others it will add the
required preempt_disable/enable bits.
