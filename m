Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589Ab2JOOC3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 10:02:29 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:10401 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753337Ab2JOOC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 10:02:27 -0400
X-AuditID: cbfee61b-b7fd46d0000046e0-1a-507c1772e6a6
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Russell King'" <linux@arm.linux.org.uk>
Cc: "'Mike Turquette'" <mturquette@linaro.org>,
        "'Ben Dooks'" <ben-linux@fluff.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <201210121114.52348.arnd@arndb.de>
In-reply-to: <201210121114.52348.arnd@arndb.de>
Subject: RE: [PATCH] ARM: s3c: mark s3c2440_clk_add as __init_refok
Date: Mon, 15 Oct 2012 23:02:25 +0900
Message-id: <10dc01cdaadd$b4a32ee0$1de98ca0$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2oatBmN1ZhoVkCTIWrJ+CKtwR8KgCcqyiA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLLMWRmVeSWpSXmKPExsVy+t9jAd0i8ZoAg0mTBC0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfG6ecNzAVXeCp2T3rE3sC4lauLkZNDQsBEYvOyvcwQtpjEhXvr
	2boYuTiEBBYxSsx6P50JwpnHJPGyrYMRpIpNQEPi8Ptn7CC2iICPxLsfH1hBipgFpjNKtMxf
	CDZKSEBPYvGyFqBRHBycAvoSS487gYSFBZwl+jcsZQGxWQRUJd4t/Qtm8wrYStw+vowVwhaU
	+DH5HlicWUBLYv3O40wQtrzE5jVvmUFGSgioSzz6qwtxgpHE5nl32SBKRCT2vXjHOIFRaBaS
	SbOQTJqFZNIsJC0LGFlWMYqmFiQXFCel5xrpFSfmFpfmpesl5+duYgQH8jPpHYyrGiwOMQpw
	MCrx8P70qg4QYk0sK67MPcQowcGsJML77BFQiDclsbIqtSg/vqg0J7X4EKM0B4uSOG+zR0qA
	kEB6YklqdmpqQWoRTJaJg1OqgbHQYf6lgnqn8L8bmf3fTTjR1nlCcOddm4pz5Vk88fN115uu
	ton5WOnVn6O2cYbG5+tPjl5vKLuerrc9PXR/9oXKhZn/q04vD9KT37kg7PG8rUeePPD9Z1/K
	ttCNp0BO+NSNT8Yf/nw72MJnqW1+oWTXFsd5gVfmvbTl3P17W+U3G/u9jGmxBXeVWIozEg21
	mIuKEwFeomb1YAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> 
> s3c2440_clk_add is a subsys_interface method and calls clkdev_add_table,
> which is marked as __init. The modpost script complains about this
> because we must not call an __init function from a function in the .text
> section, and we cannot reference an __init function from a
> subsys_interface
> pointer.
> 
> I have verified that the only code path into s3c2440_clk_add() is
> from "int __init s3c2440_init(void)", so s3c2440_clk_add can be marked
> __init_refok instead.
> 
> Without this patch, building mini2440_defconfig results in:
> 
> WARNING: vmlinux.o(.text+0x9848): Section mismatch in reference from the
> function s3c2440_clk_add() to the function .init.text:clkdev_add_table()
> The function s3c2440_clk_add() references
> the function __init clkdev_add_table().
> This is often because s3c2440_clk_add lacks a __init
> annotation or the annotation of clkdev_add_table is wrong.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Mike Turquette <mturquette@linaro.org>
> Cc: Kukjin Kim <kgene.kim@samsung.com>

Acked-by: Kukjin Kim <kgene.kim@samsung.com>

> Cc: Ben Dooks <ben-linux@fluff.org>
> ---
> 
> I'll put this into arm-soc/fixes unless I hear objections. This replaces
> the
> earlier "clk: don't mark clkdev_add_table as init" as suggested by
Russell.
> 
Yeah, I read it just now and I agree with this patch.

Thanks for your fix.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

