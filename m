Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425Ab0GEMBl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 08:01:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51210 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752881Ab0GEMBj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 08:01:39 -0400
Date: Mon, 5 Jul 2010 09:01:18 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 4/6] KVM: MMU: prefetch ptes when intercepted guest #PF
Message-ID: <20100705120118.GB15826@amt.cnet>
References: <4C2C9DC0.8050607@cn.fujitsu.com>
 <4C2C9E45.1040304@cn.fujitsu.com>
 <20100702165432.GB25969@amt.cnet>
 <4C2EF00A.2090406@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C2EF00A.2090406@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 03, 2010 at 04:08:42PM +0800, Xiao Guangrong wrote:
> 
> 
> Marcelo Tosatti wrote:
> 
> >> +
> >> +		if (is_rsvd_bits_set(vcpu, gpte, PT_PAGE_TABLE_LEVEL))
> >> +			break;
> > 
> > BTW, doesnt sync_page also lack reserved bit checking? (unrelated to
> > this patch).
> > 
> 
> I think it's not since if EPT is enabled, no unsync page exist, the sync page
> path can't be trigged. :-)

What i mean is, why the sync_page path does not require reserved bit
checking? (EPT disabled).

Just to clarify, this has nothing to do with your patch.

