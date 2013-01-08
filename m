Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756791Ab3AHRYz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 12:24:55 -0500
Received: from mail-da0-f41.google.com ([209.85.210.41]:48738 "EHLO
	mail-da0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756346Ab3AHRYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 12:24:53 -0500
Date: Tue, 8 Jan 2013 09:24:47 -0800
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: lizefan@huawei.com, axboe@kernel.dk, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        ctalbott@google.com, rni@google.com,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [PATCH 11/24] cfq-iosched: add leaf_weight
Message-ID: <20130108172447.GY3926@htj.dyndns.org>
References: <1356726946-26037-1-git-send-email-tj@kernel.org>
 <1356726946-26037-12-git-send-email-tj@kernel.org>
 <20130108153448.GB29635@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130108153448.GB29635@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Vivek.

On Tue, Jan 08, 2013 at 10:34:48AM -0500, Vivek Goyal wrote:
> How does it help to map leaf weight to weight in root group. Old programs
> anyway don't know about leaf_weight. So nobody is going to update it. And
> if they update it, they better know what does it do.

Because what cfq does before this patchset in flat hierarchy is
basically treating root weight as the leaf weight.

       R:500
      /     \
     A:250  B:750

Ratio of R is computed as 500 / (500 + 250 + 750).  The root blkcg's
tasks are competinig with the children blkcgs.  This is currently the
only supported config and we don't want to break existing users, so
keeping root's weight and leaf_weight synchronized and ignoring root's
weight, which BTW can't mean anything anyway as it doesn't have a
parent or siblings, keeps the behavior unchanged for flat configs.

Thanks.

-- 
tejun
