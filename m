Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933839Ab2C2ULd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 16:11:33 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:54487 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754311Ab2C2UL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 16:11:26 -0400
MIME-Version: 1.0
In-Reply-To: <1333051616.15602.23.camel@joe2Laptop>
References: <20120329164842.GE28941@google.com>
	<1333044612.15602.4.camel@joe2Laptop>
	<CAOS58YOWA9U3Esb2535v_iivPaXeFYYS3nWd2KKF1=MsfZ0Piw@mail.gmail.com>
	<1333051616.15602.23.camel@joe2Laptop>
Date: Thu, 29 Mar 2012 13:11:25 -0700
X-Google-Sender-Auth: lxaWUcZklyb2Wg6lbn1XxtiHi0s
Message-ID: <CAOS58YMjB4HrNOxWMjm=EKqZNd9QmK+QjSv2EfMbYs9MKk+-tA@mail.gmail.com>
Subject: Re: [PATCH] percpu: use KERN_CONT in pcpu_dump_alloc_info()
From: Tejun Heo <tj@kernel.org>
To: Joe Perches <joe@perches.com>
Cc: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Kay Sievers <kay.sievers@vrfy.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Mar 29, 2012 at 1:06 PM, Joe Perches <joe@perches.com> wrote:
> It'd be just for avoidance of any other possible
> interleaving from other threads.
>
> It's an __init function so that's not too likely,
> but if it every happens...

Ah, okay.  Forgot about that.  Yeah, the kernel is single threaded at
that point, so it shouldn't matter. The code is rather complex so
something simpler would be nice, I agree.

Another thing is that we seem to have structured logging coming our
way and maybe userspace can deal with racing continuing printks? Not
sure how different streams could be distinguished tho. Maybe the
printing task can be used to group them? Kay, is this something
structured logging would solve?

Thanks.

-- 
tejun
