Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866Ab0IXRRe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 13:17:34 -0400
Received: from cpoproxy2-pub.bluehost.com ([67.222.39.38]:57389 "HELO
	cpoproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751700Ab0IXRRc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 13:17:32 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=nsJvNZ1/KZEE9LdcX3eH5X0lkCZoRTOTJJq/WH50enw2dOLFoQk8GjAd+gixL4tTFOKuoHIbR53XDdnAo3TUkqvTTZld990GGsBEXUNB2DLzEJE2B0llHSMokh0GQmW8;
Date: Fri, 24 Sep 2010 10:17:29 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Tom Lyon <pugs@cisco.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, randy.dunlap@oracle.com, arnd@arndb.de,
        joro@8bytes.org, hjk@linutronix.de, avi@redhat.com, gregkh@suse.de,
        chrisw@sous-sol.org, alex.williamson@redhat.com, mst@redhat.com
Subject: Re: [PATCH 0/3] VFIO V4: VFIO driver: Non-privileged user level PCI
 drivers
Message-ID: <20100924101729.6382a2c8@jbarnes-desktop>
In-Reply-To: <4c9a720d.kfMPk+Yyq+IUUwiw%pugs@cisco.com>
References: <4c9a720d.kfMPk+Yyq+IUUwiw%pugs@cisco.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Sep 2010 14:15:57 -0700
Tom Lyon <pugs@cisco.com> wrote:

> After a long summer break, it's tanned, it's rested, and it's ready to rumble!
> 
> In this version:	*** REBASE to 2.6.35 ***
> 
> There's new code using generic netlink messages which allows the kernel
> to notify the user level of weird events and allows the user level to 
> respond. This is currently used to handle device removal (whether software
> or hardware driven), PCI error events, and system suspend & hibernate.
> 
> The driver now supports devices which use multiple MSI interrupts, reflecting
> the actual number of interrupts allocated by the system to the user level.
> 
> PCI config accesses are now done through the pci_user_{read,write)_config
> routines from drivers/pci/access.c.
> 

I really don't like to encourage user level drivers (in fact I've
actively tried to kill them in our graphics stack), but I do understand
that they're convenient in many scenarios.

So assuming you can convince someone to apply the VFIO framework, I'm
ok with exporting the user level accessor functions (after all, we
export them to userland already via sysfs, so exporting them as GPL
symbols to another module is fine).

So you can add my Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org> to
the PCI parts, but don't take it as an endorsement of VFIO in
general! :) 

-- 
Jesse Barnes, Intel Open Source Technology Center
