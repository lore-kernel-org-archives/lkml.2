Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754458Ab2LLEMR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 23:12:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59098 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754117Ab2LLEMP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 23:12:15 -0500
Date: Wed, 12 Dec 2012 00:11:32 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: gleb@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 00/10] kvm: memory slot cleanups, fix, and increase
Message-ID: <20121212021132.GD2898@amt.cnet>
References: <20121210171417.10461.20079.stgit@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121210171417.10461.20079.stgit@bling.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 10, 2012 at 10:32:39AM -0700, Alex Williamson wrote:
> v2: Update 02/10 to not check userspace_addr when slot is removed.
>     Yoshikawa-san withdrew objection to increase slot_bitmap prior
>     to his series to remove slot_bitmap.
> 
> This series does away with any kind of complicated resizing of the
> slot array and simply does a one time increase.  I do compact struct
> kvm_memory_slot a bit to take better advantage of the space we are
> using.  This reduces each slot from 64 bytes (x86_64) to 56 bytes.
> By enforcing the API around valid operations for an unused slot and
> fields that can be modified runtime, I found and was able to fix a
> bug in iommu mapping for slots.  The renames enabled me to find the
> previously posted bug fix for catching slot overlaps.
> 
> As mentioned in the series, the primary motivation for increasing
> memory slots is assigned devices.  With this, I've been able to
> assign 30 devices to a single VM and could have gone further, but
> ran out of SRIOV VFs.  Typical devices use anywhere from 2-4 slots
> and max out at 8 slots.  125 user slots (3 private slots) allows
> us to support between 28 and 56 typical devices per VM.
> 
> Tested on x86_64, compiled on ia64, powerpc, and s390.
> 
> Thanks,
> Alex

Reviewed-by: Marcelo Tosatti <mtosatti@redhat.com>

