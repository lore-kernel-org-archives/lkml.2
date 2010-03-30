Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751975Ab0C3ERp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 00:17:45 -0400
Received: from hera.kernel.org ([140.211.167.34]:46486 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751245Ab0C3ERo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 00:17:44 -0400
Message-ID: <4BB17AF6.6090809@kernel.org>
Date: Mon, 29 Mar 2010 21:15:50 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH RFC] e820_remove_range fail?
References: <201003301238.43620.rusty@rustcorp.com.au>
In-Reply-To: <201003301238.43620.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29/2010 07:08 PM, Rusty Russell wrote:
> Hi Yinghai,
> 
>    I just wrote this patch for lguest, but I think the real problem is
> that e820_remove_range can't split a range.  Is this a problem for
> real machines?
> 
> [    0.000000] BIOS-provided physical RAM map:
> [    0.000000]  LGUEST: 0000000000000000 - 0000000004000000 (usable)
> [    0.000000] Notice: NX (Execute Disable) protection missing in CPU or disabled in BIOS!
> [    0.000000] DMI not present or invalid.
> [    0.000000] last_pfn = 0x3fa0 max_arch_pfn = 0x100000
> [    0.000000] init_memory_mapping: 0000000000000000-0000000003fa0000
> 

you are right, looks like e820_remove_region() missed that case.

will send out one patch.

Thanks

Yinghai Lu
