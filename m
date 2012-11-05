Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933376Ab2KEW3q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 17:29:46 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55700 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933161Ab2KEW3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 17:29:45 -0500
Date: Mon, 5 Nov 2012 14:29:44 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Jan Beulich" <JBeulich@suse.com>
Cc: <rusty@rustcorp.com.au>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] utilize _Static_assert() for BUILD_BUG_ON() when the
 compiler supports it
Message-Id: <20121105142944.7b16e6a4.akpm@linux-foundation.org>
In-Reply-To: <5093EB1C02000078000A61D7@nat28.tlf.novell.com>
References: <5093EB1C02000078000A61D7@nat28.tlf.novell.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 02 Nov 2012 14:47:40 +0000
"Jan Beulich" <JBeulich@suse.com> wrote:

> This makes the resulting diagnostics quite a bit more useful.

So asserts Jan, but to confirm it I would need to download, configure,
build and install a different gcc version, which sounds rather a hassle.

So, please show us an exmple of these diagnostics in the changelog.

> --- 3.7-rc3/include/linux/bug.h
> +++ 3.7-rc3-static-assert/include/linux/bug.h
> @@ -27,8 +27,15 @@ struct pt_regs;
>     result (of value 0 and type size_t), so the expression can be used
>     e.g. in a structure initializer (or where-ever else comma expressions
>     aren't permitted). */
> +#if __GNUC__ > 4 || (__GNUC__ == 4 && __GNUC_MINOR__ >= 6)

This sort of logic is normally performed via the
include/linux/compiler*.h system.  And

	grep __GNUC include/linux/*.h

indicates that we've been pretty successful.  Can we do that here too?

(eg: suppose the Intel compiler supports _Static_assert?)

