Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752483Ab0K2KMb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 05:12:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64907 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752477Ab0K2KMa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 05:12:30 -0500
Subject: Re: [PATCH] Built kernel without -O2 option
From: Mark Wielaard <mjw@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Hui Zhu <teawater@gmail.com>, linux-kernel@vger.kernel.org,
        gdb@sourceware.org, hellogcc@freelists.org
In-Reply-To: <87r5e4lab7.fsf@basil.nowhere.org>
References: <AANLkTimewZ4QhxzL2vOYYV85pegy8Fu6Rb4XUAPqGUXS@mail.gmail.com>
	 <87r5e4lab7.fsf@basil.nowhere.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Nov 2010 11:12:16 +0100
Message-ID: <1291025536.2904.6.camel@springer.wildebeest.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-29 at 10:59 +0100, Andi Kleen wrote:
> Hui Zhu <teawater@gmail.com> writes:
> 
> > Now, there are a lot of ways to debug the Linux kernel with GDB, like
> > qemu, kgtp or kgdb and so on.
> > But the developer more like add a printk. It have a lot of reason, a big one is:
> > (gdb) p ret
> > $3 = <value optimized out>
> > And the code execution order is not right.
> 
> Really the right place to fix a lot of this would be gcc (and perhaps
> gdb). I suspect with some careful work the debugging experience
> for -O2 could be improved a lot.
> I also believe the latest gccs already have improvements in this area.

The VTA branch was merged for GCC 4.5
http://gcc.gnu.org/wiki/Var_Tracking_Assignments
Which helps a lot with generating dwarf for previously "optimized out"
values. There were also a couple of papers on generating even better
debuginfo at the recent GCC Summit: http://gcc.gnu.org/wiki/summit2010

Jakub Jelínek, Improving debug info for optimized away parameters
http://gcc.gnu.org/wiki/summit2010?action=AttachFile&do=get&target=jelinek.pdf
Alexandre Oliva, Consistent Views at Recommended Breakpoints
http://gcc.gnu.org/wiki/summit2010?action=AttachFile&do=get&target=oliva.pdf

Cheers,

Mark

