Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756491Ab1FHXQU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 19:16:20 -0400
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:2998
	"EHLO AM1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753269Ab1FHXQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 19:16:18 -0400
X-SpamScore: -6
X-BigFish: VS-6(zz1432N98dKc8kzz1202hzzz2dh2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Message-ID: <4DF002BB.1020705@freescale.com>
Date: Wed, 8 Jun 2011 18:16:11 -0500
From: Timur Tabi <timur@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.19) Gecko/20110429 Fedora/3.6.17-1.fc13 Firefox/3.6.17
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: <alan@lxorguk.ukuu.org.uk>, <arnd@arndb.de>, <kumar.gala@freescale.com>,
        <benh@kernel.crashing.org>, <greg@kroah.com>, <akpm@kernel.org>,
        <cmetcalf@tilera.com>, <konrad.wilk@oracle.com>, <dsaxena@linaro.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <linux-console@vger.kernel.org>
Subject: Re: [PATCH 7/7] [v4] drivers/virt: introduce Freescale hypervisor
 management driver
References: <1307573154-15838-1-git-send-email-timur@freescale.com> <20110608161009.7b05d305.randy.dunlap@oracle.com>
In-Reply-To: <20110608161009.7b05d305.randy.dunlap@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
>> Add the drivers/virt directory, which houses drivers that support
>> > virtualization environments, and add the Freescale hypervisor management
>> > driver.

> It can't go in linux/virt or linux/virt/fsl instead?  why drivers/ ?
> 
> or maybe linux/virt should be drivers/virt ?

I knew this would happen.  The reason I put it in drivers/virt is because Arnd
told me to put it there.  At this point, I don't give a damn where it goes, but
I wish you all would come to a consensus.

>> > + * ALTERNATIVELY, this software may be distributed under the terms of the
>> > + * GNU General Public License ("GPL") as published by the Free Software
>> > + * Foundation, either version 2 of that License or (at your option) any
>> > + * later version.

> Why any later version?  I thought that <powers> decided that Linux
> is GPL v2.

Um, you do realize that this isn't the only file in the kernel that is
v2-or-later?  Try this command on the Linux source, and you'll see what I mean:

grep -r "\(at your option\)" *

I'm dual-licensing the header file because it's meant for applications as well
as the kernel.  That way, no one needs to worry whether #including the header
file in his application will taint the app with the GPL.

>> > +/**
>> > + * struct fsl_hv_ioctl_restart: restart a partition
> This syntax should be (for all structs here):
> 
>  * struct fsl_hv_ioctl_restart - restart a partition
> 
> but the struct fields/members do use ':' instead of '-'.
> 
> Darn, I checked Documentation/kernel-doc-nano-HOWTO.txt and it says
> that ':' is optional but '-' is needed, so you could use
> 
>  * struct fsl_hv_ioctl_restart: - restart a partition
> 

Ok, I'll change it.

>> > + * fsl_hv_event_register -- register a callback for failover events

> Documentation/kernel-doc-nano-HOWTO.txt says to use one '-' here, not 2.

Ok.  I'll review that document and make sure my comments conform.  I guess I
just wasn't paying attention at the time.

-- 
Timur Tabi
Linux kernel developer at Freescale

