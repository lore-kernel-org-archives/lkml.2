Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808Ab0JMWIB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 18:08:01 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:53353 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844Ab0JMWH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 18:07:59 -0400
Message-ID: <4CB62D54.7000400@kernel.org>
Date: Wed, 13 Oct 2010 15:06:12 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100914 SUSE/3.0.8 Thunderbird/3.0.8
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 0/4] memblock related fixes for -tip
References: <4CAA4DC1.6000104@kernel.org> <4CB4ABE2.3010300@goop.org> <4CB4CF4D.5020706@kernel.org> <4CB4F11F.4090104@goop.org> <4CB54640.4000003@kernel.org> <4CB5DEE8.2020400@goop.org> <4CB5F86C.9030900@zytor.com> <4CB6107F.4080908@goop.org>
In-Reply-To: <4CB6107F.4080908@goop.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/13/2010 01:03 PM, Jeremy Fitzhardinge wrote:
>> a) Add an explicit interface to allocate bottoms-up, and have Xen use it
>> because it needs it.  This is appropriate if (and only if) the
>> allocations in Xen aren't underneath a bunch of extra layers.
> 
> The allocation is done in find_early_table_space() in x86/mm/init.c, so
> the allocation call itself can't be easily replaced, but I suppose some
> of the parameters could be global and tweaked by Xen code, but that's
> pretty ugly.

we already have
        base = memblock_find_in_range(start, max_pfn_mapped<<PAGE_SHIFT,
                                        tables, PAGE_SIZE);

so looks like xen have set max_pfn_mapped wrong?


Yinghai
