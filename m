Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753825Ab0IDPEi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 11:04:38 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55730 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753696Ab0IDPEh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 11:04:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=nV72Zpnd6sHsLfRWjFmU0O10ZNR0EMWz4+C3Rh9kgOEGnzXdBTKrlUYROTaYJLO8Cx
         gu5ODMtreYiQb8iF36HlVc21l7ONkPYoKjXtwSxBctKAHeLZBPBnuXayA1TJEWwdx4CP
         dBwGeFpxY8Qe/7GezkF2LFQMSgSFGFr2kjJgw=
MIME-Version: 1.0
In-Reply-To: <20100904051138.GC10118@redhat.com>
References: <AANLkTimjO7sBzR55XkPB7dmZvxXqc8PS4UDsgptXVt90@mail.gmail.com>
 <1283504768.2100.43.camel@steven> <y0md3suzzuj.fsf@fche.csb>
 <AANLkTi=V13SpXeMzmnCWvh-ooAgnVP8kA5UsBsm89YDr@mail.gmail.com> <20100904051138.GC10118@redhat.com>
From: Hui Zhu <teawater@gmail.com>
Date: Sat, 4 Sep 2010 23:04:16 +0800
Message-ID: <AANLkTinE9bpTpKzh_T83z1zmHz2PofcZNcuymeiZ+gAy@mail.gmail.com>
Subject: Re: Linux Kernel GDB tracepoint module 2010-8-30 release
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Steven <mqyoung@gmail.com>, "gdb@sourceware.org" <gdb@sourceware.org>,
        linux-kernel@vger.kernel.org, Michael Snyder <msnyder@vmware.com>,
        Marc Khouzam <marc.khouzam@ericsson.com>,
        Thiago Jung Bauermann <thiago.bauermann@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frank,

I met a issue with build systemtap.  Build it need (install
elfutils-devel, libebl-dev, libdw-dev and/or libebl-devel), but ubuntu
looks don't have it.

I try to build elfutils-0.148 with myself, but after I install it,
when I compile other code, I got:
/usr/local/bin/ld: /usr/lib/libelf.so.1: version `ELFUTILS_1.5' not
found (required by /usr/local/bin/ld)
collect2: ld returned 1 exit status
It really scared me.

Did you meet this issue in before?

Thanks,
Hui

On Sat, Sep 4, 2010 at 13:11, Frank Ch. Eigler <fche@redhat.com> wrote:
> Hi -
>
> On Sat, Sep 04, 2010 at 12:29:56PM +0800, Hui Zhu wrote:
>
>> [...] Could you talk about how it do call stack dump like following?
>> (gdb) trace vfs_readdir
>> Tracepoint 1 at 0xffffffff8113f7fc: file
>> /home/teawater/kernel/linux-2.6/fs/readdir.c, line 24.
>> (gdb) actions
>> >collect *(unsigned char *)$rsp@512
>
> probe kernel.function("vfs_readdir") {
>   // if you want the whole kernel-side backtrace, dwarf-unwound
>   print_backtrace()
>   // or else just hex-dump a region
>   printf("%*M\n", 512, register("rsp"))
> }
>
>
>> BTW, I was not find out which ARCH of the systemtap support in its
>> website?  It support all the arch that kprobe support?
>
> Yes, basically, though it's mostly tested on RHELy platforms (x86,
> powerpc, s390, ia64).
>
> - FChE
>
