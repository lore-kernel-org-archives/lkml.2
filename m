Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030813Ab2HIOyt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 10:54:49 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:32146 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030553Ab2HIOyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 10:54:47 -0400
Message-id: <5023CF31.4010209@samsung.com>
Date: Thu, 09 Aug 2012 16:54:41 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714
 Thunderbird/14.0
MIME-version: 1.0
Newsgroups: gmane.linux.drivers.video-input-infrastructure,gmane.comp.video.dri.devel,gmane.linux.kernel,gmane.linux.documentation
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        airlied@redhat.com, m.szyprowski@samsung.com,
        kyungmin.park@samsung.com, laurent.pinchart@ideasonboard.com,
        sumit.semwal@linaro.org, inki.dae@samsung.com, daniel.vetter@ffwll.ch,
        rob@ti.com, pawel@osciak.com, linaro-mm-sig@lists.linaro.org,
        linux-kernel@vger.kernel.org, jy0922.shim@samsung.com,
        sw0312.kim@samsung.com, dan.j.williams@intel.com,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v2 1/2] dma-buf: add reference counting for exporter module
References: <1344504982-30415-1-git-send-email-t.stanislaws@samsung.com>
 <1344504982-30415-2-git-send-email-t.stanislaws@samsung.com>
 <20120809142346.GA17402@kroah.com>
In-reply-to: <20120809142346.GA17402@kroah.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On 08/09/2012 04:23 PM, Greg KH wrote:
> On Thu, Aug 09, 2012 at 11:36:21AM +0200, Tomasz Stanislawski wrote:
>> This patch adds reference counting on a module that exported dma-buf and
>> implements its operations. This prevents the module from being unloaded while
>> DMABUF file is in use.
> 
> Why force all of the modules to be changed "by hand", and not just do
> this automatically by changing the register function to include the
> THIS_MODULE macro in it?  Much like the pci_register_driver() function
> is implemented in include/linux/pci.h?

Thank you for the hint.

The owner field belongs to dma_buf_ops structure that is often a 'const'
entity. Therefore owner field would have to be moved to 'struct dma_buf'
to avoid 'deconstification' issues.

Regards,
Tomasz Stanislawski

> 
> That makes it impossible for driver authors to get it wrong, which is
> always a good sign of a correct api.
> 
> thanks,
> 
> greg k-h
> 

