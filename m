Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751798Ab0IDFLu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 01:11:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54822 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750772Ab0IDFLt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 01:11:49 -0400
Date: Sat, 4 Sep 2010 01:11:38 -0400
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Hui Zhu <teawater@gmail.com>
Cc: Steven <mqyoung@gmail.com>, "gdb@sourceware.org" <gdb@sourceware.org>,
        linux-kernel@vger.kernel.org, Michael Snyder <msnyder@vmware.com>,
        Marc Khouzam <marc.khouzam@ericsson.com>,
        Thiago Jung Bauermann <thiago.bauermann@gmail.com>
Subject: Re: Linux Kernel GDB tracepoint module 2010-8-30 release
Message-ID: <20100904051138.GC10118@redhat.com>
References: <AANLkTimjO7sBzR55XkPB7dmZvxXqc8PS4UDsgptXVt90@mail.gmail.com> <1283504768.2100.43.camel@steven> <y0md3suzzuj.fsf@fche.csb> <AANLkTi=V13SpXeMzmnCWvh-ooAgnVP8kA5UsBsm89YDr@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=V13SpXeMzmnCWvh-ooAgnVP8kA5UsBsm89YDr@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

On Sat, Sep 04, 2010 at 12:29:56PM +0800, Hui Zhu wrote:

> [...] Could you talk about how it do call stack dump like following?
> (gdb) trace vfs_readdir
> Tracepoint 1 at 0xffffffff8113f7fc: file
> /home/teawater/kernel/linux-2.6/fs/readdir.c, line 24.
> (gdb) actions
> >collect *(unsigned char *)$rsp@512

probe kernel.function("vfs_readdir") {
   // if you want the whole kernel-side backtrace, dwarf-unwound
   print_backtrace() 
   // or else just hex-dump a region
   printf("%*M\n", 512, register("rsp"))
}


> BTW, I was not find out which ARCH of the systemtap support in its
> website?  It support all the arch that kprobe support?

Yes, basically, though it's mostly tested on RHELy platforms (x86,
powerpc, s390, ia64).

- FChE
