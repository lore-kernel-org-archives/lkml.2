Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932145Ab0FHVqd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 17:46:33 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:25638 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754528Ab0FHVqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 17:46:32 -0400
Date: Tue, 8 Jun 2010 14:45:34 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Tom Lyon" <pugs@cisco.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, chrisw@sous-sol.org,
       joro@8bytes.org, hjk@linutronix.de, mst@redhat.com, avi@redhat.com,
       gregkh@suse.de, aafabbri@cisco.com, scofeldm@cisco.com
Subject: Re: [PATCH V2] VFIO driver: Non-privileged user level PCI drivers
Message-Id: <20100608144534.bb228916.randy.dunlap@oracle.com>
In-Reply-To: <4c0eb470.1HMjondO00NIvFM6%pugs@cisco.com>
References: <4c0eb470.1HMjondO00NIvFM6%pugs@cisco.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090209.4C0EBA22.0056:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 08 Jun 2010 14:21:52 -0700 Tom Lyon wrote:

> diff -uprN linux-2.6.34/Documentation/vfio.txt vfio-linux-2.6.34/Documentation/vfio.txt
> --- linux-2.6.34/Documentation/vfio.txt	1969-12-31 16:00:00.000000000 -0800
> +++ vfio-linux-2.6.34/Documentation/vfio.txt	2010-06-07 15:05:42.000000000 -0700
> @@ -0,0 +1,177 @@

...

> +Interrupts:
> +
> +Device interrupts are translated by the vfio driver into input events on event
> +notification file descriptors created by the eventfd system call. The user
> +program must create one or more event descriptors and pass them to the vfio
> +driver via ioctls to arrange for the interrupt mapping:
> +1.
> +	efd = eventfd(0, 0);
> +	ioctl(vfio_fd, VFIO_EVENTFD_IRQ, &efd);
> +		This provides an eventfd for traditional IRQ interrupts.
> +		IRQs will be disable after each interrupt until the driver

		             disabled

> +		re-enables them via the PCI COMMAND register.
> +2.
> +	efd = eventfd(0, 0);
> +	ioctl(vfio_fd, VFIO_EVENTFD_MSI, &efd);
> +		This connects MSI interrupts to an eventfd.
> +3.
> + 	int arg[N+1];
> +	arg[0] = N;
> +	arg[1..N] = eventfd(0, 0);
> +	ioctl(vfio_fd, VFIO_EVENTFDS_MSIX, arg);
> +		This connects N MSI-X interrupts with N eventfds.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
