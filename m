Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756546Ab0GRPX2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jul 2010 11:23:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51614 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756442Ab0GRPX0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jul 2010 11:23:26 -0400
Date: Sun, 18 Jul 2010 18:23:21 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH 5/6] kvm, x86: use ro page and don't copy shared page
Message-ID: <20100718152321.GA20355@redhat.com>
References: <4C3FC033.3000605@cn.fujitsu.com>
 <20100716071936.GE17894@redhat.com>
 <20100716232612.GB8946@amt.cnet>
 <20100717043124.GA24480@redhat.com>
 <4C431A43.5010808@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C431A43.5010808@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 18, 2010 at 06:14:11PM +0300, Avi Kivity wrote:
> On 07/17/2010 07:31 AM, Gleb Natapov wrote:
> >>>
> >>>Currently pages allocated for guest memory are required to be RW, so after your series
> >>>behaviour will remain exactly the same as before.
> >>Except KSM pages.
> >>
> >KSM page will be COWed by __get_user_pages_fast(addr, 1, 1, page) in
> >get_user_page_and_protection() just like it COWed now, no?
> 
> Well, we don't want to COW it on write faults.
> 
> The optimal behaviour is:
> 
> - write faults: COW and instantiate a writeable spte
So do we or don't we want to COW on write faults?

--
			Gleb.
