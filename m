Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753260Ab2DBVtt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 17:49:49 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:65216 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717Ab2DBVts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 17:49:48 -0400
Date: Mon, 2 Apr 2012 14:49:38 -0700
From: Tejun Heo <tj@kernel.org>
To: Tao Ma <tm@tao.ma>
Cc: axboe@kernel.dk, vgoyal@redhat.com, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org
Subject: Re: [PATCH 18/21] blkcg: move blkio_group_conf->weight to cfq
Message-ID: <20120402214938.GA19634@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1332975091-10950-1-git-send-email-tj@kernel.org>
 <1332975091-10950-19-git-send-email-tj@kernel.org>
 <4F7A1C8B.3010402@tao.ma>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F7A1C8B.3010402@tao.ma>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Apr 03, 2012 at 05:39:23AM +0800, Tao Ma wrote:
> I guess blkio->weight is a generic way of abstracting the weight between
> different block cgroups.

It isn't and can't be.  There's nothing generic about it across
different policies and it's not even clear what that means.  If the
user chooses combine, iops limit with cfq weights, what the hell is
"generic" about that weight?

> Yes, currently, only cfq uses it, but I am
> trying to improve Shaohua's original fiops scheduler and add cgroup
> support to it. So please leave it there so that future scheduler(if
> other than the fiops scheduler) can use the framework.

So, if you want to implement a new blkcg policy, add the config
parameters and export the stats the policy wants *yourself*.  Not
having clear separation between policies and generic stuff was what
led us to this yucky mess and there's no way we're going back there.
So, NO.

Thanks.

-- 
tejun
