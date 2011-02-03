Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932501Ab1BCTUW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 14:20:22 -0500
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:36013 "HELO
	cpoproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932406Ab1BCTUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 14:20:19 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=fZwzn1aTbBN5CTW3cM98dMODqD1J2N/ri8HLf76i4NEgiRjn38+9aRCzxQrQKq4eIwfNFvc4NBwydCp6740a0i+FWGhOb1bqNdA1Fwt6i5FOaxGUzcVLttqm2xxROkyb;
Date: Thu, 3 Feb 2011 11:20:16 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Len Brown <lenb@kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
        Linux PM List <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH] ACPI: Remove the wakeup.run_wake_count device field
Message-ID: <20110203112016.56ed35c3@jbarnes-desktop>
In-Reply-To: <201102032014.18102.rjw@sisk.pl>
References: <201102032014.18102.rjw@sisk.pl>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Feb 2011 20:14:17 +0100
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> The wakeup.run_wake_count ACPI device field is only used by the PCI
> runtime PM code to "protect" devices from being prepared for
> generating wakeup signals more than once in a row.  However, it
> really doesn't provide any protection, because (1) all of the
> functions it is supposed to protect use their own reference counters
> effectively ensuring that the device will be set up for generating
> wakeup signals just once and (2) the PCI runtime PM code uses
> wakeup.run_wake_count in a racy way, since nothing prevents
> acpi_dev_run_wake() from being called concurrently from two different
> threads for the same device.
> 
> Remove the wakeup.run_wake_count ACPI device field which is
> unnecessary, confusing and used in a wrong way.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>  drivers/acpi/button.c   |    2 --
>  drivers/acpi/scan.c     |    1 -
>  drivers/pci/pci-acpi.c  |   16 ++++------------
>  include/acpi/acpi_bus.h |    1 -
>  4 files changed, 4 insertions(+), 16 deletions(-)

Ack on the PCI bits.

Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>

-- 
Jesse Barnes, Intel Open Source Technology Center
