Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362Ab0FHFsL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 01:48:11 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:35943 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958Ab0FHFsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 01:48:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=V6xeiMpeTHLPc7C15ryBCpC6sOY9/qnUBqcsH1y1tMSd9oZmxsncD2o2cJmQlA2HLf
         QyDeCPSGfWsvzV0oZvFFitbb3PRGei2v4Y+Z+99aADbL7bguULI9KsKjWrCtyhdIj9lX
         TTEfSrbC150EC6TcUnPXXiC489oLH82DSpEI8=
Date: Tue, 8 Jun 2010 13:51:52 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Alan <alan@clueserver.org>
Cc: Michal Marek <mmarek@suse.cz>,
       =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Additional info on modpost segfault
Message-ID: <20100608055152.GA7110@cr0.nay.redhat.com>
References: <Pine.LNX.4.64.1006032008220.30918@blackbox.fnordora.org>
 <20100604045118.GC5167@cr0.nay.redhat.com>
 <4C08A9D0.8000505@suse.cz>
 <1275929979.2923.0.camel@zowie.clueserver.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1275929979.2923.0.camel@zowie.clueserver.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 07, 2010 at 09:59:39AM -0700, Alan wrote:
>On Fri, 2010-06-04 at 09:22 +0200, Michal Marek wrote: 
>> On 4.6.2010 06:51, Américo Wang wrote:
>> > On Thu, Jun 03, 2010 at 08:10:30PM -0700, alan wrote:
>> >> Missed adding the actual segfault message:
>> >>
>> >>  LD      drivers/usb/built-in.o
>> >>  LD      drivers/built-in.o
>> >>  LD      vmlinux.o
>> >>  MODPOST vmlinux.o
>> >> /bin/sh: line 1: 20665 Segmentation fault      (core dumped)
>> >> scripts/mod/modpost -o
>> >> /home/alan/GitTrees/linux-2.6-mid-ref/Module.symvers -S vmlinux.o
>> >> make[1]: *** [vmlinux.o] Error 139
>> >> make: *** [vmlinux.o] Error 2
>> >>
>> >> I have looked at the gcc 4.4.4 changelog and I can't see anything
>> >> that should cause this.
>> >>
>> > 
>> > Hmm, you need to find which program segfaults here.
>> 
>> It's the modpost command run on vmlinux.o. Alan, can you try
>> $ gdb --args scripts/mod/modpost -o Module.symvers -S vmlinux.o
>> (gdb) r
>> (wait for the segfault)
>> (gdb) bt full
>> 
>> and post the backtrace?
>
>Don't know if this will help much.
>
>This GDB was configured as "x86_64-redhat-linux-gnu".
>For bug reporting instructions, please see:
><http://www.gnu.org/software/gdb/bugs/>...
>Reading symbols
>from /home/alan/GitTrees/linux-2.6-mid-ref/scripts/mod/modpost...(no
>debugging symbols found)...done.
>(gdb) r
>Starting
>program: /home/alan/GitTrees/linux-2.6-mid-ref/scripts/mod/modpost -o
>Module.symvers -S vmlinux.o
>
>Program received signal SIGSEGV, Segmentation fault.
>0x0000000000403711 in main ()
>(gdb) bt full
>#0  0x0000000000403711 in main ()
>No symbol table info available.
>
>Trying to get it to compile with debugging info.
>

Try to append "-g" to HOSTCFLAGS in the top Makefile. ;)

