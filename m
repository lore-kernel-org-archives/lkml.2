Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762094Ab2KASt5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 14:49:57 -0400
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:48786 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750796Ab2KAStz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 14:49:55 -0400
Date: Thu, 1 Nov 2012 19:49:50 +0100
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, joro@8bytes.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 00/19 v2] Improve IRQ remapping abstraction in x86 core
 code
Message-ID: <20121101184950.GA31453@breakpoint.cc>
References: <1345470965-24410-1-git-send-email-joerg.roedel@amd.com>
 <20120826191749.GK3690@breakpoint.cc>
 <20120919145227.GS2505@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120919145227.GS2505@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 19, 2012 at 04:52:27PM +0200, Joerg Roedel wrote:
> Hi Sebastian,
Hi Joerg,

> > After browsing through the new functions in irq_remapping_modify_x86_ops() I
> > see that some of them test for "remap_ops" which is pointless because you don't
> > call irq_remapping_modify_x86_ops() if it is not the case. This also goes mostly
> > for irq_remapping_enabled.
> 
> Okay, I am usually a bit conservative when it comes to checking function
> pointers and conditions. One reason is that the Linux kernel had severe
> security bugs in the past with NULL functions pointers being called.
> Especially when future changes modify the code path these function
> pointers it is easy to forget re-adding the checks. But I will look
> again at the patches to check which checks can be removed and which
> should better stay.

But if you forget to set the pointer and you simply return doing nothing it
is kind of bad. So if you do a setup, make check at the beginning and then you
*can* expect that pointers are set. And you can never prepare against people
touching code and not thinking much.
If you look at the IRQ code or x86'ops code for instance, there are a few
places where function pointers are checked / set at the beginning and then are
called. And sometimes the functions are simple "void / return 0" code if this
is really not implemented / required but you don't have to check for it.

> Well, when something goes wrong on resume and irq-remapping doesn't work
> anymore the system is usually doomed (with and without this patch-set).
> When irq-remapping does not work the dma-remapping will likely also not
> work anymore which is even worse.

understood.

> 
> Regards,
> 
> 	Joerg
> 

Sebastian
