Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757113Ab1EaQKc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 12:10:32 -0400
Received: from mga09.intel.com ([134.134.136.24]:41876 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756776Ab1EaQKb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 12:10:31 -0400
X-ExtLoop1: 1
Subject: Re: [PATCH 14/14] tmpfs: no need to use i_lock
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
In-Reply-To: <alpine.LSU.2.00.1105301754050.5482@sister.anvils>
References: <alpine.LSU.2.00.1105301726180.5482@sister.anvils>
	 <alpine.LSU.2.00.1105301754050.5482@sister.anvils>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 31 May 2011 09:08:10 -0700
Message-ID: <1306858090.2577.147.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-30 at 17:55 -0700, Hugh Dickins wrote:
> 2.6.36's 7e496299d4d2 to make tmpfs scalable with percpu_counter used
> inode->i_lock in place of sbinfo->stat_lock around i_blocks updates;
> but that was adverse to scalability, and unnecessary, since info->lock
> is already held there in the fast paths.
> 
> Remove those uses of i_lock, and add info->lock in the three error
> paths where it's then needed across shmem_free_blocks().  It's not
> actually needed across shmem_unacct_blocks(), but they're so often
> paired that it looks wrong to split them apart.
> 
> Signed-off-by: Hugh Dickins <hughd@google.com>
> Cc: Tim Chen <tim.c.chen@linux.intel.com>
> ---

Acked.  

Tim Chen



