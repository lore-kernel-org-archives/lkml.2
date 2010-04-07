Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756868Ab0DGXod (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 19:44:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40138 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753940Ab0DGXoa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 19:44:30 -0400
Message-ID: <4BBD18B0.6010302@zytor.com>
Date: Wed, 07 Apr 2010 16:43:44 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Yinghai <yinghai.lu@oracle.com>
CC: Bjorn Helgaas <bjorn.helgaas@hp.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, linux-pci@vger.kernel.org,
       x86@kernel.org, linux-kernel@vger.kernel.org,
       Andy Isaacson <adi@hexapodia.org>, Thomas Renninger <trenn@suse.de>
Subject: Re: [PATCH] x86: Reserve legacy VGA MMIO area for x86_64 as well
 as x86_32
References: <20100407210628.28364.96982.stgit@bob.kio> <4BBD0B0A.3090702@oracle.com>
In-Reply-To: <4BBD0B0A.3090702@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/07/2010 03:45 PM, Yinghai wrote:
> 
> It seem another thread, erission has one model without VGA, and they use that area for other device MMIO.
> 
> current for 64bit, We remove [0xa0000, 0x100000) from e820 map if those area is E820_RAM.
> 

Removing is not the same thing as reserving!

A range with no type in E820 is address space available for allocation;
whereas in order to be reserved, it should be E820_RESERVED.

> in e820_reserve_resources(), kernel will reserve range < 1M according to e820 map.
> that is before pci BAR is claimed.
> 
> or you can add
> boot_params.screen_info.orig_video_isVGA == 1
> or double check scan pci tree to see if video is there or not

Perhaps boot_params.screen_info.orig_video_isVGA != 1 because he's not
booting in a text mode?
	
	-hpa

