Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752591Ab0I3Evj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 00:51:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40837 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751741Ab0I3Evh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 00:51:37 -0400
Date: Wed, 29 Sep 2010 21:52:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/17] fs: icache lock lru/writeback lists
Message-Id: <20100929215240.feb118f3.akpm@linux-foundation.org>
In-Reply-To: <1285762729-17928-7-git-send-email-david@fromorbit.com>
References: <1285762729-17928-1-git-send-email-david@fromorbit.com>
	<1285762729-17928-7-git-send-email-david@fromorbit.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Sep 2010 22:18:38 +1000 Dave Chinner <david@fromorbit.com> wrote:

> The inode moves between different lists protected by the inode_lock. Introduce
> a new lock that protects all of the lists (dirty, unused, in use, etc) that the
> inode will move around as it changes state. As this is mostly a list for
> protecting the writeback lists, name it wb_inode_list_lock and nest all the
> list manipulations in this lock inside the current inode_lock scope.

All those spin_trylock()s are real ugly.  They're unexplained in the
changelog and unexplained in code comments.

I'd suggest that each such site have a comment explaining why we're
resorting to this.

