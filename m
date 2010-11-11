Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757883Ab0KKIu7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 03:50:59 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:33544 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757808Ab0KKIu6 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:5:1>);
	Thu, 11 Nov 2010 03:50:58 -0500
Message-Id: <4CDBBC7E0200007800021A2D@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Thu, 11 Nov 2010 08:50:54 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Yinghai Lu" <yinghai@kernel.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -v2 2/2] x86/pci: Add mmconf range into e820 for
	 when it is from MSR with amd faml0h
References: <4CDB3E85.9010604@kernel.org> <4CDB3EBB.4010800@kernel.org>
In-Reply-To: <4CDB3EBB.4010800@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 11.11.10 at 01:54, Yinghai Lu <yinghai@kernel.org> wrote:
> @@ -191,10 +208,12 @@ void __cpuinit fam10h_check_enable_mmcfg
>  		/* only trust the one handle 256 buses, if acpi=off */
>  		if (!acpi_pci_disabled || busnbits >= 8) {
>  			u64 base;
> -			base = val & (0xffffULL << 32);
> +			base = val & (FAM10H_MMIO_CONF_BASE_MASK <<
> +					FAM10H_MMIO_CONF_BASE_SHIFT);
>  			if (fam10h_pci_mmconf_base_status <= 0) {
>  				fam10h_pci_mmconf_base = base;
>  				fam10h_pci_mmconf_base_status = 1;
> +				e820_add_mmconf_range(busnbits);
>  				return;
>  			} else if (fam10h_pci_mmconf_base ==  base)
>  				return;

I don't think adding the range in this case is correct: Here, we
found that the BIOS enabled the feature, and we're doing
nothing to "correct" it, so we also should expect the range
to be reserved by the BIOS.

Jan

