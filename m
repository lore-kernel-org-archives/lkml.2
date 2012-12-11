Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615Ab2LKO1u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 09:27:50 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:41274 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753114Ab2LKO1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 09:27:48 -0500
Date: Tue, 11 Dec 2012 06:27:42 -0800
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Zhao Shuai <zhaoshuai@freebsd.org>, axboe@kernel.dk, ctalbott@google.com,
        rni@google.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org
Subject: Re: performance drop after using blkcg
Message-ID: <20121211142742.GE7084@htj.dyndns.org>
References: <CAFVn34SxqAJe_4P-WT8MOiG-kmKKD7ge96zoHXQuGqHWPgAt+A@mail.gmail.com>
 <20121211142518.GA5580@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121211142518.GA5580@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 11, 2012 at 09:25:18AM -0500, Vivek Goyal wrote:
> In general, do not use blkcg on faster storage. In current form it
> is at best suitable for single rotational SATA/SAS disk. I have not
> been able to figure out how to provide fairness without group idling.

I think cfq is just the wrong approach for faster non-rotational
devices.  We should be allocating iops instead of time slices.

Thanks.

-- 
tejun
