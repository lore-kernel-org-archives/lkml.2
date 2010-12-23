Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752391Ab0LWUyl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 15:54:41 -0500
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:42852 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751655Ab0LWUyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 15:54:39 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=BJQcuQOd1Q4uUixoXDgTyx/NtiSuesXtDyLIUiOYCa/gUYxkcMCxkcACZRiRY5zCfzgjqKeuGBLM6SFR6R2fCSaBRL8l12+dDykmJlRqN2fqBVWcYN5yHi4QVj5S6jrM;
Date: Thu, 23 Dec 2010 12:54:35 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-pci@vger.kernel.org,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH] PCI / PCIe: Clear Root PME Status bits early during
 system resume
Message-ID: <20101223125435.248105fa@jbarnes-desktop>
In-Reply-To: <201012191557.16403.rjw@sisk.pl>
References: <201012191149.40547.rjw@sisk.pl>
	<201012191341.23601.rjw@sisk.pl>
	<201012191354.47960.rjw@sisk.pl>
	<201012191557.16403.rjw@sisk.pl>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 19 Dec 2010 15:57:16 +0100
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> I noticed that PCI Express PMEs don't work on my Toshiba Portege R500
> after the system has been woken up from a sleep state by a PME
> (through Wake-on-LAN).  After some investigation it turned out that
> the BIOS didn't clear the Root PME Status bit in the root port that
> received the wakeup PME and since the Requester ID was also set in
> the port's Root Status register, any subsequent PMEs didn't trigger
> interrupts.
> 
> This problem can be avoided by clearing the Root PME Status bits in
> all PCI Express root ports during early resume.  For this purpose,
> add an early resume routine to the PCIe port driver and make this
> driver be always registered, even if pci_ports_disable is set (in
> which case the driver's only function is to provide the early
> resume callback).
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
> 

Applied to my linux-next branch, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
