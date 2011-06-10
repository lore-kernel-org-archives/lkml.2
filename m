Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752346Ab1FJIdw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 04:33:52 -0400
Received: from mx0.aculab.com ([213.249.233.131]:46646 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751149Ab1FJIdv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 04:33:51 -0400
x-mimeole: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 7/7] [v5] drivers/virt: introduce Freescale hypervisormanagement driver
Date: Fri, 10 Jun 2011 09:32:08 +0100
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6D8AD8B@saturn3.aculab.com>
In-Reply-To: <201106092213.13755.arnd@arndb.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
thread-topic: [PATCH 7/7] [v5] drivers/virt: introduce Freescale hypervisormanagement driver
thread-index: Acwm4asbZL6B64HdSw2YtZGiU+pw6gAZg5Tw
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Arnd Bergmann" <arnd@arndb.de>, "Timur Tabi" <timur@freescale.com>,
        <linuxppc-dev@lists.ozlabs.org>
Cc: <konrad.wilk@oracle.com>, <kumar.gala@freescale.com>,
        <linux-kernel@vger.kernel.org>, <cmetcalf@tilera.com>,
        <akpm@kernel.org>, <linux-console@vger.kernel.org>, <greg@kroah.com>,
        <virtualization@lists.linux-foundation.org>,
        <alan@lxorguk.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
> > +enum fsl_hv_ioctl_cmd {
> > +       FSL_HV_IOCTL_PARTITION_RESTART = _IOWR(0, 1, struct
fsl_hv_ioctl_restart),
...
> > +};
> 
> Using a #define here is usually preferred because then you 
> can use #ifdef in a user application to check if a given
> value has been assigned.

It is also possible to add:
#define FSL_HV_IOCTL_PARTITION_RESTART FSL_HV_IOCTL_PARTITION_RESTART
to have much the same effect.
But there are many cases where #defines are better.
I only tend to use enums when the constanst are beting generated
by the expansion of a #define.

> More importantly, the code you have chose (0) conflicts with 
> existing drivers (frame buffer, scsi and wavefront among others).
> Please chose a free one and
> add it to Documentation/ioctl/ioctl-number.txt in the same patch.

It is rather a PITA that, when 'int' went from 16 to 32 bits, the
BSD people used the high 16 bits for size/flags rather than
using the extra bits to help make ioctl's unique.
Linux seems to have copied BSD here - rather than SYSV.

One problem with clashing ioctl commands is when systems like
NetBSD are running linux binaries and need to translate ioctl
buffers to/from native format. If the ioctl commands are
unique this can be done much more easily.

	David


