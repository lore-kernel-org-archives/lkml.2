Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505Ab2IWOTJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2012 10:19:09 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:64798 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177Ab2IWOTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2012 10:19:07 -0400
MIME-Version: 1.0
In-Reply-To: <1343971271-13355-3-git-send-email-linux@horizon.com>
References: <1343971271-13355-1-git-send-email-linux@horizon.com> <1343971271-13355-3-git-send-email-linux@horizon.com>
From: Rabin Vincent <rabin@rab.in>
Date: Sun, 23 Sep 2012 16:18:27 +0200
X-Google-Sender-Auth: 8WWHnQuaO4YymakQBgOTERZvnxw
Message-ID: <CAH+eYFBscQnH78CZFLq2GwTJZR1+zkUc6gL1QgnWNoFCQwRy2A@mail.gmail.com>
Subject: Re: [PATCH 3/4] lib: vsprintf: Optimize put_dec_trunc8
To: George Spelvin <linux@horizon.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: vda.linux@googlemail.com, mina86@mina86.com, hughd@google.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/8/3 George Spelvin <linux@horizon.com>:
> If you're going to have a conditional branch after
> each 32x32->64-bit multiply, might as well shrink the code
> and make it a loop.
>
> This also avoids using the long multiply for small integers.
>
> (This leaves the comments in a confusing state, but that's a separate
> patch to make review easier.)
>
> Signed-off-by: George Spelvin <linux@horizon.com>

This patch breaks IP address printing with "%pI4" (and by extension,
nfsroot).  Example:

 - Before: 10.0.0.1
 - After: 10...1
