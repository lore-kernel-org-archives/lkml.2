Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756749Ab0FDAFa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 20:05:30 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:37997 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756510Ab0FDAF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 20:05:26 -0400
Date: Fri, 4 Jun 2010 01:05:19 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Richard Tillmore <rtillmore@gmail.com>
Cc: Robert Hancock <hancockrwd@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: resource piix4_smbus conflicts with ACPI region SMRG
Message-ID: <20100604000519.GA15830@srcf.ucam.org>
References: <AANLkTinmBxzM4IEgrY6gqokDhLJDrVyKd0cu75VaFR8Q@mail.gmail.com> <4C04496E.3000303@gmail.com> <AANLkTil6y3F1RDZaNwKS1FZB_Nrl_meFxIR2XzMoqCO7@mail.gmail.com> <AANLkTilQQrWX-wUiw_835x6KxRM_9xAV_z58Fu0IgqY2@mail.gmail.com> <AANLkTil9MQq-22Q8_0-J49B56EFUlTkUf5o4Lpd5BVum@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTil9MQq-22Q8_0-J49B56EFUlTkUf5o4Lpd5BVum@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 03, 2010 at 06:50:44PM -0500, Richard Tillmore wrote:
> On Mon, May 31, 2010 at 10:13 PM, Robert Hancock wrote:
> > You should be able to use acpi_enforce_resources=lax on the kernel
> > command line to allow the driver to load. The problem is that the
> > kernel can't tell if it's safe to allow a driver to access that
> > hardware since it may conflict with BIOS access (in some cases this
> > can cause serious problems like system overheating or spurious thermal
> > shutdowns if the BIOS also accesses the device to perform thermal
> > management) and so the default is to not allow it.
> 
> I booted with acpi_enforce_resources=lax and I now can get my CPU
> temperature.  So is my having to add acpi_enforce_resources=lax an
> effect of ACPI changes or bootmem changes?

ACPI changes. Your firmware indicates that ACPI makes use of the smbus 
controller - since many smbus transactions involve writing an address 
and then a value, and since we can't enforce locking between the kernel 
and the firmware, it's not possible to prove that it's safe to allow the 
kernel to touch these resources. Passing the kernel parameter disables 
this check in cases where you know it's safe.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
