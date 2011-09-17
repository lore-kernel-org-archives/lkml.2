Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756071Ab1IQDTG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 23:19:06 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51029 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754296Ab1IQDTF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 23:19:05 -0400
MIME-Version: 1.0
In-Reply-To: <20110916200040.GA18566@flint.arm.linux.org.uk>
References: <1316190666-18905-1-git-send-email-tjlee@ambarella.com>
	<20110916200040.GA18566@flint.arm.linux.org.uk>
Date: Sat, 17 Sep 2011 11:19:02 +0800
Message-ID: <CAEvN+1ihRxe4g2wVErEWtg-VSw9dEL5R7YkufdGst5dEyzN8eQ@mail.gmail.com>
Subject: Re: [PATCH] ARM: tlb: Compile out MULTI_TLB specific code when
 MULTI_TLB is undefined
From: Tzu-Jung Lee <roylee17@gmail.com>
To: Russell King <rmk@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, Tzu-Jung Lee <tjlee@ambarella.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 17, 2011 at 4:00 AM, Russell King <rmk@arm.linux.org.uk> wrote:
> On Sat, Sep 17, 2011 at 12:31:06AM +0800, Tzu-Jung Lee wrote:
>> To eliminate the 'undefined cpu_tlb' errors when the kernel is built with -O0
>
> The kernel requires to be built with optimization in many places, and so
> this is an option we don't support.
>
> --
> Russell King
>  Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
>  maintainer of:
>

Hi Russell,

Indeed, this is only one of the places where we used to particularly
build with higher optimization level. More than often, we only disable
the optimization for interested object files with CFLAGS_foo.o += -g
-O0. While porting kernel to different platforms, however, failures at
the early booting stage usually makes low level
initialization(mm/tlb/cache/cpu...) become the objects that we want to
disable the optimization for the ease of diagnostic with source level
debugger. In this cases, patches to the source code become required to
get the -O0 work for them. Would you consider to have these patches
merged if they doesn't have side effect.

Thanks,
Roy
