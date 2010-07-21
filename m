Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761097Ab0GURyU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 13:54:20 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:52948 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753482Ab0GURyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 13:54:17 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6050"; a="48032475"
Subject: Re: [PATCH 2/4] mm: cma: Contiguous Memory Allocator added
From: Daniel Walker <dwalker@codeaurora.org>
To: =?UTF-8?Q?Micha=C5=82?= Nazarewicz <m.nazarewicz@samsung.com>
Cc: linux-mm@kvack.org, Marek Szyprowski <m.szyprowski@samsung.com>,
        Pawel Osciak <p.osciak@samsung.com>,
        Xiaolin Zhang <xiaolin.zhang@intel.com>,
        Hiremath Vaibhav <hvaibhav@ti.com>,
        Robert Fekete <robert.fekete@stericsson.com>,
        Marcus Lorentzon <marcus.xm.lorentzon@stericsson.com>,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-arm-msm@vger.kernel.org
In-Reply-To: <op.vf6zo9vb7p4s8u@pikus>
References: <cover.1279639238.git.m.nazarewicz@samsung.com>
	 <d6d104950c1391eaf3614d56615617cee5722fb4.1279639238.git.m.nazarewicz@samsung.com>
	 <adceebd371e8a66a2c153f429b38068eca99e99f.1279639238.git.m.nazarewicz@samsung.com>
	 <1279649724.26765.23.camel@c-dwalke-linux.qualcomm.com>
	 <op.vf5o28st7p4s8u@pikus>
	 <1279654698.26765.31.camel@c-dwalke-linux.qualcomm.com>
	 <op.vf6zo9vb7p4s8u@pikus>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Jul 2010 10:35:50 -0700
Message-ID: <1279733750.31376.14.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-07-21 at 14:01 +0200, Michał Nazarewicz wrote:

> What you are asking for is:
> 
> 	cma=a=100M cma_map=*/*=a
> 
> All devices will share the same region so that "if the video driver isn't
> using the memory" then "something else can use it". (please excuse me quoting
> you, it was stronger then me ;) ).

Ok ..

> Driver has to little information to say whether it really stopped using
> memory.  Maybe the next call will be to allocate buffers for frames and
> initialise the chip?  Sure, some “good enough” defaults can be provided
> (and the framework allows that) but still platform architect might need
> more power.

I think your talking more about optimization .. You can take that into
account ..

> > (btw, these strings your creating yikes, talk about confusing ..)
> 
> They are not that scary really.  Let's look at cma:
> 
> 	a=10M;b=10M
> 
> Split it on semicolon:
> 
> 	a=10M
> 	b=10M
> 
> and you see that it defines two regions (a and b) 10M each.

I think your assuming a lot .. I've never seen the notation before I
wouldn't assuming there's regions or whatever ..

> As of cma_map:
> 
> 	camera,video=a;jpeg,scaler=b
> 
> Again split it on semicolon:
> 
> 	camera,video=a
> 	jpeg,scaler=b
> 
> Now, substitute equal sign by "use(s) region(s)":
> 
> 	camera,video	use(s) region(s):	a
> 	jpeg,scaler	use(s) region(s):	b
> 
> No black magic here. ;)

It way too complicated .. Users (i.e. not programmers) has to use
this ..

> >> One of the purposes of the CMA framework is to make it let device
> >> drivers completely forget about the memory management and enjoy
> >> a simple API.
> >
> > The driver, and it's maintainer, are really the best people to know how
> > much memory they need and when it's used/unused. You don't really want
> > to architect them out.
> 
> This might be true if there is only one device but even then it's not
> always the case.  If many devices need physically-contiguous memory
> there is no way for them to communicate and share memory.  For best
> performance someone must look at them and say who gets what.

How do you think regular memory allocation work? I mean there's many
devices that all need different amounts of memory and they get along.
Yet your saying it's not possible .

Daniel


-- 
Sent by an consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

