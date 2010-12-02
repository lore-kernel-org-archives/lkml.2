Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758110Ab0LBWeW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 17:34:22 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40595 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752844Ab0LBWeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 17:34:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=KUmFFYorI2t4q43xkje6PARkhgew+iX7AFTNHzEFIgET0ny8f+w6pgpTgyDNhGUTph
         W4nZOhmzrPHP8MilTENedm1D2yT8AasrGMl6mWwx6R7sB0iqeQ2w6B7V1W73Q3k5SuFA
         nuK3+tbuSg849WPQjTkNtEy4EP6krHx2Aa8qc=
Subject: Re: edac_core: crashes on shutdown
From: Tobias Karnat <tobias.karnat@googlemail.com>
To: Borislav Petkov <bp@amd64.org>
Cc: "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Doug Thompson <norsk5@yahoo.com>
In-Reply-To: <20101202183724.GH27263@aftab>
References: <20101201123921.GA15530@a1.tnic>
	 <1291209888.12511.11.camel@Tobias-Karnat> <20101201143329.GB18074@a1.tnic>
	 <1291225614.8646.4.camel@Tobias-Karnat>
	 <20101201193508.GA4916@liondog.tnic>
	 <1291280613.10626.22.camel@Tobias-Karnat> <20101202152106.GA29301@a1.tnic>
	 <1291306872.3898.7.camel@Tobias-Karnat> <20101202170610.GE27263@aftab>
	 <1291313101.5563.13.camel@Tobias-Karnat>  <20101202183724.GH27263@aftab>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 02 Dec 2010 23:34:14 +0100
Message-ID: <1291329254.8869.66.camel@Tobias-Karnat>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, den 02.12.2010, 19:37 +0100 schrieb Borislav Petkov:
> On Thu, Dec 02, 2010 at 01:05:01PM -0500, Tobias Karnat wrote:
> > Btw, are there any information available regarding the NMI option?
> > 
> > parm:	edac_op_state:EDAC Error Reporting state: 0=Poll,1=NMI (int)
> > 
> > In edac.txt NMI is listed under FUTURE HARDWARE SCANNING.
> 
> Well, looking at <arch/x86/kernel/traps.c:mem_parity_error()> this
> should already work. But it is kinda of a hack, if I'm reading Doug
> correctly: http://lkml.org/lkml/2010/9/21/144

This thread has many unknown abbreviations for me,

I thought as you wrote later, that this would be an option to use an
interrupt instead of polling for edac in general.

But as far as I understand this, it is used for PCI bus errors?

And should be replaced for detection of PCI SERR and/or PCIE AER,
are these the same as PCI bus errors?

> And yes, using some kind of an interrupt is much better than polling but
> I don't know whether there's a single interrupt source for the error
> types all edac drivers can decode and report. In the amd64_edac case,
> we're piggybacking on MCE, for example. This was actually the initial
> reason for 00740c58541b6087d78418cebca1fcb86dc6077d and dropping polling
> from that driver.

>From Intel Architectures Software Developer's Manual Part 3A:

"Starting with 45nm Intel 64 processor with CPUID signature
DisplayFamily_DisplayModel encoding of 06H_1AH (...), the processor can
report information on corrected machine-check errors and deliver a
programmable interrupt for software to respond to MC errors, referred to
as corrected machine-check error interrupt (CMCI)."

Seems to be unlikely for me on an Intel 975X Mainboard.

-Tobias

