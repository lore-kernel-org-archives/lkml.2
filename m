Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752247Ab1FNRFV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 13:05:21 -0400
Received: from mail.perches.com ([173.55.12.10]:3004 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751214Ab1FNRFT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 13:05:19 -0400
Subject: Re: [PATCH v2] x86, efi: Do not reserve boot services regions
 within reserved areas
From: Joe Perches <joe@perches.com>
To: Maarten Lankhorst <m.b.lankhorst@gmail.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Yinghai Lu <yinghai@kernel.org>,
        Jim Bos <jim876@xs4all.nl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <4DF78A22.8060405@gmail.com>
References: <4DF78A22.8060405@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 14 Jun 2011 10:05:18 -0700
Message-ID: <1308071118.21026.16.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-06-14 at 18:19 +0200, Maarten Lankhorst wrote:
> Commit 916f676f8dc started reserving boot service code since some systems
> require you to keep that code around until SetVirtualAddressMap is called.
[]
> Signed-off-by: Maarten Lankhorst <m.b.lankhorst@gmail.com>

Hello Maarten, just trivia.

> diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
[]
> +			memblock_dbg(PFX "Could not reserve boot area "
> +				"[0x%llx-0x%llx)\n", start, start+size);

I believe this should be:

			memblock_dbg(PFX "Could not reserve boot area 0x%llx-0x%llx)\n",
				     start, start + size - 1);


