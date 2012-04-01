Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653Ab2DAVKF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 17:10:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753132Ab2DAVKD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 17:10:03 -0400
Date: Sun, 1 Apr 2012 17:09:56 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [PATCH 18/21] blkcg: move blkio_group_conf->weight to cfq
Message-ID: <20120401210955.GE6116@redhat.com>
References: <1332975091-10950-1-git-send-email-tj@kernel.org>
 <1332975091-10950-19-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332975091-10950-19-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 28, 2012 at 03:51:28PM -0700, Tejun Heo wrote:
> blkio_group_conf->weight is owned by cfq and has no reason to be
> defined in blkcg core.  Replace it with cfq_group->dev_weight and let
> conf setting functions directly set it.  If dev_weight is zero, the
> cfqg doesn't have device specific weight configured.
> 
> Also, rename BLKIO_WEIGHT_* constants to CFQ_WEIGHT_* and rename
> blkio_cgroup->weight to blkio_cgroup->cfq_weight.  We eventually want
> per-policy storage in blkio_cgroup but just mark the ownership of the
> field for now.

Hi Tejun,

blkio_cgroup->weight can be thought of in a more generic manner and that
is sytem wide cgroup weight. And more than one policy should be allowed
to make use of it. That's a differnt thing that currently only CFQ makes
use of it.

For example, Fengguang posted RFC patches to try to make use of blkcg->weight
and differentiate between buffered write bandwidth.

https://lkml.org/lkml/2012/3/28/275

Thanks
Vivek
