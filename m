Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903Ab1LTUpc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 15:45:32 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63069 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688Ab1LTUp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 15:45:27 -0500
Date: Tue, 20 Dec 2011 12:45:22 -0800
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Nate Custer <nate@cpanel.net>, Jens Axboe <axboe@kernel.dk>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        kvm@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFT PATCH] blkio: alloc per cpu data from worker thread
 context( Re: kvm deadlock)
Message-ID: <20111220204522.GI10752@google.com>
References: <4EE8C8EA.9070207@kernel.dk>
 <20111215194712.GA11194@redhat.com>
 <E73DB38E-AFC5-445D-9E76-DE599B36A814@cpanel.net>
 <20111216202907.GH7586@redhat.com>
 <C1FB7932-7722-4160-8206-765B08EA5911@cpanel.net>
 <20111219172717.GB7175@redhat.com>
 <20111219173519.GL24519@google.com>
 <20111219182717.GC7175@redhat.com>
 <20111219225635.GC6256@google.com>
 <20111220145024.GA16946@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111220145024.GA16946@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Dec 20, 2011 at 09:50:24AM -0500, Vivek Goyal wrote:
> So IIUC, existing mempool implementation is not directly usable for my
> requirement and I need to write some code of my own for the caching
> layer which always allocates objects from reserve and fills in the
> pool asynchronously with the help of a worker thread.

I've been looking at it and don't think allowing percpu allocator to
be called from no io path is a good idea.  The on-demand area filling
is tied into vmalloc area management which in turn is tied to arch
page table code and I really want to avoid pre-allocating full chunk -
it can be huge.  I'm trying to extend mempool to cover percpu areas,
so please wait a bit.

Thanks.

-- 
tejun
