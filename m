Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756805Ab1FDAZ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 20:25:57 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:59424 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756660Ab1FDAZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 20:25:55 -0400
Date: Sat, 4 Jun 2011 01:25:52 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, xfs@oss.sgi.com
Subject: Re: [PATCH 06/12] inode: Make unused inode LRU per superblock
Message-ID: <20110604002552.GU11521@ZenIV.linux.org.uk>
References: <1306998067-27659-1-git-send-email-david@fromorbit.com>
 <1306998067-27659-7-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306998067-27659-7-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 02, 2011 at 05:01:01PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The inode unused list is currently a global LRU. This does not match
> the other global filesystem cache - the dentry cache - which uses
> per-superblock LRU lists. Hence we have related filesystem object
> types using different LRU reclaimation schemes.
> 
> To enable a per-superblock filesystem cache shrinker, both of these
> caches need to have per-sb unused object LRU lists. Hence this patch
> converts the global inode LRU to per-sb LRUs.
> 
> The patch only does rudimentary per-sb propotioning in the shrinker
> infrastructure, as this gets removed when the per-sb shrinker
> callouts are introduced later on.

What protects s_nr_inodes_unused?
