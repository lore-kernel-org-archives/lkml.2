Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753638Ab2BEJh3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 04:37:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33079 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751799Ab2BEJh1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 04:37:27 -0500
Date: Sun, 5 Feb 2012 11:37:23 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: KVM list <kvm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>
Subject: Re: [RFC] Next gen kvm api
Message-ID: <20120205093723.GQ23536@redhat.com>
References: <4F2AB552.2070909@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F2AB552.2070909@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 02, 2012 at 06:09:54PM +0200, Avi Kivity wrote:
> Device model
> ------------
> Currently kvm virtualizes or emulates a set of x86 cores, with or
> without local APICs, a 24-input IOAPIC, a PIC, a PIT, and a number of
> PCI devices assigned from the host.  The API allows emulating the local
> APICs in userspace.
> 
> The new API will do away with the IOAPIC/PIC/PIT emulation and defer
> them to userspace.  Note: this may cause a regression for older guests
> that don't support MSI or kvmclock.  Device assignment will be done
> using VFIO, that is, without direct kvm involvement.
> 
So are we officially saying that KVM is only for modern guest
virtualization? Also my not so old host kernel uses MSI only for NIC.
SATA and USB are using IOAPIC (though this is probably more HW related
than kernel version related).

--
			Gleb.
