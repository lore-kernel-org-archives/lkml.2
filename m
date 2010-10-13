Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753705Ab0JMXIU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 19:08:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58211 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753496Ab0JMXIU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 19:08:20 -0400
Message-ID: <4CB63BC2.6090307@zytor.com>
Date: Wed, 13 Oct 2010 16:07:46 -0700
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
References: <4CAA4DC1.6000104@kernel.org> <4CB4ABE2.3010300@goop.org> <4CB4CF4D.5020706@kernel.org> <4CB4F11F.4090104@goop.org> <4CB54640.4000003@kernel.org> <4CB5DEE8.2020400@goop.org> <4CB5F86C.9030900@zytor.com> <4CB6107F.4080908@goop.org> <4CB61E95.90702@zytor.com> <4CB63A80.8060702@goop.org>
In-Reply-To: <4CB63A80.8060702@goop.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/13/2010 04:02 PM, Jeremy Fitzhardinge wrote:
> 
> This seems to do the trick:
> 
> From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> Date: Wed, 13 Oct 2010 14:21:55 -0700
> Subject: [PATCH] xen: cope with unmapped pages when initializing kernel pagetable
> 
> Xen requires that all pages containing pagetable entries to be mapped
> read-only.  If pages used for the initial pagetable are already mapped
> then we can change the mapping to RO.  However, if they are initially
> unmapped, we need to make sure that when they are later mapped, they
> are also mapped RO.
> 
> We do this by knowing that the kernel pagetable memory is pre-allocated
> in the range e820_table_start - e820_table_end, so any pfn within this
> range should be mapped read-only.  However, the pagetable setup code
> early_ioremaps the pages to write their entries, so we must make sure
> that mappings created in the early_ioremap fixmap area are mapped RW.
> (Those mappings are removed before the pages are presented to Xen
> as pagetable pages.)
> 
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> 

Seems both clean and The Right Thing[TM].

	-hpa
