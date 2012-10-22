Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755615Ab2JVRAI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 13:00:08 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:34362 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755416Ab2JVRAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 13:00:05 -0400
MIME-Version: 1.0
In-Reply-To: <20121022164444.2b0775ce@pyramind.ukuu.org.uk>
References: <50819140.8030806@linux.vnet.ibm.com> <508565FA.4040908@redhat.com>
 <20121022164444.2b0775ce@pyramind.ukuu.org.uk>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 22 Oct 2012 10:59:44 -0600
Message-ID: <CAErSpo7-BEiBWBYNdEdx_UhqYaMkqvaMck5uYCivVDVYX+qPuQ@mail.gmail.com>
Subject: Re: radeon: RFC speed cap detection on ppc64
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Adam Jackson <ajax@redhat.com>,
        Lucas Kannebley Tavares <lucaskt@linux.vnet.ibm.com>,
        dri-devel@lists.freedesktop.org,
        Benjamin Herrenschmidt <benh@au1.ibm.com>, linux-pci@vger.kernel.org,
        Nishanth Aravamudan <nacc@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, Brian King <brking@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2012 at 9:44 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> That (walking all parent nodes) is probably the safest thing to do.  I'm
>> not sure whether it's optimal.  It would likely depend on whether you
>> can meaningfully have a bridge that's faster on the downstream side than
>> on the upstream.
>
> This is architecture goo at heart - would this be better as a helper in
> the PCI and arch PCI code ?

Good point.

POWER is not the only architecture where host bridges do not appear as
devices in PCI config space -- ia64 has that, too.  So the comment is
too specific.

The link is a point-to-point thing, so this should be a local
negotiation between the radeon device and the upstream bridge.  I
don't see the point of walking any farther up the chain.

drm_pcie_get_speed_cap_mask() should also be changed to use
pcie_capability_read_dword() to avoid any issues with v1/v2 PCI
Express Capability structures.

Bjorn
