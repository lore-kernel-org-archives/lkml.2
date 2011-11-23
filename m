Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739Ab1KWMHu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 07:07:50 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:43210 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754674Ab1KWMHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 07:07:46 -0500
MIME-Version: 1.0
In-Reply-To: <CPSMTPM-CMT101y332G000633f8@CPSMTPM-CMT101.kpnxchange.com>
References: <CPSMTPM-CMT101y332G000633f8@CPSMTPM-CMT101.kpnxchange.com>
Date: Wed, 23 Nov 2011 20:07:39 +0800
Message-ID: <CAM_iQpVRzFtNOG8Y0nD3=Kw=N0-XcKVGdMd7sOWsgkdmt3jy9w@mail.gmail.com>
Subject: Re: Fast memcpy patch
From: Cong Wang <xiyou.wangcong@gmail.com>
To: "N. Coesel" <nico@nctdev.nl>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 23, 2011 at 7:25 PM, N. Coesel <nico@nctdev.nl> wrote:
> Dear readers,
> I noticed the Linux kernel still uses a byte-by-byte copy method for memcpy.
> Since most memory allocations are aligned to the integer size of a cpu it is
> often faster to copy by using the CPU's native word size. The patch below
> does that. The code is already at work in many 16 and 32 bit embedded
> products. It should also work for 64 bit platforms. So far I only tested 16
> and 32 bit platforms.

Which arch are you referring?

At least on x86, it has optimized memcpy(), see arch/x86/lib/memcpy_32.c
and arch/x86/include/asm/string_64.h.
