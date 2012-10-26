Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287Ab2JZJWf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 05:22:35 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:56326 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752788Ab2JZJWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 05:22:30 -0400
MIME-Version: 1.0
In-Reply-To: <CADCVGbTQTH05TtoGUm-oNYnM8NR9OKr0GVgK0sETnW6H29b+6A@mail.gmail.com>
References: <CADCVGbTDD-4WOVJWwaGBvay5=of=3VKBCVacrrW-z12BYZ1xbQ@mail.gmail.com>
 <CAErSpo7mcDkWUhUBvnZ6P+5TOYsE=j6zB7MHqfY1wvqyyE1CBQ@mail.gmail.com> <CADCVGbTQTH05TtoGUm-oNYnM8NR9OKr0GVgK0sETnW6H29b+6A@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 26 Oct 2012 03:22:08 -0600
Message-ID: <CAErSpo5QG4O_ENko8AFazq9WCf9vkX9_JzrKUdhCWnOPJhaSBA@mail.gmail.com>
Subject: Re: PCIe IO space support on Tilera GX: Is there any one who can
 confirm my modification to fix it is OK?
To: Cyberman Wu <cypher.w@gmail.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Metcalf <cmetcalf@tilera.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2012 at 3:01 AM, Cyberman Wu <cypher.w@gmail.com> wrote:
> We're not using 3.6.x, we're using is from MDE-4.1.0 from Tilera and
> it patch 3.0.38.

That's fine, but you sent the email to the linux-pci and linux-kernel
lists, and on those lists, we're only concerned with the upstream
Linux kernels, e.g., 3.6.  If you need support for MDE-4.1.0, you need
to talk to whoever supplies that, because we have no idea what it is.

> For mvsas, it seems do think 0 I/O address invalied.

That's a driver bug.  Zero is a perfectly valid I/O address.  On many
systems it's not usable because of platform restrictions, but the
driver has no way to know about those restrictions, and the driver
should still work on the platforms where zero *is* usable.

> When we using MDE-4.0.0 it don't support I/O space, I just bypass
> these check since after
> investigate all code of mvsas it seems that I/O space map to BAR 2 is
> not really used.

If the driver doesn't need I/O space, it'd be a lot simpler to just
change it to use pci_enable_device_mem(), which indicates that we
don't need to enable I/O BARs, and strip out the code that checks
whether the I/O BARs are valid.  Then you wouldn't need to mess with
adding I/O space support in your platform.

Bjorn
