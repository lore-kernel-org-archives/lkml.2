Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935662Ab2JaOOc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 10:14:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3775 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935517Ab2JaOOb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 10:14:31 -0400
Date: Wed, 31 Oct 2012 10:14:26 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Mitsuhiro Tanino <mitsuhiro.tanino.gm@hitachi.com>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [Patch 0/2] Exclude hwpoison page from vmcore dump
Message-ID: <20121031141426.GE1865@redhat.com>
References: <508FDEF3.8030601@hitachi.com>
 <20121030143750.GF2290@redhat.com>
 <50912CFB.5000508@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50912CFB.5000508@hitachi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31, 2012 at 10:51:55PM +0900, Mitsuhiro Tanino wrote:
> Hi Vivek,
> 
> (2012/10/30 23:37), Vivek Goyal wrote:
> > Why to introduce this option "-p"? Until and unless there are serious
> > side effects, this should be default functionality. Isn't it? Who would
> > like to touch/save poisoned pages and run into MCE?
> 
> Thank you for your review of my patch.
> 
> In my understanding, hwpoison is a function which is only supported at
> high end servers and most of users do not use this function.
> Therefore, I think this functionality was better for option.

If hwpoision functionality is not available in hardware, then respective
bit will not be even set in struct page and it will be saved by default.
So it should not matter whether hardware has hwpoision functionality
or not.

> 
> On the other hand, as you say, nobody wants to touch/save poisoned pages
> and run into MCE, and it is desirable for users to exclude hwpoison pages
> automatically. I agree with you.
> 
> I will post fixed patch without "-p" option. Please help to review it.

I think that removing hwpoisno pages by default makes sense. If somebody
does have a reasonable case of not doing so, then we could either
introduce anther filtering level (based on type) or add another command
line option like (--no-hwposion-filtering) etc.

Thanks
Vivek
