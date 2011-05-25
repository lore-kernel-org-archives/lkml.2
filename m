Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751420Ab1EYEKl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 00:10:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43362 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750796Ab1EYEKj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 00:10:39 -0400
Subject: Re: [PATCH] vfio: Allow sub-ranges to be unmapped
From: Alex Williamson <alex.williamson@redhat.com>
To: pugs@ieee.org
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        qemu-devel@nongnu.org
In-Reply-To: <20110510172903.9289.99964.stgit@s20.home>
References: <20110510172903.9289.99964.stgit@s20.home>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 May 2011 22:10:31 -0600
Message-ID: <1306296631.3100.115.camel@x201>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-10 at 12:06 -0600, Alex Williamson wrote:
> We're currently very strict in requiring that DMA unmaps are done
> using the exact same regions as used for the original mapping.
> In a VM environment, we may want to change sub-areas of a previous
> mapping without tearing down the entire region.  This might also
> also us to support ballooning or memory hotplug in a guest making
> use of a vfio device.
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
> 
> Tom,
> 
> I'm a little confused why we have the list of mapped areas attached
> to the listener.  If we want to support multiple devices sharing the same
> uiommu, don't we instead need to create a separate object hosting this
> list with reference counting so multiple vdevs can point to it?  I would
> expect that's where the locked_page accounting would be moved to as well.
> There also seems to be support that each vdev could have multiple
> listeners, each with their own list of dma mapped areas, but we can
> only have one udomain per vdev, which just further confuses me.  Can you
> hlp me out?  Thanks,
> 
> Alex
> 
> Note the change of npage to unsigned long below is just to avoid needing
> to cast it every time we do a << PAGE_SHIFT to avoid overflow.

Self NAK on this last change, it breaks locked page accounting since we
rely on a sign bit there.  I'll try just using a macro instead to avoid
excessive casting.  The follow-up uiommu sharing patch is dependent on
this, so I'll respin both.  Thanks,

Alex

