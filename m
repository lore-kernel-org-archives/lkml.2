Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932483Ab1C3NR5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 09:17:57 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:15551
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754409Ab1C3NR4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 09:17:56 -0400
X-SpamScore: -39
X-BigFish: VPS-39(zz542N1432N98dN4015L1fa4L148cM9371Pzz1202hzz8275bhz2dh95h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH V5 3/4] ARM: Xilinx: base header files and assembly macros
Date: Wed, 30 Mar 2011 07:17:46 -0600
In-Reply-To: <201103301344.45307.arnd@arndb.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH V5 3/4] ARM: Xilinx: base header files and assembly macros
Thread-Index: Acvuz+7X8EIYfzPxS9qy553cJc6oFAAC+Ajw
References: <1301444651-18008-1-git-send-email-john.linn@xilinx.com> <1301444651-18008-3-git-send-email-john.linn@xilinx.com> <9ceff117-ad43-4513-bee0-153a93c379ce@VA3EHSMHS008.ehs.local> <201103301344.45307.arnd@arndb.de>
From: John Linn <John.Linn@xilinx.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux@arm.linux.org.uk>, <catalin.marinas@arm.com>,
        <glikely@secretlab.ca>, <jamie@jamieiles.com>
X-OriginalArrivalTime: 30 Mar 2011 13:17:47.0088 (UTC) FILETIME=[DC90BD00:01CBEEDC]
X-RCIS-Action: ALLOW
Message-ID: <f4872ed7-b6e4-4050-9445-5176f5aa961a@VA3EHSMHS017.ehs.local>
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Arnd Bergmann [mailto:arnd@arndb.de]
> Sent: Wednesday, March 30, 2011 5:45 AM
> To: John Linn
> Cc: linux-arm-kernel@lists.infradead.org;
linux-kernel@vger.kernel.org;
> linux@arm.linux.org.uk; catalin.marinas@arm.com; glikely@secretlab.ca;
> jamie@jamieiles.com
> Subject: Re: [PATCH V5 3/4] ARM: Xilinx: base header files and
assembly
> macros
> 
> Hi John,
> 
> I looked over the latest version of your patches, everything looks
> good to me, but I found one problem that you have probably copied
> from other platforms:

Hi Arnd,

Thanks for taking the time to review again. Yep I did copy from others.

> 
> On Wednesday 30 March 2011, John Linn wrote:
> > +
> > +/* Allow IO space to be anywhere in the memory */
> > +
> > +#define IO_SPACE_LIMIT 0xffff
> > +
> > +/* IO address mapping macros, nothing special at this time but
> required */
> > +
> > +#ifdef __ASSEMBLER__
> > +#define IOMEM(x)               (x)
> > +#else
> > +#define IOMEM(x)               ((void __force __iomem *)(x))
> > +#endif
> > +
> > +#define __io(a)                        __typesafe_io(a)
> > +#define __mem_pci(a)           (a)
> 
> The definition of __io() looks wrong, so any call to inb()/outb()
> will be a wild pointer access when you add PCI support.

Yes that makes sense.  We don't have immediate plans for PCI and 
I was assuming when we add PCI we would need to change that.  

If you think I shouldn't put it off then I'll fix it now.  My 
preference was to get the platform supported, then add more features.

Thanks,
John

> 
> If you don't plan to support PCI in the future, there should
> be no problem.
> 
> 	Arnd


This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.


