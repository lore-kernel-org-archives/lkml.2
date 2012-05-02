Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753606Ab2EBVXB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 17:23:01 -0400
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:12241 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753456Ab2EBVW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 17:22:58 -0400
Message-ID: <1335993631.16730.74.camel@misato.fc.hp.com>
Subject: Re: [PATCH 1/4] ACPI: Set hotplug _OST support bit to _OSC
From: Toshi Kani <toshi.kani@hp.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        shuahkhan@gmail.com
Date: Wed, 02 May 2012 15:20:31 -0600
In-Reply-To: <1335564323.16730.41.camel@misato.fc.hp.com>
References: <1334096510-17319-1-git-send-email-toshi.kani@hp.com>
	 <1334096510-17319-2-git-send-email-toshi.kani@hp.com>
	 <CAErSpo6Ofm8qHUophN+oXrsKKfnJXvaEJUfFkEFwbXLfb4xZ=g@mail.gmail.com>
	 <1335460230.17002.62.camel@misato.fc.hp.com>
	 <1335564323.16730.41.camel@misato.fc.hp.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-04-27 at 16:05 -0600, Toshi Kani wrote:
> On Thu, 2012-04-26 at 11:10 -0600, Toshi Kani wrote:
> > On Thu, 2012-04-26 at 09:16 -0600, Bjorn Helgaas wrote:
> > > On Tue, Apr 10, 2012 at 4:21 PM, Toshi Kani <toshi.kani@hp.com> wrote:
	:
> > > >
> > > > +#if defined(CONFIG_ACPI_HOTPLUG_CPU) || defined(CONFIG_ACPI_HOTPLUG_MEMORY) ||\
> > > > +                defined(CONFIG_ACPI_HOTPLUG_MEMORY_MODULE)
> > > > +       capbuf[OSC_SUPPORT_TYPE] |= OSC_SB_HOTPLUG_OST_SUPPORT;
> > > > +#endif
> > > 
> > > This seems a bit strange to me.  For one thing, the _OSC discussion
> > > doesn't seem to indicate that _OST support is specific to CPU or
> > > memory hotplug.  If we tell the platform that we support _OST, the
> > > platform can assume that we'll evaluate _OST for *any* device, which
> > > is not the case.  I guess this is just another reason why we need
> > > hotplug support in the ACPI core, not in the individual drivers.  Then
> > > we wouldn't have the ifdefs at all.

Thinking further, I am going to make the following changes to address
this comment.

1. Add CONFIG_ACPI_HOTPLUG_OST (disable by default)
When this option is set, the kernel calls _OSC with the hotplug _OST
flag at boot-time.  This replaces the current use of device-specific
config options, such as CONFIG_ACPI_HOTPLUG_CPU.  Also, the kernel only
calls _OST when this option is set.  In other words, all features in
this patch set is disabled when this option is not set (default).  This
should address Shuah's concerns about pre-enablement as well.

2. Add support of container hotplug
_OST will be supported for three major ACPI hotplug operations; CPU,
memory and container.  (This assumes PCI will use native hotplug going
forward.)  It will also support asynchronous hot-removal, such as
KOBJ_OFFLINE -> udev -> eject.

I will send updated _OST patches when they are ready.

Thanks,
-Toshi


