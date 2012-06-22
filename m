Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932423Ab2FVJdh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 05:33:37 -0400
Received: from mail-yw0-f51.google.com ([209.85.213.51]:47134 "EHLO
	mail-yw0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758748Ab2FVJdg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 05:33:36 -0400
MIME-Version: 1.0
Date: Fri, 22 Jun 2012 12:33:35 +0300
Message-ID: <CAFub=KRdM2Mc1RXa_HfYO8gSxpyCpsP9Z1YHRULCLwNDnXQyEg@mail.gmail.com>
Subject: get_unused_fd and get_unused_fd_flags
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozancag@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, mcgrof@kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

With,

commit 1027abe8827b47f7e9c4ed6514fde3d44f79963c
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Wed Jul 30 04:13:04 2008 -0400

    [PATCH] merge locate_fd() and get_unused_fd()

        New primitive: alloc_fd(start, flags).  get_unused_fd() and
    get_unused_fd_flags() become wrappers on top of it.

    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Two wrappers get_unused_fd() and get_unused_fd_flags() are introduced.
get_unused_fd() is an exported one-liner:

int get_unused_fd(void)
{
        return alloc_fd(0, 0);
}
EXPORT_SYMBOL(get_unused_fd);

But get_unused_fd_flags() is implemented through a macro:

#define get_unused_fd_flags(flags) alloc_fd(0, (flags))

Both are wrappers around alloc_fd(). I'm quite new to this stuff but
why there's an asymmetry in here? One is exposed, the other is not.

(BTW: I'm doing compat-drm stuff for GSoC and I have to call
get_unused_fd_flags() but since alloc_fd() is not exported, this
doesn't work.)

Thanks :)

-- 
Ozan Çağlayan
