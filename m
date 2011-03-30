Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754608Ab1C3Hcj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 03:32:39 -0400
Received: from mga14.intel.com ([143.182.124.37]:41633 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753672Ab1C3Hci (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 03:32:38 -0400
Message-Id: <849307$c7qtj5@azsmga001.ch.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,267,1299484800"; 
   d="scan'208";a="410875493"
Date: Wed, 30 Mar 2011 08:32:33 +0100
To: Dave Airlie <airlied@gmail.com>, Jerome Glisse <j.glisse@gmail.com>
Subject: Re: GEM-related desktop sluggishness due to linear-time arch_get_unmapped_area_topdown()
Cc: r6144 <rainy6144@gmail.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
References: <1301310995.5615.92.camel@wangqingchuan> <1301336010.2217.20.camel@workstation> <AANLkTikMJszEyv8-SMMjD-MeykSwmsKf=gmezcMgySoP@mail.gmail.com> <1301409864.5615.98.camel@wangqingchuan> <AANLkTi=fcWBpmQ66a3+vQwgFOXn=0rJAviNzR4a0mfcJ@mail.gmail.com> <1301421664.2151.12.camel@Portable-Work> <AANLkTin_v5h==E0i5mQgK2AEdaZhwViykr3acbz4CW0k@mail.gmail.com> <20110329202608.GA3454@viiv.ffwll.ch> <AANLkTim2AyGPrun8MNq0=TyXpJ+b8i=eyHhLz01F+f2P@mail.gmail.com> <AANLkTi=vFwoKCOsvyGBQA9w01QX_TwGu_GF6mA0grr2o@mail.gmail.com>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <AANLkTi=vFwoKCOsvyGBQA9w01QX_TwGu_GF6mA0grr2o@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Mar 2011 07:57:49 +1000, Dave Airlie <airlied@gmail.com> wrote:
> On Wed, Mar 30, 2011 at 7:04 AM, Jerome Glisse <j.glisse@gmail.com> wrote:
> > What i had in mind was something little bit more advance that pwrite,
> > somethings that would take width,height,pitch of userpage and would be
> > able to perform proper blit. But yes pwrite in intel is kind of
> > limited.
> 
> TTM has support for userpage binding we just don't use it.

Yes, and I've been experimenting with the same in GEM to great effect in
the DDX. The complication remains in managing the CPU synchronisation,
which suggests that it would only be useful for STREAM_DRAW objects (and
perhaps the sub-region updates to STATIC_DRAW). (And for readback, if
retrieving the data were the actual bottleneck.)

And I did play with a new pread/pwrite interface that did as you suggest,
binding the user pages and performing a blit. But by the time you make the
interface asynchronous, it becomes much easier to let the client code
create the mapping and be fully aware of the barriers.

And yes I do concur that vma bookkeeping does impose significant overheads
and I have been removing as many mappings from our drivers as I can; within
the limitations of the pwrite interface.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
