Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755173Ab2LFP2Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 10:28:16 -0500
Received: from smtp-outbound-2.vmware.com ([208.91.2.13]:50220 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755093Ab2LFP2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 10:28:13 -0500
Date: Thu, 6 Dec 2012 07:28:13 -0800 (PST)
From: Andy King <acking@vmware.com>
To: Anthony Liguori <aliguori@us.ibm.com>
Cc: pv-drivers@vmware.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, gregkh@linuxfoundation.org,
        David Miller <davem@davemloft.net>, georgezhang@vmware.com,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Gerd Hoffmann <kraxel@redhat.com>
Message-ID: <882468393.42962386.1354807693049.JavaMail.root@vmware.com>
In-Reply-To: <50A55F57.7080804@us.ibm.com>
Subject: Re: [Pv-drivers] [PATCH 0/6] VSOCK for Linux upstreaming
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.113.160.14]
X-Mailer: Zimbra 7.2.0_GA_2669 (ZimbraWebClient - GC23 (Mac)/7.2.0_GA_2669)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Anthony,

> This was already done in a hypervisor neutral way using virtio:
> 
> http://lists.openwall.net/netdev/2008/12/14/8
> 
> The concept was Nacked and that led to the abomination of
> virtio-serial.  If an address family for virtualization is on the
> table, we should reconsider AF_VMCHANNEL.

I finally had a look at your patch.  Please correct me if I'm wrong,
but it seems that the peer of an AF_VMCHANNEL connection is a virtio
channel inside the hypervisor, i.e., the other end is _not_ sockets,
right?

That's quite a bit different from vSockets, where both sides use the
socket interface, even within the VMX process in our hypervisor.  We
also intend for arbitrary host processes -- those outside the
hypervisor -- to use it via the sockets interface.  We have shipping
applications that do just that, where communication is between a guest
process and a host service, with both sides using the standard socket
API but with the vSockets address family.  We also encourage people to
write such VM-to-host applications, and we've been shipping the
vSockets header in our host-side products to allow people to do just
that.

So I think in that sense vSockets is somewhat more general, and we'd
obviously prefer to go with our socket family and address structure
if LKML is open to something like this.

Thanks!
- Andy

PS I realize we still owe LKML a spec for the vSockets protocol.
