Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637Ab2KECe6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 21:34:58 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:54174 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384Ab2KECe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 21:34:56 -0500
Message-ID: <509725CA.4030809@igel.co.jp>
Date: Mon, 05 Nov 2012 11:34:50 +0900
From: Damian Hobson-Garcia <dhobsong@igel.co.jp>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: hjk@hansjkoch.de, gregkh@linuxfoundation.org, magnus.damm@gmail.com,
        horms@verge.net.au, linux-kernel@vger.kernel.org,
        linux-sh@vger.kernel.org, hdk@igel.co.jp,
        Linux-Next <linux-next@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Subject: Re: [v2 PATCH 1/2] Add new uio device for dynamic memory allocation
References: <1348553352-14334-1-git-send-email-dhobsong@igel.co.jp> <1348553352-14334-2-git-send-email-dhobsong@igel.co.jp> <CAMuHMdWKByLXR-2wkiej=F1WPf7xePf3nMkUqwSf_hEJNNZbvg@mail.gmail.com>
In-Reply-To: <CAMuHMdWKByLXR-2wkiej=F1WPf7xePf3nMkUqwSf_hEJNNZbvg@mail.gmail.com>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

On 2012/11/04 22:20, Geert Uytterhoeven wrote:
> On Tue, Sep 25, 2012 at 8:09 AM, Damian Hobson-Garcia
> <dhobsong@igel.co.jp> wrote:
>> are holding the device file open, the address returned to userspace is
>> DMA_ERROR_CODE.
> 
> Only a small subset of the architectures
> (arm/ia64/microblaze/openrisc/powerpc/sparc/x86)
> seem to define DMA_ERROR_CODE, causing everywhere else:
> 
> drivers/uio/uio_dmem_genirq.c: In function ‘uio_dmem_genirq_release’:
> drivers/uio/uio_dmem_genirq.c:95: error: ‘DMA_ERROR_CODE’ undeclared
> (first use in this function)
> drivers/uio/uio_dmem_genirq.c:95: error: (Each undeclared identifier
> is reported only once
> drivers/uio/uio_dmem_genirq.c:95: error: for each function it appears in.)
> drivers/uio/uio_dmem_genirq.c: In function ‘uio_dmem_genirq_probe’:
> drivers/uio/uio_dmem_genirq.c:238: error: ‘DMA_ERROR_CODE’ undeclared
> (first use in this function)
> make[1]: *** [drivers/uio/uio_dmem_genirq.o] Error 1
> make: *** [drivers/uio/] Error 2
> 
> (e.g. http://kisskb.ellerman.id.au/kisskb/buildresult/7462173/)
> 
> Furthermore, none of them define it in <uapi/...>, so DMA_ERROR_CODE is not
> part of the userspace API (yet), while it is architecture-specific (some use 0,
> others ~0).
> 
Good points, thank you.  In that case, does fixing the value to
something like ~0 sound like a better (more portable) solution?

Damian

-- 
Damian Hobson-Garcia
IGEL Co.,Ltd
http://www.igel.co.jp
