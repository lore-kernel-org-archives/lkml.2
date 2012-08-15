Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755420Ab2HOPX2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 11:23:28 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:58924 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755409Ab2HOPXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 11:23:24 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v2 27/31] arm64: Loadable modules
Date: Wed, 15 Aug 2012 15:23:21 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com> <1344966752-16102-28-git-send-email-catalin.marinas@arm.com>
In-Reply-To: <1344966752-16102-28-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1252"
Content-Transfer-Encoding: 7bit
Message-Id: <201208151523.21447.arnd@arndb.de>
X-Provags-ID: V02:K0:3IqWH/VAYxWh2bk7bc8vR0Z82PZ/fVYpJFYOAuhbI34
 GciW6JggkXc/s2XKQW4K22X61OJpPIwTMt/6woBsCWr+DKPIMz
 j/oJHQdNp1592OGewXsdq8XCGxzAVji3+SikoRMHn17FG41ITn
 /TjR8bikvJD5jlvCe9IFFkTBL4YwPlP/98FhZWnRKNyoDrtQeG
 AUz+NF96lU1jQAJ7QIZQVPOB8/kbO6599MZ0jxE1qi6zhFeP9X
 kFm+Qtioj8MpDVCgkrLv+iyb7ATl9Uis6I6onVQymt3AghvIF3
 huxi/Ru0RnXY9PVP8ZvZzlk7jBsjeC4EdnXb+xXHvzcWSFnTZU
 MeqIAeLDhZQAfz1h2djI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 14 August 2012, Catalin Marinas wrote:
> +
> +void *module_alloc(unsigned long size)
> +{
> +       return __vmalloc_node_range(size, 1, MODULES_VADDR, MODULES_END,
> +                                   GFP_KERNEL, PAGE_KERNEL_EXEC, -1,
> +                                   __builtin_return_address(0));
> +}
> +

What is the reason for using a separate virtual address range for the
modules instead of falling back to the default module_alloc function
that uses vmalloc_exec()?

	Arnd
