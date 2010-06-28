Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312Ab0F1PgI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 11:36:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3120 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755168Ab0F1PgE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 11:36:04 -0400
Date: Mon, 28 Jun 2010 18:30:28 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: kvm@vger.kernel.org, virtualization@lists.osdl.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, ykaul@redhat.com, markmc@redhat.com
Subject: Re: [PATCHv2] vhost-net: add dhclient work-around from userspace
Message-ID: <20100628153028.GA1452@redhat.com>
References: <20100628100807.GA30685@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100628100807.GA30685@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 28, 2010 at 01:08:07PM +0300, Michael S. Tsirkin wrote:
> Userspace virtio server has the following hack
> so guests rely on it, and we have to replicate it, too:
> 
> Use port number to detect incoming IPv4 DHCP response packets,
> and fill in the checksum for these.
> 
> The issue we are solving is that on linux guests, some apps
> that use recvmsg with AF_PACKET sockets, don't know how to
> handle CHECKSUM_PARTIAL;
> The interface to return the relevant information was added
> in 8dc4194474159660d7f37c495e3fc3f10d0db8cc,
> and older userspace does not use it.
> One important user of recvmsg with AF_PACKET is dhclient,
> so we add a work-around just for DHCP.
> 
> Don't bother applying the hack to IPv6 as userspace virtio does not
> have a work-around for that - let's hope guests will do the right
> thing wrt IPv6.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

Tested-by: Laine Stump <laine@redhat.com>

