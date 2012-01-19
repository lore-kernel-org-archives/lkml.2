Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932758Ab2ASTOr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 14:14:47 -0500
Received: from mx1.gd-ms.com ([153.11.250.40]:33455 "EHLO mx1.gd-ms.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756762Ab2ASTOo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 14:14:44 -0500
In-Reply-To: <4F18584F.7060603@zytor.com>
References: <OF70B406E9.8D4A6789-ON85257988.0052C104-85257988.0053DE1E@gdeb.com>	<20120117195841.48fe8236@pyramind.ukuu.org.uk> <OFD4BB6876.6D903346-ON8525798A.00550E62-8525798A.005562A3@gdeb.com> <20120119154504.710e202e@pyramind.ukuu.org.uk> <OF8642E997.5ED041E1-ON8525798A.0056983A-8525798A.0056E05B@LocalDomain> <OF2B909250.6078896E-ON8525798A.0058FF49-8525798A.0061AEA1@gdeb.com> <4F18584F.7060603@zytor.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Kushal Koolwal <kushalkoolwal@gmail.com>, linux-kernel@vger.kernel.org,
        michael.d.labriola@gmail.com, Ingo Molnar <mingo@elte.hu>,
        Matthew Garrett <mjg59@srcf.ucam.org>, support@versalogic.com,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org
MIME-Version: 1.0
Subject: Re: [PATCH] x86, reboot: skip DMI checks if reboot set by user
X-KeepSent: E1B368BB:B6249713-8525798A:00692513;
 type=4; name=$KeepSent
Message-ID: <OFE1B368BB.B6249713-ON8525798A.00692513-8525798A.0069B44E@gdeb.com>
From: Michael D Labriola <mlabriol@gdeb.com>
Date: Thu, 19 Jan 2012 14:14:32 -0500
X-GDMEncrypt: FALSE
X-GDMMarking: NOT_SENSITIVE
Content-Type: text/plain; charset="US-ASCII"
X-GDM-EVAL: score: /30; hits: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> wrote on 01/19/2012 12:52:15 PM:

> On 01/19/2012 09:46 AM, Michael D Labriola wrote:
> >
> > Random question...  why do we have a reboot_init function that does 
DMI
> > checking with reboot_dmi_table (callbacks are mostly set_bios_reboot, 
but
> > there is a single set_kbd_reboot) and also a pci_reboot_init which 
does
> > the DMI check again using a separate pci_reboot_dmi_table (all 
callbacks
> > are to set_pci_reboot)?
> >
> > Wouldn't it make more sense to do a single DMI scan using one big 
table?
> >
> 
> Yes, and such a patch would be appreciated.
> 
> The reason it is as it is dates back to before the 32-64 bit 
> unification, as far as I know.
> 
> (BIOS reboot is currently not supported on 64 bits, mainly.)

Well, that does complicate it a bit.  I'll gin something up and see what
you think.  I guess it will involve having an #ifdef CONFIG_X86_32 block
inside a single dmi_table structure for the BIOS quirks.

Actually, set_kbd_reboot is inside the current X86_32 only block, along
with the one DMI callback that uses it.  Is this correct?


---
Michael D Labriola
Electric Boat
mlabriol@gdeb.com
401-848-8871 (desk)
401-848-8513 (lab)
401-316-9844 (cell)


 

