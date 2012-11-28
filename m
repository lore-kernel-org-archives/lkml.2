Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893Ab2K1S3T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 13:29:19 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:36948 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755870Ab2K1S3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 13:29:16 -0500
Date: Wed, 28 Nov 2012 10:29:11 -0800
From: Tejun Heo <tj@kernel.org>
To: Greg Thelen <gthelen@google.com>
Cc: Li Zefan <lizefan@huawei.com>, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cgroup: avoid creating degenerate allcg_list
Message-ID: <20121128182911.GA24683@htj.dyndns.org>
References: <1354127192-22153-1-git-send-email-gthelen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354127192-22153-1-git-send-email-gthelen@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Greg.

On Wed, Nov 28, 2012 at 10:26:32AM -0800, Greg Thelen wrote:
> Before this patch init_cgroup_root() created a degenerate list by
> first inserting a element into allcg_list and then initializing the
> inserted list element.  The initialization reset the element's
> prev/next fields forming a degenerate list where allcg_list pointed to
> element, but element pointed to itself.  This problem was introduced
> in 2243076ad128 "cgroup: initialize cgrp->allcg_node in
> init_cgroup_housekeeping()".  CONFIG_DEBUG_LIST reported a list_add
> corruption in cgroup_mkdir() running next-20121127 (ce2931a).
> 
> This patch fixes the problem by performing element initialization
> before insertion.

You're beaten by Li Zhong by 9 hrs.  :)

 http://thread.gmane.org/gmane.linux.kernel.next/25096

-- 
tejun
