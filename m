Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758821Ab1D2OUA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 10:20:00 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:33528 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752742Ab1D2OT7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 10:19:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=kur0bvRybUDhdz7ish3UvTqza/268yS2m2LaMgt5RuUClFzWLVdKnpCm2Bv798CxYf
         Pekvucam03O2oKvUUG4qBIDZbEFRNv9Q4zIMq5vZJdsPSFa3fQs4n3ZRZlhkY4vhczIS
         0SPKzyJiqdk22XM0jyMljeeunXfW5UFKHVWqk=
MIME-Version: 1.0
In-Reply-To: <20110429134231.GI13402@8bytes.org>
References: <201104212129.17013.arnd@arndb.de>
	<201104281428.56780.arnd@arndb.de>
	<20110428131531.GK17290@n2100.arm.linux.org.uk>
	<201104281629.52863.arnd@arndb.de>
	<20110428143440.GP17290@n2100.arm.linux.org.uk>
	<BANLkTinhm7ar1mf1D-dSMiLtw5hRNY36RA@mail.gmail.com>
	<20110429134231.GI13402@8bytes.org>
Date: Fri, 29 Apr 2011 10:19:58 -0400
Message-ID: <BANLkTi=EQMuuGzDgKF3i-jukDh31gzn_JA@mail.gmail.com>
Subject: Re: [Linaro-mm-sig] [RFC] ARM DMA mapping TODO, v1
From: Jerome Glisse <j.glisse@gmail.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, linaro-mm-sig@lists.linaro.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 29, 2011 at 9:42 AM, Joerg Roedel <joro@8bytes.org> wrote:
> On Thu, Apr 28, 2011 at 03:37:00PM -0400, Jerome Glisse wrote:
>> As Jesse pointed out already, for performance reasons it's lot better
>> if you let the driver decide even if you have an iommu capable of
>> handling coherency for you. My understanding is that each time
>> coherency is asked for it trigger bus activities of some kind (i think
>> snoop is the term used for pci) this traffic can slow down both the
>> cpu and the device. For graphic driver we have a lot of write once and
>> use (once or more) buffer and it makes a lot of sense to have those
>> buffer allocated using uncached memory so we can tell the device (in
>> case of drm driver) that there is no need to trigger snoop activities
>> for coherency. So i believe the decision should ultimately be in the
>> driver side.
>
> Stupid question: Couldn't these write-once-read-often buffers just stay
> in the memory of the GPU instead of refetching them every time from main
> memory? Or is that necessary because of the limited space on some GPUs?
>
> Regards,
>
>        Joerg
>

We might be talking about several G of data, so using system is not
uncommon. Also when uploading data to GPU vram is better to let the
GPU do dma from system memory rather than having the CPU do memcpy.

Cheers,
Jerome
