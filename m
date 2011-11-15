Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830Ab1KNPMA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 10:12:00 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34479 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632Ab1KNPL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 10:11:58 -0500
Message-ID: <4EC210CB.1010409@gmail.com>
Date: Mon, 14 Nov 2011 23:12:11 -0800
From: cody <mail.kai.huang@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.16) Gecko/20110818 Icedove/3.0.11
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: Chris Wright <chrisw@sous-sol.org>, Roland Dreier <roland@purestorage.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, ddutile@redhat.com
Subject: Re: [PATCH] intel-iommu: Default to non-coherent for domains unattached
 to iommus
References: <20111111224849.9756.13368.stgit@bling.home>	 <1321058267.2006.21.camel@shinybook.infradead.org>	 <CAL1RGDXZjKhA++3eFVPbazixaM7Q_JfBJyLKE0xjBs+sK55idg@mail.gmail.com>	 <20111112005100.GR14486@sequoia.sous-sol.org>	 <1321059340.2006.27.camel@shinybook.infradead.org>	 <20111112010850.GT14486@sequoia.sous-sol.org> <1321060841.2006.35.camel@shinybook.infradead.org>
In-Reply-To: <1321060841.2006.35.camel@shinybook.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2011 05:20 PM, David Woodhouse wrote:
> On Fri, 2011-11-11 at 17:08 -0800, Chris Wright wrote:
>    
>> All the stale PTE issues I've encountered in the past have turned into
>> fixed sw bugs (perhaps it's since been fixed?).  Also, I thought with
>> Coherency On/Off it's only effecting the use of clflush, not IOTLB or
>> Context Entry cache flushing (invalidations).
>>      
> Yeah, it's supposed to be *just* clflush. Nevertheless, I can imagine it
> being screwed up and there actually being a buffer in the chipset too.
> We certainly made that mistake with the graphics engine in some cases...
>
>    
>> On a slightly separate, but performance related note...have you ever
>> tried using the hw queue?  Currently we only have a sw queue, but the
>> submission path for invalidations doesn't really queue (unless I missed
>> it).  It seems to pull from the software queue and submit/wait,
>> submit/wait...Seems simple enough to submit the whole queue and then
>> issue the wait.
>>      
> I have a feeling we trigger errata if we do that — although if we're
> only doing it for an emulated IOMMU that shouldn't be an issue.
>
>    
What does the emulated IOMMU here? Does it mean the emulated IOMMU 
exposed to guest VM?

