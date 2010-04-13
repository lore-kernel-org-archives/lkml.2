Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836Ab0DMPNx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 11:13:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10855 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751449Ab0DMPNw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 11:13:52 -0400
Date: Tue, 13 Apr 2010 12:01:37 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/6] KVM MMU: optimize/cleanup for marking parent unsync
Message-ID: <20100413150137.GB24128@amt.cnet>
References: <4BC2D2E2.1030604@cn.fujitsu.com>
 <4BC2D390.7050708@cn.fujitsu.com>
 <20100412171211.GC4976@amt.cnet>
 <4BC3CE83.8020705@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BC3CE83.8020705@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 13, 2010 at 09:53:07AM +0800, Xiao Guangrong wrote:
> 
> 
> Marcelo Tosatti wrote:
> 
> > Xiao,
> > 
> > Did you actually see this codepath as being performance sensitive? 
> 
> Actually, i not run benchmarks to contrast the performance before this patch
> and after this patch.
> 
> > 
> > I'd prefer to not touch it.
> 
> This patch avoids walk all parents and i think this overload is really unnecessary.
> It has other tricks in this codepath but i not noticed? :-)

My point is that there is no point in optimizing something unless its
performance sensitive. And as i recall, mmu_unsync_walk was much more
sensitive performance wise than parent walking. Actually, gfn_to_memslot 
seems more important since its also noticeable on EPT/NPT hosts.

