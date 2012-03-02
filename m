Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751104Ab2CBFFQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 00:05:16 -0500
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:45540 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753Ab2CBFFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 00:05:13 -0500
Date: Fri, 2 Mar 2012 14:11:34 +0900
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
To: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Cc: avi@redhat.com, mtosatti@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] KVM: Avoid checking huge page mappings in
 get_dirty_log()
Message-Id: <20120302141134.1971c5da.yoshikawa.takuya@oss.ntt.co.jp>
In-Reply-To: <20120302115624.46cbaa00.yoshikawa.takuya@oss.ntt.co.jp>
References: <20120301193007.04b2db8e.yoshikawa.takuya@oss.ntt.co.jp>
	<20120301193216.b14538bb.yoshikawa.takuya@oss.ntt.co.jp>
	<20120302115624.46cbaa00.yoshikawa.takuya@oss.ntt.co.jp>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp> wrote:

> Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp> wrote:
> 
> > +	while (mask) {
> > +		rmapp = &slot->rmap[gfn_offset + __ffs(mask)];
> > +		__rmap_write_protect(kvm, rmapp, PT_PAGE_TABLE_LEVEL);
> >  
> > -	return write_protected;
> > +		/* clear the first set bit */
> > +		mask &= mask - 1;
> > +	}
> >  }
> 
> while (mask) {
> 	fsbit = __ffs(mask);
> 	gfn_offset += fsbit;
> 	mask >>= fsbit + 1;
> 
> 	rmapp = &slot->rmap[gfn_offset];
> 	__rmap_write_protect(kvm, rmapp, PT_PAGE_TABLE_LEVEL);
> }
> 
> Seems to be better: BSF friendly.

I was wrong.

"and < shift" and bsf did not show any difference for this kind of loop
on my box.  So we should keep the original implementation.

	Takuya
