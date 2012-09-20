Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755115Ab2ITM24 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 08:28:56 -0400
Received: from service87.mimecast.com ([91.220.42.44]:53890 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754664Ab2ITM2y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 08:28:54 -0400
Message-ID: <505B0C00.5010003@arm.com>
Date: Thu, 20 Sep 2012 13:28:48 +0100
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: Pawel Moll <Pawel.Moll@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] arm: introduce a DTS for Xen unprivileged virtual machines
References: <1348076658-4511-1-git-send-email-stefano.stabellini@eu.citrix.com>  <1348135563.11116.94.camel@hornet>  <alpine.DEB.2.02.1209201235450.29232@kaball.uk.xensource.com> <1348142133.11116.109.camel@hornet> <alpine.DEB.2.02.1209201308490.29232@kaball.uk.xensource.com>
In-Reply-To: <alpine.DEB.2.02.1209201308490.29232@kaball.uk.xensource.com>
X-Enigmail-Version: 1.5a1pre
X-OriginalArrivalTime: 20 Sep 2012 12:28:49.0423 (UTC) FILETIME=[7CA5A1F0:01CD972B]
X-MC-Unique: 112092013285202501
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/09/12 13:15, Stefano Stabellini wrote:
> On Thu, 20 Sep 2012, Pawel Moll wrote:
>> On Thu, 2012-09-20 at 12:39 +0100, Stefano Stabellini wrote:
>>> There are no peripherals apart from the ones that are already described
>>> here (timer, gic). All the peripherals that the guest sees are virtual
>>> devices that show up on xenbus (a virtual bus). In order to initialize
>>> xenbus, the guest only needs the hypervisor node.  So I'll remove the
>>> ranges and interrupt-map.
>>
>> So all the peripherals are actually discoverable - awesome!
>>
>> But the fact is that the only "vexpressness" of this tree is
>> memory@80000000 and gic@2c001000. The rest (not much of it ;-) is a
>> "generic A15 platform". 
>>
>> I understand that you had to use some "compatible" value to get
>> initialization code and I'm flattered ;-) by your choice of
>> "arm,vexpress", but maybe - as suggested by others - you would be better
>> off with generating this stuff in runtime, by whatever tool is used to
>> instantiate the guest?
> 
> Yes, it is certainly going to be generated at run time. Does it make
> sense to keep an example under arch/arm/boot/dts? I think so. There must
> be other platforms that actually pass the device tree to the kernel from
> the firmware and still have a dts in the kernel tree, right?
> If actually there are none, it is probably best to forget about this
> patch :)
> 
> Regarding the choice of "arm,vexpress", there was a discussion at kernel
> summit about vexpress being the right choice as a base platform for
> virtual machines on ARM, even though in the Xen case it means having a
> vexpress with no peripherals.

I think the important thing here is that the memory map is RS1. As this
is a (very limited) subset of a vexpress A15, it seems to make some sense.

I still think it is useful at have an example of such a platform in the
tree, if only as a very minimal example.

	M.
-- 
Jazz is not dead. It just smells funny...

