Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747Ab2IRUHH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 16:07:07 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:46576 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754583Ab2IRUHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 16:07:06 -0400
Date: Tue, 18 Sep 2012 16:06:59 -0400 (EDT)
Message-Id: <20120918.160659.160077660315513625.davem@davemloft.net>
To: catalin.marinas@arm.com
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de,
        benh@kernel.crashing.org, paulus@samba.org, viro@zeniv.linux.org.uk,
        akpm@linux-foundation.org
Subject: Re: [PATCH] compat: fs: Generic compat_sys_sendfile implementation
From: David Miller <davem@davemloft.net>
In-Reply-To: <1347987727-13739-1-git-send-email-catalin.marinas@arm.com>
References: <1347987727-13739-1-git-send-email-catalin.marinas@arm.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Catalin Marinas <catalin.marinas@arm.com>
Date: Tue, 18 Sep 2012 18:02:06 +0100

> This function is used by sparc, powerpc and arm64 for compat support.
> The patch adds a generic implementation which calls do_sendfile()
> directly and avoids set_fs().
> 
> The sparc architecture has wrappers for the sign extensions while
> powerpc relies on the compiler to do the this. The patch adds a wrapper
> for powerpc to handle the u32->int type conversion.
> 
> compat_sys_sendfile64() can be replaced by a sys_sendfile() call since
> compat_loff_t has the same size as off_t on a 64-bit system. On powerpc,
> similar wrapper needs to be added for the u32->int conversion.
> 
> The reason for a single patch covering both powerpc and sparc is to keep
> it bisectable (and simple), otherwise kernel building may fail with
> mismatched function declarations.
> 
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>

Acked-by: David S. Miller <davem@davemloft.net>
