Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558Ab1FOCiS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 22:38:18 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:54404 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753508Ab1FOCiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 22:38:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=FoXCFSFdVuZ53Gealz53CGanFPpIXTzPgAnip7XU+RxJxs3IBihqPUVYbhgV8bfPVP
         hhLL8Cw7h0GIWclYyl7Wt/zeaZrXWKHCNq5n+SMff53ElygrCPXEWeH3MQFe+VnadY7+
         qs8LlY0EpKUhtCdDM2ZpaCAECjWwwqFaUVLOw=
Message-ID: <4DF81B12.2040800@gmail.com>
Date: Tue, 14 Jun 2011 22:38:10 -0400
From: Jay Estabrook <jay.estabrook@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20101002)
MIME-Version: 1.0
To: Dave Airlie <airlied@gmail.com>
CC: linux-alpha <linux-alpha@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Matt Turner <mattst88@gmail.com>, Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>, airlied@linux.ie
Subject: Re: [PATCH 3/3] alpha, drm: Add Alpha support to Radeon DRM code
References: <20110609182021.73726ea3.jay.estabrook_gmail.com@gmail.com> <BANLkTinvXFV1bObeaym6A4VEcxv0jN+zXQ@mail.gmail.com>
In-Reply-To: <BANLkTinvXFV1bObeaym6A4VEcxv0jN+zXQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Dave,

It is the explanation that is inaccurate; I was still thinking about mmap when
the new paradigm is to do the mapping when the VM faults.

I believe the code that requires this patch is: ttm/ttm_bo_vm.c: ttm_bo_vm_fault(),
specifically:

    for (i = 0; i < TTM_BO_VM_NUM_PREFAULT; ++i) {
        if (bo->mem.bus.is_iomem)
            pfn = ((bo->mem.bus.base + bo->mem.bus.offset) >> PAGE_SHIFT) + page_offset;
        else {

The "pfn" needs to reflect the correct system bus address to get to the VRAM
on the graphics card.

I will rework the commentary and resend.

Thanks for the feedback.

Jay


On 06/13/2011 07:35 PM, Dave Airlie wrote:
> On Fri, Jun 10, 2011 at 8:20 AM, Jay Estabrook <jay.estabrook@gmail.com> wrote:
>> Alpha needs to have the system bus address for the device's local
>> memory available, so that it can be returned to user-level, where
>> it may be used in an mmap(). So, we make bus.addr hold the ioremap()
>> return for kernel use, and then we can modify bus.base appropriately.
>>
> 
> I don't get this. why is mmap passing in an address? we don't do that anymore.
> 
> When you mmap the device node it passes back a hashed offset in the
> table, that the
> kernel then translates into a proper address and sets up the page tables.
> 
> So I really don't get what this patch is doing, either the
> explaination of what it is doing is wrong
> or it is wrong.
> 
> Dave.
