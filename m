Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178Ab2ALPyP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 10:54:15 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:42532 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753872Ab2ALPyL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 10:54:11 -0500
MIME-Version: 1.0
In-Reply-To: <20120111011146.GA30428@oksana.dev.rtsoft.ru>
References: <20120111011146.GA30428@oksana.dev.rtsoft.ru>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 12 Jan 2012 07:53:49 -0800
Message-ID: <CALCETrXKg9rSqi2RTQTa4Fpze0cP76HXD9BQor4ohW587ey3XA@mail.gmail.com>
Subject: Re: [PATCH] x86: Get rid of 'dubious one-bit signed bitfield' sprase warning
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org,
        Dan Carpenter <error27@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 10, 2012 at 5:11 PM, Anton Vorontsov <cbouatmailru@gmail.com> wrote:
> This very noisy sparse warning appears on almost every file in the
> kernel:
>
>  CHECK   init/main.c
> arch/x86/include/asm/thread_info.h:43:55: error: dubious one-bit signed bitfield
> arch/x86/include/asm/thread_info.h:44:46: error: dubious one-bit signed bitfield
>
> This patch changes sig_on_uaccess_error and uaccess_err flags to unsigned
> type and thus fixes the warning.
>
> Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>
> ---

Acked-by: Andy Lutomirski <luto@mit.edu>

This structure isn't used by userspace (or not usefully, anyway --
it's not at all stable across releases).

--Andy
