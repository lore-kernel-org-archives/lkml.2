Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757415Ab2CZLII (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 07:08:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:58585 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757307Ab2CZLIG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 07:08:06 -0400
Message-ID: <1332760047.16159.93.camel@twins>
Subject: Re: [PATCH] cpuset: mm: Reduce large amounts of memory barrier
 related damage v3
From: Peter Zijlstra <peterz@infradead.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Miao Xie <miaox@cn.fujitsu.com>,
        David Rientjes <rientjes@google.com>, Christoph Lameter <cl@linux.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Date: Mon, 26 Mar 2012 13:07:27 +0200
In-Reply-To: <1332759384.16159.92.camel@twins>
References: <20120307180852.GE17697@suse.de>
	 <1332759384.16159.92.camel@twins>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-26 at 12:56 +0200, Peter Zijlstra wrote:
>  static inline bool put_mems_allowed(unsigned int seq)
>  {
> -       return !read_seqcount_retry(&current->mems_allowed_seq, seq);
> +       return likely(!read_seqcount_retry(&current->mems_allowed_seq, seq));
>  } 

Ignore this hunk, read_seqcount_retry() already has a branch hint in.
I'll send a new version if people thing the rest of the patch is worth
it.
