Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757286Ab2CBCuF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 21:50:05 -0500
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:40945 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757088Ab2CBCuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 21:50:03 -0500
Date: Fri, 2 Mar 2012 11:56:24 +0900
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
To: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Cc: avi@redhat.com, mtosatti@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] KVM: Avoid checking huge page mappings in
 get_dirty_log()
Message-Id: <20120302115624.46cbaa00.yoshikawa.takuya@oss.ntt.co.jp>
In-Reply-To: <20120301193216.b14538bb.yoshikawa.takuya@oss.ntt.co.jp>
References: <20120301193007.04b2db8e.yoshikawa.takuya@oss.ntt.co.jp>
	<20120301193216.b14538bb.yoshikawa.takuya@oss.ntt.co.jp>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp> wrote:

> +	while (mask) {
> +		rmapp = &slot->rmap[gfn_offset + __ffs(mask)];
> +		__rmap_write_protect(kvm, rmapp, PT_PAGE_TABLE_LEVEL);
>  
> -	return write_protected;
> +		/* clear the first set bit */
> +		mask &= mask - 1;
> +	}
>  }

while (mask) {
	fsbit = __ffs(mask);
	gfn_offset += fsbit;
	mask >>= fsbit + 1;

	rmapp = &slot->rmap[gfn_offset];
	__rmap_write_protect(kvm, rmapp, PT_PAGE_TABLE_LEVEL);
}

Seems to be better: BSF friendly.

I will update this function and post the result with dirty-log-perf output!

	Takuya
