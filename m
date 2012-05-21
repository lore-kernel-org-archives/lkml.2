Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757962Ab2EUKsZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 06:48:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4062 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757814Ab2EUKsX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 06:48:23 -0400
Message-ID: <4FBA1D73.2030600@redhat.com>
Date: Mon, 21 May 2012 13:48:19 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: "Hao, Xudong" <xudong.hao@intel.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>,
        Xudong Hao <xudong.hao@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Shan, Haitao" <haitao.shan@intel.com>,
        "Zhang, Xiantao" <xiantao.zhang@intel.com>
Subject: Re: [PATCH 4/4] Enabling Access bit when doing memory swapping
References: <20120516011230.GE14256@hp-xd.sh.intel.com> <20120518022241.GA14096@amt.cnet> <403610A45A2B5242BD291EDAE8B37D300FDC6BEE@SHSMSX102.ccr.corp.intel.com> <4FB9FD68.7000908@redhat.com> <403610A45A2B5242BD291EDAE8B37D300FDC6E99@SHSMSX102.ccr.corp.intel.com>
In-Reply-To: <403610A45A2B5242BD291EDAE8B37D300FDC6E99@SHSMSX102.ccr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/21/2012 01:35 PM, Hao, Xudong wrote:
> > 
> > That doesn't answer the question.  An atomic operation is now non-atomic.
> > 
> > You can calculate shadow_accessed_bit and keep on using clear_bit(), or
> > switch to cmpxchg64(), but don't just drop the dirty bit here.
> > 
>
> I know your meaning. How about this changes:
>
> ...
>             young = 1;
> +            if (enable_ept_ad_bits)
> +                clear_bit(ffs(shadow_accessed_mask), (unsigned long *)spte);

ffs() returns an off-by-one result, so this needs to be adjusted.  IIRC
bsfl is slow, but this shouldn't be a problem here.


-- 
error compiling committee.c: too many arguments to function

