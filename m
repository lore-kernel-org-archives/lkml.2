Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755785Ab1K2OX7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 09:23:59 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:52817 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755736Ab1K2OX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 09:23:56 -0500
X-Sasl-enc: GXbO1Ep1Q65DPfnzGaOYXYXfdAiqUbH3cfQdDVcHzT+J 1322576635
Date: Tue, 29 Nov 2011 23:22:14 +0900
From: Greg KH <greg@kroah.com>
To: Anand Kanaginhal <anand_dk@hotmail.com>
Cc: Linux PCI mailing <linux-pci@vger.kernel.org>,
        linux kernel mailing <linux-kernel@vger.kernel.org>,
        linux hotplug mailing <linux-hotplug@vger.kernel.org>
Subject: Re: PCIe Hotplugging not working
Message-ID: <20111129142214.GC14845@kroah.com>
References: <BAY163-W52E309F419E3588206D889FBB30@phx.gbl>
 <BAY163-W47DD39095DA3EB108AA3F2FBB30@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BAY163-W47DD39095DA3EB108AA3F2FBB30@phx.gbl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 29, 2011 at 03:56:12AM -0800, Anand Kanaginhal wrote:
> 
> 
> I am trying to get PCIe endpoint hot - plugging working
> 
> The Set up is such that there is one endpoint (our custom device) connected to PCI  switch PLX 8609 8 port 8 lane switch. 
> 1. I have my driver module compiled, copied into /lib/modules/`uname -r`/kernel/drivers/char/

Why is a pci driver a "char" driver?  Do you have a pointer to the
source of this?

> 2. I run depmod and "modules.pcimap" also got updated with my module. 
> 
> However
>  if I unplug and plug in the endpoint, my driver .probe and .remove functions
>  are not being invoked. Is there something more to be done at the bus 
> level to get the driver to hot plug ?

You need a pci hotplug controller driver, is that loaded?  That is what
is responsible for eventually calling your remove function.

> I have tried various kernel version, Currently I am trying on 2.6.38.12 (UBUNTU flavor).

We can't help you with distro-specific kernels, please use a kernel.org
kernel and we will be glad to help you out.

greg k-h
