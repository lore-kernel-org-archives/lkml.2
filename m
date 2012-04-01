Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568Ab2DAVXH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 17:23:07 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40106 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752614Ab2DAVXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 17:23:05 -0400
Date: Sun, 1 Apr 2012 14:22:58 -0700
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [PATCH 18/21] blkcg: move blkio_group_conf->weight to cfq
Message-ID: <20120401212258.GA12359@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1332975091-10950-1-git-send-email-tj@kernel.org>
 <1332975091-10950-19-git-send-email-tj@kernel.org>
 <20120401210955.GE6116@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120401210955.GE6116@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Vivek.

On Sun, Apr 01, 2012 at 05:09:56PM -0400, Vivek Goyal wrote:
> blkio_cgroup->weight can be thought of in a more generic manner and that
> is sytem wide cgroup weight. And more than one policy should be allowed
> to make use of it. That's a differnt thing that currently only CFQ makes
> use of it.
> 
> For example, Fengguang posted RFC patches to try to make use of blkcg->weight
> and differentiate between buffered write bandwidth.
> 
> https://lkml.org/lkml/2012/3/28/275

I don't think that's a good idea.  It makes it fuzzy which knob
controls what.  If we're gonna have single set of controls followed by
all controllers, fine, but I really don't think we should be mixing
different layers of configurations.  I mean, what about blkcg.read_bps
then?  Let's just give this one to cfq.  If someone else wants weight,
let it use its own weight config.

Thanks.

-- 
tejun
