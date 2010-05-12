Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802Ab0ELKdi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 06:33:38 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:47471 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776Ab0ELKdh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 06:33:37 -0400
Date: Wed, 12 May 2010 12:34:02 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCH] USB: gadget: f_mass_storage: fix in fsg_common_init()
 error recovery
In-reply-to: <70376CA23424B34D86F1C7DE6B9973430254343ABD@VSHINMSMBX01.vshodc.lntinfotech.com>
To: Viral Mehta <Viral.Mehta@lntinfotech.com>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-id: <op.vck8y0uv7p4s8u@pikus>
Organization: Samsung Electronics
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.10 (Linux)
References: <994e1bf34d3b6f1fbc58c0f7ce61c7f258208ddd.1273651956.git.mina86@mina86.com>
 <70376CA23424B34D86F1C7DE6B9973430254343ABA@VSHINMSMBX01.vshodc.lntinfotech.com>
 <op.vck4q0c87p4s8u@pikus>
 <70376CA23424B34D86F1C7DE6B9973430254343ABB@VSHINMSMBX01.vshodc.lntinfotech.com>
 <op.vck63vc77p4s8u@pikus>
 <70376CA23424B34D86F1C7DE6B9973430254343ABD@VSHINMSMBX01.vshodc.lntinfotech.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 May 2010 12:06:11 +0200, Viral Mehta <Viral.Mehta@lntinfotech.com> wrote:
> In fsg_common_release(), we are freeing common->luns.
> 2894         kfree(common->luns);
>
> However, these gets allocd in fsg_common_init()
> 2712         /* Create the LUNs, open their backing files, and register the
> 2713          * LUN devices in sysfs. */
> 2714         curlun = kzalloc(nluns * sizeof *curlun, GFP_KERNEL);
> 2715         if (!curlun) {
> 2716                 kfree(common);
> 2717                 return ERR_PTR(-ENOMEM);
> 2718         }
>
> Now, if this kzalloc at line 2714 failed
> And if your patch is applied, you will follow error_release path which in
> turn will call kfree on a pointer whose allocation is failed.

If luns allocation fails, common->luns will be NULL and freeing a NULL
pointer is a no-operation thus the code works just fine.

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--
