Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752277Ab1LSW4q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 17:56:46 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:46802 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126Ab1LSW4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 17:56:42 -0500
Date: Mon, 19 Dec 2011 14:56:35 -0800
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Nate Custer <nate@cpanel.net>, Jens Axboe <axboe@kernel.dk>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        kvm@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFT PATCH] blkio: alloc per cpu data from worker thread
 context( Re: kvm deadlock)
Message-ID: <20111219225635.GC6256@google.com>
References: <20111214122511.GD18317@amt.cnet>
 <4EE8A7ED.7060703@redhat.com>
 <4EE8C8EA.9070207@kernel.dk>
 <20111215194712.GA11194@redhat.com>
 <E73DB38E-AFC5-445D-9E76-DE599B36A814@cpanel.net>
 <20111216202907.GH7586@redhat.com>
 <C1FB7932-7722-4160-8206-765B08EA5911@cpanel.net>
 <20111219172717.GB7175@redhat.com>
 <20111219173519.GL24519@google.com>
 <20111219182717.GC7175@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111219182717.GC7175@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Vivek.

On Mon, Dec 19, 2011 at 01:27:17PM -0500, Vivek Goyal wrote:
> Ok, that's good to know. If per cpu allocator can support this use case,
> it will be good for 3.3 onwards. This seems to be right way to go to fix
> the problem.

Ummm... if we're gonna make percpu usable w/ GFP_NOIO, the right
interim solution would be making a simplistic mempool so that later
when percpu can do it, it can be swapped easily.  I really can't see
much benefit of adding refcnting on top of everything just for this.

Thanks.

-- 
tejun
