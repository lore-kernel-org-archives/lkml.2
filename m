Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757949Ab1LWWyH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 17:54:07 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:42353 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757901Ab1LWWyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 17:54:04 -0500
MIME-Version: 1.0
In-Reply-To: <20111223010042.GA12738@redhat.com>
References: <1324590326-10135-1-git-send-email-tj@kernel.org>
	<1324590326-10135-8-git-send-email-tj@kernel.org>
	<20111223010042.GA12738@redhat.com>
Date: Fri, 23 Dec 2011 14:54:03 -0800
X-Google-Sender-Auth: E_8bocMxr2287Q7eyROrVPVQYuM
Message-ID: <CAOS58YOH10ecpV3z1mR=uUnz0+hqdkBOF0q4HkXSSC-LiQjU+w@mail.gmail.com>
Subject: Re: [PATCH 7/7] block: fix deadlock through percpu allocation in blk-cgroup
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: akpm@linux-foundation.org, avi@redhat.com, nate@cpanel.net,
        cl@linux-foundation.org, oleg@redhat.com, axboe@kernel.dk,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Dec 22, 2011 at 5:00 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> So this pool is global and shared by all devices (both by CFQ and
> throttling logic). I am not sure if there are any advantages of having
> this pool per queue. In one of the mails you mentioned that dm is having
> one pool across many devices which defeats the purpose of having mempool.
>
> **********************************************************************
> It seemed the problem was dm sharing the same pool from multiple devices
> (which defeats the purpose of using mempool BTW)
> *********************************************************************
>
> Not sure why devices sharing a mempool is a bad idea. Having a global pool
> definitely simplifies the implementation a lot in this case.

Ooh, sharing breaks the forward progress guarantee by mempool. blkcg
isn't using mempool for that. It's just using it as allocation buffer
so it isn't relevant.

Thanks.

-- 
tejun
