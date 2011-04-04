Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755662Ab1DDVK1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 17:10:27 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36811
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755428Ab1DDVKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 17:10:24 -0400
Date: Mon, 04 Apr 2011 14:09:47 -0700 (PDT)
Message-Id: <20110404.140947.22046935.davem@davemloft.net>
To: benh@kernel.crashing.org
Cc: linux-arch@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [RFC/PATCH] of: Match PCI devices to OF nodes generically
From: David Miller <davem@davemloft.net>
In-Reply-To: <1301950997.2549.84.camel@pasglop>
References: <1301887630.2549.71.camel@pasglop>
	<20110404.004856.55863268.davem@davemloft.net>
	<1301950997.2549.84.camel@pasglop>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Tue, 05 Apr 2011 07:03:17 +1000

> On Mon, 2011-04-04 at 00:48 -0700, David Miller wrote:
>> From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
>> Date: Mon, 04 Apr 2011 13:27:10 +1000
>> 
>> > +struct device_node * __weak pcibios_get_phb_of_node(struct pci_bus *bus)
>> > +{
>> > +	/* This should only be called for PHBs */
>> > +	if (WARN_ON(bus->self || bus->parent))
>> > +		return NULL;
>> 
>> This WARN_ON() will always trigger on sparc, because we use the OF
>> device tree object at the "parent" of the PCI bus devices we create
>> for the PCI controller domains.
>> 
>> I'm really surprised you don't link the PCI bus roots into the rest of
>> the global device hierarchy on powerpc.
> 
> But in the above test bus->parent is the "struct pci_bus *" parent, not
> the "struct device *" nor "struct device_node *" parent... That
> shouldn't be linked to anything on a PHB.

Aha, ok, then it shouldn't trigger on sparc, thanks for explaining.

