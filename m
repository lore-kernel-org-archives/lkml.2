Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754459Ab0LOIQ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 03:16:56 -0500
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:28076 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753817Ab0LOIQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 03:16:54 -0500
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=dyVpuHYQJROgCHwBBw1H+I+7e1rgZIKdHwrI0HSbuo4= c=1 sm=1
 a=T_s9W1-Te7oA:10 a=BLceEmwcHowA:10 a=kj9zAlcOel0A:10 a=xqWC_Br6kY4A:10
 a=c23vf5CSMVc0QQz9B4a6RA==:17 a=zg_s4_ytUHLA_PBxeyIA:9
 a=I5np2YJ04-EF1SHuVVoA:7 a=HO-cfWrDIEFq09kOX_JHV1tvSicA:4 a=CjuIK1q_8ugA:10
 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Subject: Re: [patch] fs: scale vfsmount refcount (was Re: rcu-walk and  dcache scaling tree update and status)
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
From: Andreas Dilger <adilger.kernel@dilger.ca>
In-Reply-To: <20101214124059.GA14493@amd>
Date: Wed, 15 Dec 2010 01:16:52 -0700
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <3E111710-7F88-41A8-80B2-9275448BBCED@dilger.ca>
References: <20101213023733.GB6522@amd> <20101213024217.GC6522@amd> <1292225113.18698.22.camel@edumazet-laptop> <20101214124059.GA14493@amd>
To: Nick Piggin <npiggin@kernel.dk>
X-Mailer: Apple Mail (2.1082)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-12-14, at 05:40, Nick Piggin wrote:
> +static inline void add_mnt_count(struct vfsmount *mnt, int n)
> +static inline void set_mnt_count(struct vfsmount *mnt, int n)
> +static inline void inc_mnt_count(struct vfsmount *mnt)
> +static inline void dec_mnt_count(struct vfsmount *mnt)
> +unsigned int count_mnt_count(struct vfsmount *mnt)

Minor nit - it is easier to find these related functions via tag
completion if they are of the form "mnt_count_{add,set,inc,dec}"
and it would also be more consistent and easier to understand if
you rename count_mnt_count() to mnt_count_sum() or mnt_count_read().

This also follows the kernel naming convention much more closely
(e.g. atomic_{inc,dec,add,sub,set,read}(), mutex_{init,lock,unlock}(),
etc), which is normally of the form {type}_{action}.

Yes, I see the other {inc,dec,count}_mnt_writers() functions
exist, but I'd prefer not to add more bad function names to
the kernel.  Maybe a separate patch to clean up those names is
in order...

Cheers, Andreas





