Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932920Ab0FCGXx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 02:23:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2780 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932340Ab0FCGXv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 02:23:51 -0400
Message-ID: <4C074A64.1000009@redhat.com>
Date: Thu, 03 Jun 2010 09:23:32 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Chris Wright <chrisw@sous-sol.org>
CC: Joerg Roedel <joro@8bytes.org>, "Michael S. Tsirkin" <mst@redhat.com>,
       Tom Lyon <pugs@cisco.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, hjk@linutronix.de, gregkh@suse.de,
       aafabbri@cisco.com, scofeldm@cisco.com
Subject: Re: [PATCH] VFIO driver: Non-privileged user level PCI drivers
References: <20100601095532.GA9178@redhat.com> <20100602094201.GC964@8bytes.org> <20100602095312.GA25335@redhat.com> <20100602101940.GG964@8bytes.org> <20100602102144.GD29023@redhat.com> <20100602103516.GI964@8bytes.org> <20100602103828.GF29023@redhat.com> <20100602111224.GA11033@8bytes.org> <20100602112100.GA29697@redhat.com> <20100602121927.GA11162@8bytes.org> <20100602174615.GV8301@sequoia.sous-sol.org>
In-Reply-To: <20100602174615.GV8301@sequoia.sous-sol.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/02/2010 08:46 PM, Chris Wright wrote:
> The BIND API expects a new
> iommu object.  Are there other uses for this object?

Both kvm and vhost use similar memory maps, so they could use the new 
object (without invoking the iommu unless they want dma).

> Tom's current vfio
> driver exposes a dma mapping interface, would the iommu object expose
> one as well?  Current interface is device specific DMA interface for
> host device drivers typically mapping in-flight dma buffers, and IOMMU
> specific interface for assigned devices typically mapping entire virtual
> address space.
>    

A per-request mapping sounds like a device API since it would only 
affect that device (whereas the address space API affects multiple devices).

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

