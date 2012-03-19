Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031632Ab2CSOyQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 10:54:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25291 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757287Ab2CSOyD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 10:54:03 -0400
Date: Mon, 19 Mar 2012 15:53:54 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: dri-devel@lists.freedesktop.org
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Keith Packard <keithp@keithp.com>, David Airlie <airlied@linux.ie>,
        rjw@sisk.pl, davej@redhat.com
Subject: Re: hibernate random memory corruption, workaround i915.modeset=0
Message-ID: <20120319145349.GG6169@redhat.com>
References: <20120227124243.GG4104@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120227124243.GG4104@redhat.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 27, 2012 at 01:42:43PM +0100, Stanislaw Gruszka wrote:
> I'm able to reproduce random memory corruption after hibernate.
> Corruption is not reproducible when I disable mode setting, what
> seems to blame i915 driver or generic DRM kernel code.
> 
> I'm able to reproduce bug on Fedora 11 with 2.6.30 kernel (first
> fedora with KMS support) and on the latest 3.3-rc kernels. So this
> issue is there from very beginning, hence it is not bisectable.
> 
> I'm attaching script to reproduce (with accompanying memory checker
> program). Script is basically sequence of hibernate - reset - check
> memory. Kernel should be compiled with CONFIG_DEBUG_SLAB to detect
> poison/redzone overwrites.
>  
> I already tried to debug this using CONFIG_DEBUG_PAGEALLOC and new
> kernel option debug_guardpage_minorder, but without any success.
> Seems corruption happen behind CPU MMU, i.e. is DMA unit programming
> bug. I'm not able to turn on IOMMU on that hardware.
> 
> This happen on T500 laptop with, lspci output attached.
> 
> I'm attaching also dmesg's with poison/redzone overwrites from
> 3.3-rc4 and 2.6.30 kernels.
> 
> Some more information can be found on:
> https://bugzilla.redhat.com/show_bug.cgi?id=746169
> https://bugzilla.redhat.com/show_bug.cgi?id=701857
> 
> i.e there is invalid DMA address warning that could be a good hint:
> https://bugzilla.redhat.com/show_bug.cgi?id=746169#c7
> 
> I would appreciate any help with solving this issue. I think many
> people are hitting this, but since corruption happens at random,
> not many people notice it, or when notice, did not find out that
> this could be i915/DRM issue.

So, after googling a bit I find out that we are writing pixels into
memory and issue is known since 2010 at least:
http://codemonkey.org.uk/2012/03/12/i915-hibernate-memory-corruption/
https://bugzilla.novell.com/show_bug.cgi?id=697699
https://bugzilla.kernel.org/show_bug.cgi?id=13811
https://bugzilla.kernel.org/show_bug.cgi?id=37142

Keith, is there a chance that this bug can be fixed by i915 team?
If not, can we disable hibernate on i915 with modeset=1 and add
module option, which enable it for those who want to risk?

Thanks
Stanislaw

