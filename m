Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759428Ab0FJPfo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 11:35:44 -0400
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:39588 "HELO
	cpoproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759397Ab0FJPfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 11:35:42 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=aPgaI2xsqQdLHUWsgPctyEQfCsQ9Xz6R7gfzEEfqSzwc8SHQizo6IqxzLMMe7AWtZBl8wTjMGvIpE1bIPIUvf2/D3+6RR0hoOI9lf7ivQio1DBURM/urDXK3DnthyunJ;
Date: Thu, 10 Jun 2010 08:34:32 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: virtualization@lists.linux-foundation.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, Tejun Heo <tj@kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Anthony Liguori <aliguori@us.ibm.com>,
       Randy Dunlap <rdunlap@xenotime.net>,
       "David S. Miller" <davem@davemloft.net>,
       Matt Carlson <mcarlson@broadcom.com>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH for-2.6.35] virtio-pci: disable msi at startup
Message-ID: <20100610083432.3c23ad6a@virtuousgeek.org>
In-Reply-To: <20100610152252.GA3510@redhat.com>
References: <20100610152252.GA3510@redhat.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jun 2010 18:22:52 +0300
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> virtio-pci resets the device at startup by writing to the status
> register, but this does not clear the pci config space,
> specifically msi enable status which affects register
> layout.
> 
> This breaks things like kdump when they try to use e.g. virtio-blk.
> 
> Fix by forcing msi off at startup. Since pci.c already has
> a routine to do this, we export and use it instead of duplicating code.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> Tested-by: Vivek Goyal <vgoyal@redhat.com>
> Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
> Cc: linux-pci@vger.kernel.org
> ---

Yeah, looks fine.

Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>

-- 
Jesse Barnes, Intel Open Source Technology Center
