Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759154Ab2FCMGx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 08:06:53 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:48642 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753754Ab2FCMGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 08:06:51 -0400
Message-ID: <4FCB5322.3050707@linux.vnet.ibm.com>
Date: Sun, 03 Jun 2012 17:35:54 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120424 Thunderbird/12.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Yong Zhang <yong.zhang0@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tony Luck <tony.luck@intel.com>, Ralf Baechle <ralf@linux-mips.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mundt <lethal@linux-sh.org>, Chris Metcalf <cmetcalf@tilera.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Mike Frysinger <vapier@gentoo.org>,
        Hirokazu Takata <takata@linux-m32r.org>,
        Richard Kuo <rkuo@codeaurora.org>, David Howells <dhowells@redhat.com>,
        Bob Liu <lliubbo@gmail.com>, "David S. Miller" <davem@davemloft.net>,
        Richard Weinberger <richard@nod.at>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Matt Turner <mattst88@gmail.com>, nikunj@linux.vnet.ibm.com
Subject: Re: [PATCH 01/27] smpboot: Provide a generic method to boot	secondary
 processors
References: <20120601090952.31979.24799.stgit@srivatsabhat.in.ibm.com> <20120601091008.31979.93586.stgit@srivatsabhat.in.ibm.com> <4FC8B0F7.3060705@linux.vnet.ibm.com> <20120603085359.GE16829@zhy> <4FCB4B9E.3090508@linux.vnet.ibm.com> <20120603113948.GC15354@n2100.arm.linux.org.uk>
In-Reply-To: <20120603113948.GC15354@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12060312-4790-0000-0000-0000030FA88D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/2012 05:09 PM, Russell King - ARM Linux wrote:

> On Sun, Jun 03, 2012 at 05:03:50PM +0530, Srivatsa S. Bhat wrote:
>> That's a good point! But unfortunately we can't do that just yet.
>> Because, some architectures have explicit comments that say that
>> irqs must be enabled at a certain point in time, or have something
>> special than just a local_irq_enable(), and hence fall under the
>> __cpu_post_online() function when converted to this model.
>>
>> Examples: ARM (patch 26) and ia64 (patch 15)
>>
>> Unless the maintainers give a go-ahead to change them, I don't
>> think it would be safe.. (I have added the Notes section to each
>> patch to get the attention of the maintainers to such issues).
> 
> I have no intention of touching ARMs SMP bringup any more than is
> absolutely necessary - this code is extremely fragile, and it's taken
> a long time to get it to where it presently is, where most people are
> happy with it.
> 

> Especially problematical is stuff like where we enable interrupts in

> relation to other activities.
> 
> It's probably best to describe the code not as "mostly bug free" but
> as "causes the least pain" because I don't think there is a solution
> which satisfies all the constraints placed upon this code path by
> the various parts of the kernel.
> 


Thanks for your comments Russell. I understand your concerns. So, the
ARM patch does no functional change and retains how and where the
interrupts are enabled. And from looking at what you said above about
the bringup being fragile, I think even in future you wouldn't want any
functional changes to ARM just to make it fit into some generic model.
Thanks for the clarification.

However, what are your thoughts on the existing ARM patch (patch 26)
(which doesn't cause any functional changes)? That shouldn't pose any
problems right?

Regards,
Srivatsa S. Bhat

