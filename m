Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755757Ab1FIUU3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 16:20:29 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:38095 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755102Ab1FIUUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 16:20:25 -0400
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzzz2dh2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Message-ID: <4DF12A94.6070605@freescale.com>
Date: Thu, 9 Jun 2011 15:18:28 -0500
From: Timur Tabi <timur@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.19) Gecko/20110429 Fedora/3.6.17-1.fc13 Firefox/3.6.17
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: <linuxppc-dev@lists.ozlabs.org>, <alan@lxorguk.ukuu.org.uk>,
        <kumar.gala@freescale.com>, <benh@kernel.crashing.org>,
        <greg@kroah.com>, <akpm@kernel.org>, <cmetcalf@tilera.com>,
        <konrad.wilk@oracle.com>, <linux-kernel@vger.kernel.org>,
        <linux-console@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH 7/7] [v5] drivers/virt: introduce Freescale hypervisor
 management driver
References: <1307646794-26374-1-git-send-email-timur@freescale.com> <201106092213.13755.arnd@arndb.de>
In-Reply-To: <201106092213.13755.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> As mentioned, it would be easier and more readable to just do
> 
> 	switch(cmd) {
> 	case FSL_HV_IOCTL_PARTITION_RESTART:
> 		...
> 
> 	case FSL_HV_IOCTL_PARTITION_GET_STATUS;
> 		...
> 
> There is no need to check the bits individually when you can simply
> compare the command number.

But this will break backwards compatibility with older applications that used
the union as the size parameter.  Although these applications won't compile with
the new header file, older already-compiled applications still work.

I will eventually update the applications to use the new header file, and at
that point I will modify the switch statement as you suggest.  But until then,
I'd like to keep the code as-is.

>> > +enum fsl_hv_ioctl_cmd {
>> > +       FSL_HV_IOCTL_PARTITION_RESTART = _IOWR(0, 1, struct fsl_hv_ioctl_restart),
>> > +       FSL_HV_IOCTL_PARTITION_GET_STATUS = _IOWR(0, 2, struct fsl_hv_ioctl_status),
>> > +       FSL_HV_IOCTL_PARTITION_START = _IOWR(0, 3, struct fsl_hv_ioctl_start),
>> > +       FSL_HV_IOCTL_PARTITION_STOP = _IOWR(0, 4, struct fsl_hv_ioctl_stop),
>> > +       FSL_HV_IOCTL_MEMCPY = _IOWR(0, 5, struct fsl_hv_ioctl_memcpy),
>> > +       FSL_HV_IOCTL_DOORBELL = _IOWR(0, 6, struct fsl_hv_ioctl_doorbell),
>> > +       FSL_HV_IOCTL_GETPROP = _IOWR(0, 7, struct fsl_hv_ioctl_prop),
>> > +       FSL_HV_IOCTL_SETPROP = _IOWR(0, 8, struct fsl_hv_ioctl_prop),
>> > +};

> Using a #define here is usually preferred because then you can use #ifdef in a user
> application to check if a given value has been assigned.

You're right -- I had enum on the brain.

> More importantly, the code you have chose (0) conflicts with existing drivers
> (frame buffer, scsi and wavefront among others). Please chose a free one and
> add it to Documentation/ioctl/ioctl-number.txt in the same patch.

Ok, I was really hoping to avoid doing this.  Like I said, binary compatibility
is important, and changing the type will break my existing apps.  Are you
insisting that I pick a new number?

-- 
Timur Tabi
Linux kernel developer at Freescale

