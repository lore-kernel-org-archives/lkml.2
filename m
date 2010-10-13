Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856Ab0JMXTT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 19:19:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41224 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753827Ab0JMXTS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 19:19:18 -0400
Message-ID: <4CB63E57.2000300@zytor.com>
Date: Wed, 13 Oct 2010 16:18:47 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 0/4] memblock related fixes for -tip
References: <4CAA4DC1.6000104@kernel.org> <4CB4ABE2.3010300@goop.org> <4CB4CF4D.5020706@kernel.org> <4CB4F11F.4090104@goop.org> <4CB54640.4000003@kernel.org> <4CB5DEE8.2020400@goop.org> <4CB5F86C.9030900@zytor.com> <4CB6107F.4080908@goop.org> <4CB62D54.7000400@kernel.org> <4CB63D63.5040500@goop.org>
In-Reply-To: <4CB63D63.5040500@goop.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/13/2010 04:14 PM, Jeremy Fitzhardinge wrote:
> 
> The Xen code is setting the max_pfn_mapped correctly, but it is just
> being overridden by:
> 
> 	max_pfn_mapped = KERNEL_IMAGE_SIZE >> PAGE_SHIFT;
> 
> in setup_arch() - and KERNEL_IMAGE_SIZE is hard-coded to 512MB...
> 
> How is this correct?  Does kernel/head_64.S map everything up to 512MB
> or something?
> 

Yes:
        /*
         * 512 MB kernel mapping. We spend a full page on this pagetable
         * anyway.
         *
         * The kernel code+data+bss must not be bigger than that.
         *
         * (NOTE: at +512MB starts the module area, see MODULES_VADDR.
         *  If you want to increase this then increase MODULES_VADDR
         *  too.)
         */
        PMDS(0, __PAGE_KERNEL_LARGE_EXEC,
                KERNEL_IMAGE_SIZE/PMD_SIZE)

This is, however, wrong in the sense that it obviously shouldn't be
getting executed on the Xen codepath.

	-hpa
