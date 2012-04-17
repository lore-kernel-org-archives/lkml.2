Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753000Ab2DQUQL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 16:16:11 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48956 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751542Ab2DQUQK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 16:16:10 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: huang ying <huang.ying.caritas@gmail.com>
Subject: Re: [RFC PATCH] PCIe: Add PCIe runtime D3cold support
Date: Tue, 17 Apr 2012 22:20:45 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>, bhelgaas@google.com,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-pm@vger.kernel.org, Lin Ming <ming.m.lin@intel.com>,
        Zhang Rui <rui.zhang@intel.com>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>
References: <4F8790F6.5080408@intel.com> <201204161907.13806.rjw@sisk.pl> <CAC=cRTNdLu=A64YAEp78ENc1h2OJKusXY3Wm9LuY4drz9pbomg@mail.gmail.com>
In-Reply-To: <CAC=cRTNdLu=A64YAEp78ENc1h2OJKusXY3Wm9LuY4drz9pbomg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201204172220.45970.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, April 17, 2012, huang ying wrote:
> On Tue, Apr 17, 2012 at 1:07 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > Moreover, I really don't think it's a good idea to put PCI Express ports into
> > low-power states in general.  It might work on your platform, whatever it is,
> > but that doesn't mean it's going to work on every PCI Express system out
> > there.  I actually know of a number of such systems where it surely won't
> > work at all.
> 
> The runtime PM support for PCIe port is not turned on by default, we need
> 
> # echo auto > /sys/devices/pcixxxx:xx/<pci id>/power/control
> 
> to turn on it.  And we will turn on it on system it works.  Is this sufficient?

No, it is not.  In some cases it shouldn't be enabled at all for PCI Express
ports, as far as I can say, so to be on the safe side we should only enable it
on platforms where PCI Express ports are known to work correctly with runtime PM.

Thanks,
Rafael
