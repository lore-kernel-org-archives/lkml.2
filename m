Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752264Ab2EHItT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 04:49:19 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:37491 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752131Ab2EHItQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 04:49:16 -0400
MIME-Version: 1.0
In-Reply-To: <1336004953.4240.9.camel@mop>
References: <1336004953.4240.9.camel@mop>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Tue, 8 May 2012 10:48:55 +0200
Message-ID: <CA+1xoqdCk9FcqdLEvwgHtfrauNh=s0dDwcpaJimMC_H83N=_5w@mail.gmail.com>
Subject: Re: [PATCH RESEND 1/3] printk: convert byte-buffer to variable-length
 record buffer
To: Kay Sievers <kay@vrfy.org>
Cc: Greg Kroah-Hartmann <greg@kroah.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kay,

On Thu, May 3, 2012 at 2:29 AM, Kay Sievers <kay@vrfy.org> wrote:
> From: Kay Sievers <kay@vrfy.org>
> Subject: printk: convert byte-buffer to variable-length record buffer

This patch was included in today's linux-next, and it looks like it
broke printk on my configuration.

It's a bit hard to describe exactly what's wrong, but here are the main points:

1. PRINTK_TIME timing information is gone.
2. Newline issues. It appears to be adding newlines where it
shouldn't. For example:

Before:
[   10.110626] parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]

After:
parport0: PC-style at 0x378
, irq 7
 [
PCSPP
,TRISTATE
]

3. Things are not properly aligned, such as stack traces.
