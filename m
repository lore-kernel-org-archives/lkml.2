Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273Ab0ECRrx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 13:47:53 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:20052 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754166Ab0ECRrv (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 3 May 2010 13:47:51 -0400
Date: Mon, 3 May 2010 13:47:00 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Tom Lyon <pugs@lyon-about.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, hjk@linutronix.de, gregkh@suse.de,
       chrisw@sous-sol.org, joro@8bytes.org, avi@redhat.com,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [LKML] Re: [PATCH V3] drivers/uio/uio_pci_generic.c: allow
	access for non-privileged processes
Message-ID: <20100503174700.GC24574@phenom.dumpdata.com>
References: <4bccd3af.M/eSrn9OV22zg0A8%pugs@cisco.com> <20100421093849.GB30855@redhat.com> <201004291229.40918.pugs@lyon-about.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201004291229.40918.pugs@lyon-about.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090204.4BDF0C2D.012D:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 29, 2010 at 12:29:40PM -0700, Tom Lyon wrote:
> Michael, et al - sorry for the delay, but I've been digesting the comments and researching new approaches.
> 
> I think the plan for V4 will be to take things entirely out of the UIO framework, and instead have a driver which supports user mode use of "well-behaved" PCI devices. I would like to use read and write to support access to memory regions, IO regions,  or PCI config space. Config space is a bitch because not everything is safe to read or write, but I've come up with a table driven approach which can be run-time extended for non-compliant devices (under root control) which could then enable non-privileged users. For instance, OHCI 1394 devices use a dword in config space which is not formatted as a PCI capability, root can use sysfs to enable access:
> 	echo <offset> <readbits> <writebits> > /sys/dev/pci/devices/xxxx:xx:xx.x/<yyy>/config_permit
> 
> 
> A "well-behaved" PCI device must have memory BARs >= 4K for mmaping, must have separate memory space for MSI-X that does not need mmaping
> by the user driver, must support the PCI 2.3 interrupt masking, and must not go totally crazy with PCI config space (tg3 is real ugly, e1000 is fine).

How about page aligned BARs?
