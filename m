Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752079Ab1LRVZy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 16:25:54 -0500
Received: from mx1.cpanel.net ([208.74.121.68]:59063 "EHLO mx1.cpanel.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751892Ab1LRVZv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 16:25:51 -0500
Subject: Re: [RFT PATCH] blkio: alloc per cpu data from worker thread context( Re: kvm deadlock)
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Nate Custer <nate@cpanel.net>
In-Reply-To: <20111216202907.GH7586@redhat.com>
Date: Sun, 18 Dec 2011 15:25:48 -0600
Cc: Jens Axboe <axboe@kernel.dk>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <C1FB7932-7722-4160-8206-765B08EA5911@cpanel.net>
References: <54FC5923-2123-4BDD-A506-EA57DCE0C1F6@cpanel.net> <20111214122511.GD18317@amt.cnet> <4EE8A7ED.7060703@redhat.com> <4EE8C8EA.9070207@kernel.dk> <20111215194712.GA11194@redhat.com> <E73DB38E-AFC5-445D-9E76-DE599B36A814@cpanel.net> <20111216202907.GH7586@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
X-Mailer: Apple Mail (2.1084)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - mx1.cpanel.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - cpanel.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Dec 16, 2011, at 2:29 PM, Vivek Goyal wrote:
> Thanks for testing it Nate. I did some debugging and found out that patch
> is doing double free on per cpu pointer hence the crash you are running
> into. I could reproduce this problem on my box. It is just a matter of
> doing rmdir on the blkio cgroup.
> 
> I understood the cmpxchg() semantics wrong. I have fixed it now and
> no crashes on directory removal. Can you please give this version a
> try.
> 
> Thanks
> Vivek

After 24 hours of stress testing the machine remains up and working without issue. I will continue to test it, but am reasonably confident that this patch resolves my issue.

Nate Custer