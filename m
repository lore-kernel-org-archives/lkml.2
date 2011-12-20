Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751925Ab1LTMta (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 07:49:30 -0500
Received: from merlin.infradead.org ([205.233.59.134]:57144 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125Ab1LTMtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 07:49:20 -0500
Message-ID: <4EF0844A.4090600@kernel.dk>
Date: Tue, 20 Dec 2011 13:49:14 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Tejun Heo <tj@kernel.org>, Nate Custer <nate@cpanel.net>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        kvm@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFT PATCH] blkio: alloc per cpu data from worker thread context(
 Re: kvm deadlock)
References: <54FC5923-2123-4BDD-A506-EA57DCE0C1F6@cpanel.net> <20111214122511.GD18317@amt.cnet> <4EE8A7ED.7060703@redhat.com> <4EE8C8EA.9070207@kernel.dk> <20111215194712.GA11194@redhat.com> <E73DB38E-AFC5-445D-9E76-DE599B36A814@cpanel.net> <20111216202907.GH7586@redhat.com> <C1FB7932-7722-4160-8206-765B08EA5911@cpanel.net> <20111219172717.GB7175@redhat.com> <20111219173519.GL24519@google.com> <20111219182717.GC7175@redhat.com>
In-Reply-To: <20111219182717.GC7175@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-12-19 19:27, Vivek Goyal wrote:
> I think reverting the previous series is not going to be simple either. It
> had 13 patches.
> 
> https://lkml.org/lkml/2011/5/19/560
> 
> By making stats per cpu, I was able to reduce contention on request
> queue lock. Now we shall have to bring the lock back. 

That's not going to happen, having that lock in there was a disaster for
small IO on fast devices. It's essentially the limiting factor on
benchmark runs on the RHEL kernels that have it included and enabled...


-- 
Jens Axboe

