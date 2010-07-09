Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752899Ab0GIVed (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 17:34:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56679 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751622Ab0GIVec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 17:34:32 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTilPtW_hOG01qvQHBWMC4b0QJZ8SAL0bZi6j56ns@mail.gmail.com>
References: <AANLkTilPtW_hOG01qvQHBWMC4b0QJZ8SAL0bZi6j56ns@mail.gmail.com>
Date: Fri, 9 Jul 2010 14:33:38 -0700
Message-ID: <AANLkTilQ0w6EfbrXl5LklPJ46FMWQG6Q3W5twJY74RtE@mail.gmail.com>
Subject: Re: [2.6.35-rc3] select useful number of entries for DMA debugging...
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Daniel J Blueman <daniel.blueman@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 5, 2010 at 1:35 AM, Daniel J Blueman
<daniel.blueman@gmail.com> wrote:
> When booting 2.6.35-rc3 on some different x86 boxes with DMA debugging
> enabled, I've consistently seen it exhaust the allocated entries during
> boot, giving 'DMA-API: debugging out of memory - disabling'.
>
> Increase number of entries to allow DMA debugging again.

Rather than increase the default that gets allocated whenever anybody
enables the DMA debugging, I'd really prefer to see people use the
kernel command line option if they run out. After all, it's a (pretty
esoteric) debug option, and the number of required entries depends on
machine configuration. I'd rather not make the default cover a huge
number, when you could just add

   dma_debug_entries=65536

on the kernel boot command line instead for machines that want/need it..

                  Linus
