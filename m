Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753067Ab1LSNkW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 08:40:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60760 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752622Ab1LSNkR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 08:40:17 -0500
Date: Mon, 19 Dec 2011 08:40:12 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Nate Custer <nate@cpanel.net>
Cc: Jens Axboe <axboe@kernel.dk>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFT PATCH] blkio: alloc per cpu data from worker thread
 context( Re: kvm deadlock)
Message-ID: <20111219134012.GA7175@redhat.com>
References: <54FC5923-2123-4BDD-A506-EA57DCE0C1F6@cpanel.net>
 <20111214122511.GD18317@amt.cnet>
 <4EE8A7ED.7060703@redhat.com>
 <4EE8C8EA.9070207@kernel.dk>
 <20111215194712.GA11194@redhat.com>
 <E73DB38E-AFC5-445D-9E76-DE599B36A814@cpanel.net>
 <20111216202907.GH7586@redhat.com>
 <C1FB7932-7722-4160-8206-765B08EA5911@cpanel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C1FB7932-7722-4160-8206-765B08EA5911@cpanel.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 18, 2011 at 03:25:48PM -0600, Nate Custer wrote:
> 
> On Dec 16, 2011, at 2:29 PM, Vivek Goyal wrote:
> > Thanks for testing it Nate. I did some debugging and found out that patch
> > is doing double free on per cpu pointer hence the crash you are running
> > into. I could reproduce this problem on my box. It is just a matter of
> > doing rmdir on the blkio cgroup.
> > 
> > I understood the cmpxchg() semantics wrong. I have fixed it now and
> > no crashes on directory removal. Can you please give this version a
> > try.
> > 
> > Thanks
> > Vivek
> 
> After 24 hours of stress testing the machine remains up and working without issue. I will continue to test it, but am reasonably confident that this patch resolves my issue.

That's good to know. While you continue to stress test, I will make some
minor modifications to the patch. (Thinking of delaying the retry of
allocation of per cpu memory in case previous attempts failed).

Thanks
Vivek
