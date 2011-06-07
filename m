Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756833Ab1FGCF1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 22:05:27 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:24851 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754406Ab1FGCFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 22:05:25 -0400
Message-ID: <4DED8752.5070005@kernel.org>
Date: Mon, 06 Jun 2011 19:05:06 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Maarten Lankhorst <m.b.lankhorst@gmail.com>, Jim Bos <jim876@xs4all.nl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>, "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: 2.6.39.1 immediately reboots/resets on EFI system
References: <AANLkTikeYLrqXhvTP_uuKnKhy=k7pAQCbONJdKBc838O@mail.gmail.com> <20101115195115.GZ29412@tyan-ft48-01.lab.bos.redhat.com> <4CE1968D.3050706@xs4all.nl> <4DE8DC16.6030308@xs4all.nl> <20110603133351.GA25130@srcf.ucam.org> <4DE8EF13.9030609@xs4all.nl> <BANLkTinWj1LvQLverPTUm9rKEx=+HZUpDA@mail.gmail.com> <4DECFC1C.10801@xs4all.nl> <4DED0394.2090000@gmail.com> <BANLkTikVEj2Uz9N0B-kKA3GJTUWzmwz=zQ@mail.gmail.com> <20110607014127.GA8450@srcf.ucam.org>
In-Reply-To: <20110607014127.GA8450@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4DED875E.004C,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/2011 06:41 PM, Matthew Garrett wrote:
> On Mon, Jun 06, 2011 at 05:19:17PM -0700, Yinghai Lu wrote:
> 
>> assume EFI in ram is not page-aligned?
> 
> They'll be 4K aligned at least.
> 


can you get boot log with "memblock=debug"?

wonder if 

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 4be9b39..c6724e4 100644 (file)
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -912,6 +912,13 @@ void __init setup_arch(char **cmdline_p)
        memblock.current_limit = get_max_mapped();
        memblock_x86_fill();
 
+       /*
+        * The EFI specification says that boot service code won't be called
+        * after ExitBootServices(). This is, in fact, a lie.
+        */
+       if (efi_enabled)
+               efi_reserve_boot_services(

wonder if double memblock ram array in memblock_x86_fill() that is overlapping with boot services.

Thanks

Yinghai
