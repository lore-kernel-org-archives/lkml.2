Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757296Ab2CTQsE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 12:48:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7133 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756287Ab2CTQsC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 12:48:02 -0400
Date: Tue, 20 Mar 2012 12:47:57 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Shaohua Li <shli@kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>
Subject: Re: [RFC]blk: mark discard request sync
Message-ID: <20120320164757.GG17071@redhat.com>
References: <4F62EE5E.5070207@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F62EE5E.5070207@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 16, 2012 at 03:40:14PM +0800, Shaohua Li wrote:
> 
> Subject: blk: mark discard request sync
> 
> discard is called in jbd for example. If discard is slowed down, all
> file operations could be impacted (eg, journal is full). And we always
> wait for discard to finish. So looks we should mark discard as sync.
> 
> Signed-off-by: Shaohua Li <shli@fusionio.com>

This one is tricky and I am not sure what's the right thing to do.

Generally the philosophy seems to be that request is sync is somebody
is waiting on it. To me even on async writes somebody is waiting (either
file system or a writer which has been throttled). So if we don't do
async writes in reasonable amount of time, we start getting "task blocked
for more than 120 seconds" message.

Do you have some test cases to show how bad the problem is if we don't
issue discard as SYNC request.

Thanks
Vivek
