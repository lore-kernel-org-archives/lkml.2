Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923Ab0CZNn5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 09:43:57 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:36078 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753813Ab0CZNnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 09:43:53 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4BACB9DD.6000103@s5r6.in-berlin.de>
Date: Fri, 26 Mar 2010 14:42:53 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100102 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Mike Travis <travis@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.34-rc1: pci_register_set_vga_state section mismatch
References: <tkrat.8b3a3a309b59a31b@s5r6.in-berlin.de>
In-Reply-To: <tkrat.8b3a3a309b59a31b@s5r6.in-berlin.de>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
>> WARNING: drivers/pci/built-in.o(__ksymtab+0x320): Section mismatch in reference from the variable __ksymtab_pci_register_set_vga_state to the function .init.text:pci_register_set_vga_state()                                                                                
>> The symbol pci_register_set_vga_state is exported and annotated __init                    
>> Fix this by removing the __init annotation of pci_register_set_vga_state or drop the export.                                                                                        
> 
> This is obviously introduced by commit
>     95a8b6efc5d07103583f706c8a5889437d537939
>     pci: Update pci_set_vga_state() to call arch functions

PS:
There is only a single user of this symbol in the mainline at the
moment, arch/x86/kernel/apic/x2apic_uv_x.c, controlled by
arch/x86/Kconfig:config X86_UV, which allows only static linking.
I.e. the warning is a false positive for now.  But given how small
pci_register_set_vga_state() is, it appears appropriate to drop the
__init annotation.
-- 
Stefan Richter
-=====-==-=- --== ==-=-
http://arcgraph.de/sr/
