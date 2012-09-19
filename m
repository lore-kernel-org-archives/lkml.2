Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753083Ab2ISLNe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 07:13:34 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:55745 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752654Ab2ISLNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 07:13:33 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v2] compat: fs: Generic compat_sys_sendfile implementation
Date: Wed, 19 Sep 2012 11:13:26 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>
References: <1348052512-15538-1-git-send-email-catalin.marinas@arm.com>
In-Reply-To: <1348052512-15538-1-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201209191113.26929.arnd@arndb.de>
X-Provags-ID: V02:K0:fXvn7f5mLtnrb9HZQravs/OBZ4x5VkqlR3CfkUvevw0
 IGEbkWPGU8Mk+GaT0G2HERGy1RvmqeA5KApTj7mCjWFfDgg3D5
 hxheb32p/Ml0R7J277kGXEfNnBvhziCQX6K5GCtq6hrBoq5K9J
 PMT/TlEgst8l1gFXGHdkdYYbAocf+bTftakINMidY18j1YUjxg
 ZUf086VNgZjImSRQHupr/z5tLTIZUnjRQYnotjx3decqkCr2Bk
 qkz3Mp0jlqCCt0teXYiKmsgq2m+VhQc35mQhtOZn81xQdjQ7Re
 PLhEexTcWfPnVqDW0a8xWbHADSYHY1Cyf/7ZhI+MetzL5guSwB
 pDoQWcawYGP9WvTB7n1Q=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 19 September 2012, Catalin Marinas wrote:
> 
> This function is used by sparc, powerpc and arm64 for compat support.
> The patch adds a generic implementation which calls do_sendfile()
> directly and avoids set_fs().
> 
> The sparc architecture has wrappers for the sign extensions while
> powerpc relies on the compiler to do the this. The patch adds wrappers
> for powerpc to handle the u32->int type conversion.
> 
> compat_sys_sendfile64() can be replaced by a sys_sendfile() call since
> compat_loff_t has the same size as off_t on a 64-bit system.
> 
> On powerpc, the patch also changes the 64-bit sendfile call from
> sys_sendile64 to sys_sendfile.
> 
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Acked-by: David S. Miller <davem@davemloft.net>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: Andrew Morton <akpm@linux-foundation.org>

Acked-by: Arnd Bergmann <arnd@arndb.de>
