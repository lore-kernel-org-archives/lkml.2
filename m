Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030434Ab2HIOXy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 10:23:54 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:44058 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030279Ab2HIOXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 10:23:52 -0400
Date: Thu, 9 Aug 2012 07:23:46 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        airlied@redhat.com, m.szyprowski@samsung.com,
        kyungmin.park@samsung.com, laurent.pinchart@ideasonboard.com,
        sumit.semwal@linaro.org, inki.dae@samsung.com, daniel.vetter@ffwll.ch,
        rob@ti.com, pawel@osciak.com, linaro-mm-sig@lists.linaro.org,
        linux-kernel@vger.kernel.org, jy0922.shim@samsung.com,
        sw0312.kim@samsung.com, dan.j.williams@intel.com,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v2 1/2] dma-buf: add reference counting for exporter
 module
Message-ID: <20120809142346.GA17402@kroah.com>
References: <1344504982-30415-1-git-send-email-t.stanislaws@samsung.com>
 <1344504982-30415-2-git-send-email-t.stanislaws@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344504982-30415-2-git-send-email-t.stanislaws@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 09, 2012 at 11:36:21AM +0200, Tomasz Stanislawski wrote:
> This patch adds reference counting on a module that exported dma-buf and
> implements its operations. This prevents the module from being unloaded while
> DMABUF file is in use.

Why force all of the modules to be changed "by hand", and not just do
this automatically by changing the register function to include the
THIS_MODULE macro in it?  Much like the pci_register_driver() function
is implemented in include/linux/pci.h?

That makes it impossible for driver authors to get it wrong, which is
always a good sign of a correct api.

thanks,

greg k-h
