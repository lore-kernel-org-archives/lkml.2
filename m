Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932187Ab0F2QtN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 12:49:13 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:34222 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755786Ab0F2QtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 12:49:11 -0400
Subject: Re: 2.6.35-rc3 regression: IBM Maia system is unbootable [ACPI
 related?]
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Len Brown <lenb@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
In-Reply-To: <alpine.LFD.2.00.1006282346320.16755@localhost.localdomain>
References: <1277136189.10998.63.camel@mulgrave.site>
	 <87pqzkqrzq.fsf@basil.nowhere.org>
	 <1277138034.10998.69.camel@mulgrave.site>
	 <1277139286.10998.72.camel@mulgrave.site>
	 <1277141166.10998.79.camel@mulgrave.site>
	 <alpine.LFD.2.00.1006282346320.16755@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 29 Jun 2010 11:49:08 -0500
Message-ID: <1277830148.4379.14.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-06-28 at 23:49 -0400, Len Brown wrote:
> From: Len Brown <len.brown@intel.com>
> Subject: [PATCH] ACPI: handle systems which asynchoronously enable ACPI mode
> 
> Folklore suggested that such systems existed
> in the pre-history of ACPI.
> 
> However, we removed the SCI_EN polling loop from
> acpi_hw_set_mode() in b430acbd7c4b919886fa7fd92eeb7a695f1940d3
> because it delayed resume by 3 seconds on boxes
> that refused to set SCI_EN.
> 
> Matthew removed the call to acpi_enable() from
> the suspend resume path.
> 
> James found a modern system that still needs to be polled
> upon boot.
> 
> So here we restore the workaround, except that we
> put it in acpi_enable() rather than the low level
> acpi_hw_set_mode().
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=16271
> 
> Signed-off-by: Len Brown <len.brown@intel.com>
> ---
> 
> James, What does the IBM system see with this patch?

The output is this:

[    0.084088] ACPI: Core revision 20100428
[    0.119451] ACPI Warning: Platform took > 100 usec to enter ACPI mode (20100428/evxfevnt-106)
[    0.128231] Setting APIC routing to physical flat

So it's very fast ... actually it's behaving like there's some caching
issue and it needs two reads to return the correct value

James


