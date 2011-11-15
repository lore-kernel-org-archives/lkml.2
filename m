Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751821Ab1KOFza (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 00:55:30 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63484 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472Ab1KOFz3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 00:55:29 -0500
MIME-Version: 1.0
In-Reply-To: <20111115045404.GC30247@sequoia.sous-sol.org>
References: <20111111224849.9756.13368.stgit@bling.home>
	<1321058267.2006.21.camel@shinybook.infradead.org>
	<CAL1RGDXZjKhA++3eFVPbazixaM7Q_JfBJyLKE0xjBs+sK55idg@mail.gmail.com>
	<20111112005100.GR14486@sequoia.sous-sol.org>
	<1321059340.2006.27.camel@shinybook.infradead.org>
	<20111112010850.GT14486@sequoia.sous-sol.org>
	<1321060841.2006.35.camel@shinybook.infradead.org>
	<4EC210CB.1010409@gmail.com>
	<20111115045404.GC30247@sequoia.sous-sol.org>
Date: Tue, 15 Nov 2011 13:55:27 +0800
Message-ID: <CANqQZNEvSBQgtR_ZDUWEDUVqscGFVuCtZYSzc+SRK4a_Vzjdhg@mail.gmail.com>
Subject: Re: [PATCH] intel-iommu: Default to non-coherent for domains
 unattached to iommus
From: Kai Huang <mail.kai.huang@gmail.com>
To: Chris Wright <chrisw@sous-sol.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
        Roland Dreier <roland@purestorage.com>, linux-pci@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 15, 2011 at 12:54 PM, Chris Wright <chrisw@sous-sol.org> wrote:
> * cody (mail.kai.huang@gmail.com) wrote:
>> On 11/11/2011 05:20 PM, David Woodhouse wrote:
>> >On Fri, 2011-11-11 at 17:08 -0800, Chris Wright wrote:
>> >>On a slightly separate, but performance related note...have you ever
>> >>tried using the hw queue?  Currently we only have a sw queue, but the
>> >>submission path for invalidations doesn't really queue (unless I missed
>> >>it).  It seems to pull from the software queue and submit/wait,
>> >>submit/wait...Seems simple enough to submit the whole queue and then
>> >>issue the wait.
>> >I have a feeling we trigger errata if we do that — although if we're
>> >only doing it for an emulated IOMMU that shouldn't be an issue.
>> >
>> What does the emulated IOMMU here? Does it mean the emulated IOMMU
>> exposed to guest VM?
>
> Yes.  So for KVM, the IOMMU emulation would be in QEMU.
>

What will emulated IOMMU be used for to the guest VM? To provide
another layer of address translation (in guest VM) that allows guest
VM to allocate large contiguous DVMA space for device? Does this mean
we need to keep something like *shadow page table* for the real IOMMU?

And this will be only used for direct IO, correct?

> thanks,
> -chris
>
