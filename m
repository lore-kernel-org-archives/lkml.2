Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932516Ab1LPSsD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 13:48:03 -0500
Received: from mx1.cpanel.net ([208.74.121.68]:53836 "EHLO mx1.cpanel.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760395Ab1LPSr5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 13:47:57 -0500
From: Nate Custer <nate@cpanel.net>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: Re: [RFT PATCH] blkio: alloc per cpu data from worker thread context( Re: kvm deadlock)
Date: Fri, 16 Dec 2011 12:47:55 -0600
Message-Id: <7E70F89E-F763-4642-8F2F-5FA1992C7778@cpanel.net>
Cc: Jens Axboe <axboe@kernel.dk>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1084)
X-Mailer: Apple Mail (2.1084)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - mx1.cpanel.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - cpanel.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Dec 15, 2011, at 1:47 PM, Vivek Goyal wrote:
> Ok, I continued to develop on the patch which tries to allocate per cpu
> stats from worker thread context. Here is the patch.
> 
> Can the reporter please try out the patch and see if it helps. I am not
> sure if deadlock was because of mutex issue or not, but it should help
> get rid of lockdep warning.
> 
> This patch is on top of for-3.3/core branch of jens's linux-block tree.
> If it does not apply on your kernel version, do let me know the version 
> you are testing with and I will generate another version of patch.
> 
> If testing results are good, I will break down the patch in small pieces
> and post as a series separately.
> 
> Thanks
> Vivek

Running on a fedora-16 box with the patch applied to the linux-block tree I still had deadlocks. In fact it seemed to happen much faster and with ligher workloads.

I was able to get netconsole setup and a full stacktrace is posted here:

http://pastebin.com/9Rq68exU

Nate

