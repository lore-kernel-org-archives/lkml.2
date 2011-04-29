Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759455Ab1D2Phr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 11:37:47 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:23675 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759281Ab1D2Php (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 11:37:45 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6330"; a="88597185"
Message-ID: <4DBADB3B.4040402@codeaurora.org>
Date: Fri, 29 Apr 2011 09:37:31 -0600
From: Jordan Crouse <jcrouse@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: Jerome Glisse <j.glisse@gmail.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [Linaro-mm-sig] [RFC] ARM DMA mapping TODO, v1
References: <201104212129.17013.arnd@arndb.de>	<201104281428.56780.arnd@arndb.de>	<20110428131531.GK17290@n2100.arm.linux.org.uk>	<201104281629.52863.arnd@arndb.de>	<20110428143440.GP17290@n2100.arm.linux.org.uk>	<BANLkTinhm7ar1mf1D-dSMiLtw5hRNY36RA@mail.gmail.com> <20110429134231.GI13402@8bytes.org>
In-Reply-To: <20110429134231.GI13402@8bytes.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29/2011 07:42 AM, Joerg Roedel wrote:
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

Not all embedded GPUs have their own dedicated memory.  On the MSM architecture
the devices and the CPU share the same physical pool.

Jordan
