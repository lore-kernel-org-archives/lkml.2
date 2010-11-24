Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417Ab0KXO57 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 09:57:59 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:57069 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351Ab0KXO55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 09:57:57 -0500
Date: Wed, 24 Nov 2010 14:57:50 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Jiri Slaby <jslaby@suse.cz>
Cc: corentincj@iksaif.net, acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: eeepc: rfkill on 900A defunct
Message-ID: <20101124145750.GA32033@srcf.ucam.org>
References: <4CED26EF.5000109@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CED26EF.5000109@suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 24, 2010 at 03:53:35PM +0100, Jiri Slaby wrote:

> but without hotplug support (pciehp cannot be bound to it). However the
> eeepc-laptop driver expects the wifi on the 1st bus (pci_find_bus(0,
> 1)), so it operates on a NIC on this machine instead of wifi.

Yeah, this really needs to be fixed. We need to shift this code out of 
eeepc-laptop and just have the PCI core handle it - that is, if we get a 
hotplug notification, we need to rescan the slot even if we don't have a 
hotplug driver bound to it. Let me look into that.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
