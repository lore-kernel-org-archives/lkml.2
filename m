Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752988Ab0CSJUM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 05:20:12 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:33539 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978Ab0CSJUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 05:20:10 -0400
Date: Fri, 19 Mar 2010 18:19:04 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Anthony Liguori <anthony@codemonkey.ws>
Cc: Ingo Molnar <mingo@elte.hu>, Avi Kivity <avi@redhat.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       ziteng.huang@intel.com, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single project
Message-ID: <20100319091904.GF10003@linux-sh.org>
References: <20100318085607.GB2157@elte.hu> <4BA1FC80.2000401@redhat.com> <20100318105013.GB24464@elte.hu> <4BA20EB8.60707@redhat.com> <20100318114821.GB13168@elte.hu> <4BA21B09.6060706@redhat.com> <20100318130047.GA7424@elte.hu> <4BA23FE1.5050402@codemonkey.ws> <20100318151737.GA2875@elte.hu> <4BA250BF.80704@codemonkey.ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA250BF.80704@codemonkey.ws>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 18, 2010 at 11:11:43AM -0500, Anthony Liguori wrote:
> On 03/18/2010 10:17 AM, Ingo Molnar wrote:
> >* Anthony Liguori<anthony@codemonkey.ws>  wrote:
> >>On 03/18/2010 08:00 AM, Ingo Molnar wrote:
> >>>>[...]  kvm in fact knows nothing about vga, to take your last example.
> >>>>[...]
> >>>>         
> >>>Look at the VGA dirty bitmap optimization a'ka the KVM_GET_DIRTY_LOG
> >>>ioctl.
> >>>
> >>>See qemu/kvm-all.c's kvm_physical_sync_dirty_bitmap().
> >>>
> >>>It started out as a VGA optimization (also used by live migration) and
> >>>even today it's mostly used by the VGA drivers - albeit a weak one.
> >>>
> >>>I wish there were stronger VGA optimizations implemented, copying the
> >>>dirty bitmap is not a particularly performant solution. (although it's
> >>>certainly better than full emulation) Graphics performance is one of the
> >>>more painful aspects of KVM usability today.
> >>>       
> >>We have to maintain a dirty bitmap because we don't have a paravirtual
> >>graphics driver.  IOW, someone needs to write an Xorg driver.
> >>
> >>Ideally, we could just implement a Linux framebuffer device, right?
> >>     
> >No, you'd want to interact with DRM.
> 
> Using DRM doesn't help very much.  You still need an X driver and most 
> of the operations you care about (video rendering, window movement, etc) 
> are not operations that need to go through DRM.
> 
> 3D graphics virtualization is extremely difficult in the non-passthrough 
> case.  It really requires hardware support that isn't widely available 
> today (outside a few NVIDIA chipsets).
> 
Implementing a virtualized DRM/KMS driver would at least get you the
framebuffer interface more or less for free, while allowing you to deal
with the userspace side of things incrementally (ie, running a dummy xorg
on top of the virtualized fbdev until the DRI side catches up). It would
also enable you to focus on the 2D and 3D parts independently.

> It doesn't provide the things we need to a good user experience.  You 
> need things like an absolute input device, host driven display resize, 
> RGBA hardware cursors.  None of these go through DRI and it's those 
> things that really provide the graphics user experience.
> 
None of these things negate the benefit one would get from a virtualized
DRM/KMS driver either. There are multiple problems that need solving in
this area, and it's a bit disingenuous to discount a valid suggestion out
of hand due to the fact it doesn't solve all of the outstanding issues.
