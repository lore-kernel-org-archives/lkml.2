Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932135Ab1CVPjy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 11:39:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56440 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756269Ab1CVPjw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 11:39:52 -0400
Date: Tue, 22 Mar 2011 11:39:27 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Lina Lu <lulina_nuaa@foxmail.com>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: Re: cfq-iosched.c: panic in cfq_dispatch_requests
Message-ID: <20110322153927.GF3757@redhat.com>
References: <201103201523220468314@foxmail.com>
 <201103222332465003523@foxmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201103222332465003523@foxmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 22, 2011 at 11:32:47PM +0800, Lina Lu wrote:
> On 2011-03-21 22:08:19, Vivek Goyal wrote:
> >On Sun, Mar 20, 2011 at 03:23:23PM +0800, Lina Lu wrote:
> >> Hi Vivek,
> >> 
> >> I did some test with blkio weight policy these days. The kernel panic 
> >> once in a while. 
> >> 	
> >> From the calltrace, It 's in func cfq_dispatch_requests(+0x058D).
> >> And I caught a divide by zero error with system monitor tools.
> >
> >Hi Lina,
> >
> >Can you please paste the full backtrace here.
> >
> >> 	
> >> The panic happens when I first set 100 weight to two IO pids, then 
> >> change the weight to 200, and begin to perform IO. The kernel panic
> >> accurately when the IO begin.
> >
> >So you notice this only if weights are changed otherwise not?
> 
> Hi Vivek
> 
> Thanks for this patch! I did objdump and find place that divide by zero.
> It's in cfq_group_slice function, the st->total_weight is zero in my issue.
> As described in the patch, this is because I change the weight when the
> group on service tree. 

Ok, so this patch did solve the issue you are facing? 

Thanks
Vivek
