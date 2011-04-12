Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754472Ab1DLTPm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 15:15:42 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:39126 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317Ab1DLTPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 15:15:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=iy6OCOGj6FuDh+PuoFrkN2xCRBg73g1ToNMwFu9p7+qVtCkjeADuG//iLabLIr9ZoU
         LRDiFWmh36gLyeirat56IhLJXtOZsc6ITxkbVgajVillhpV7DfM44VUyqskWhPdJt0MQ
         wfYdhpDMAI3ElhwkFjzRiIiO5Ppw4BVWUtrd8=
Date: Wed, 13 Apr 2011 04:15:34 +0900
From: Tejun Heo <tj@kernel.org>
To: Shaohua Li <shaohua.li@intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, cl@linux.com
Subject: Re: [PATCH 4/4]percpu_counter: use atomic64 for counter
Message-ID: <20110412191534.GE16342@mtj.dyndns.org>
References: <1302595446.3981.130.camel@sli10-conroe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302595446.3981.130.camel@sli10-conroe>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Apr 12, 2011 at 04:04:06PM +0800, Shaohua Li wrote:
> should tunning the batch count, but if we can make percpu_counter better, why
> not?

First of all, the lock being only in slow paths, it's quite unlikely
to get ever contended.  Also, because the lock duration is always
extremely short, conversion to atomic_t isn't too likely to gain
anything significant, especially in cold paths.

That said, if it's all gains, why not?  I don't know.  Maybe.  Given
problems in the previous patches, I don't feel too enthusiastic for
this series at this point but I'm quite sleep deprived now so it might
just be me not the patch itself.

Thanks.

-- 
tejun
