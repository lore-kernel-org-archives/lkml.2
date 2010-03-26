Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545Ab0CZXcL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 19:32:11 -0400
Received: from outbound-mail-158.bluehost.com ([67.222.39.38]:40684 "HELO
	outbound-mail-158.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752935Ab0CZXcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 19:32:09 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=KaUhJP1BKRPBpWw+NYWIvRnPvi/QVPciur/jABICgFkUWcegdeDAehWcGOy/znDXraaIA1+X52jKmwbHusTjLJ7kN2bCmqWMevT39BSe5esz2iEqtnI8cMYL7UB+sWzI;
Date: Fri, 26 Mar 2010 16:31:28 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mike Travis <travis@sgi.com>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.34-rc1: pci_register_set_vga_state section mismatch
Message-ID: <20100326163128.2d4ca1a1@jbarnes-piketon>
In-Reply-To: <4BACB9DD.6000103@s5r6.in-berlin.de>
References: <tkrat.8b3a3a309b59a31b@s5r6.in-berlin.de>
	<4BACB9DD.6000103@s5r6.in-berlin.de>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Mar 2010 14:42:53 +0100
Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:

> Stefan Richter wrote:
> >> WARNING: drivers/pci/built-in.o(__ksymtab+0x320): Section mismatch in reference from the variable __ksymtab_pci_register_set_vga_state to the function .init.text:pci_register_set_vga_state()                                                                                
> >> The symbol pci_register_set_vga_state is exported and annotated __init                    
> >> Fix this by removing the __init annotation of pci_register_set_vga_state or drop the export.                                                                                        
> > 
> > This is obviously introduced by commit
> >     95a8b6efc5d07103583f706c8a5889437d537939
> >     pci: Update pci_set_vga_state() to call arch functions
> 
> PS:
> There is only a single user of this symbol in the mainline at the
> moment, arch/x86/kernel/apic/x2apic_uv_x.c, controlled by
> arch/x86/Kconfig:config X86_UV, which allows only static linking.
> I.e. the warning is a false positive for now.  But given how small
> pci_register_set_vga_state() is, it appears appropriate to drop the
> __init annotation.

I'm just sending out a fix to remove the export now.

-- 
Jesse Barnes, Intel Open Source Technology Center
