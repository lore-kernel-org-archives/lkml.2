Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932131Ab0G3Ijv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 04:39:51 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:47004 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932099Ab0G3Ijt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 04:39:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=SCjmnA6WefJeq+NCXMoib4bjn9UndGgrrWn1ScBRGKNaFn7MLunKsGKbXtEI28Fkyh
         ifp1Vso8qYidkhOqwGquf0ferCJuXMekUCOrWxR+yFa5hh9Ynkcoz6c7cDF+DzHJstOz
         WtsO2WkWcWlRwO/ZYgl4CKzcur5iC8KojnWD8=
Date: Fri, 30 Jul 2010 16:43:53 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Christoph Egger <siccegge@cs.fau.de>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Bus error on make allyesconfig, kernelbuild with HEAD
Message-ID: <20100730084353.GB5638@cr0.nay.redhat.com>
References: <20100729105225.GA13192@faui48a.informatik.uni-erlangen.de>
 <AANLkTi=cYgV69VyNZ+TKs_f-+3AJmyo_RaYS57R72j50@mail.gmail.com>
 <20100729121002.GC13192@faui48a.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100729121002.GC13192@faui48a.informatik.uni-erlangen.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 29, 2010 at 02:10:02PM +0200, Christoph Egger wrote:
>On Thu, Jul 29, 2010 at 07:26:00PM +0800, Américo Wang wrote:
>> On Thu, Jul 29, 2010 at 6:52 PM, Christoph Egger <siccegge@cs.fau.de> wrote:
>> > Hi all!
>> >
>> >    Building the linux kernel, as well as doing a"make allyesconfig"
>> > on a fresh checkout of linux HEAD results in the same Bus Error in
>> > fixdep (details below). This is a i5 box running 32bit Ubuntu Lucid
>> > with plenty of (free) RAM. Haven't found any hints to what might be
>> > wrong on scanning over the web archives.
>> >
>> > Regards
>> >
>> >    Christoph
>> >
>> > -----
>> >  % make allyesconfig
>> >  HOSTCC  scripts/basic/fixdep
>> > fixdep: mmap: Cannot allocate memory
>> 
>> So what does 'ls -lh scripts/basic/.fixdep.d' say?
>> Seems this file is too big...
>
>Also I don't get the mmap stuff if I call fixdep directly (the way I
>think it is called staring at the build system) -- it still dies with
>an bus error:
>
>=======
>% scripts/basic/fixdep scripts/basic/.fixdep.d scripts/basic/fixdep "gcc -Wp,-MD,scripts/basic/.fixdep.d -Wall -Wmissing-prototypes -Wstrict-prototypes -O2 -fomit-frame-pointer     -o  scripts/basic/fixdep scripts/basic/fixdep.c" 
>cmd_scripts/basic/fixdep := gcc -Wp,-MD,scripts/basic/.fixdep.d -Wall  -Wmissing-prototypes -Wstrict-prototypes -O2 -fomit-frame-pointer  -o scripts/basic/fixdep scripts/basic/fixdep.c
>
>deps_scripts/basic/fixdep := \
>  scripts/basic/fixdep.c \
>    $(wildcard include/config/his/driver.h) \
>    $(wildcard include/config/my/option.h) \
>    $(wildcard include/config/.h) \
>    $(wildcard include/config/foo.h) \
>    $(wildcard include/config/boom.h) \
>zsh: bus error  scripts/basic/fixdep scripts/basic/.fixdep.d  scripts/basic/fixdep
>=======
>
>gdb isn't of any use for that unfortunately
>
>valgrund:
>=======
>==11601== Process terminating with default action of signal 7 (SIGBUS)
>==11601==  Non-existent physical address at address 0x64F2B000
>==11601==    at 0x8048BF0: parse_dep_file (in /var/tmp/siccegge/letssee/scripts/basic/fixdep)
>=======

This is useful. :) Looks like parse_dep_file() accesses out of
the mmap'ed memory range...

Please attach your scripts/basic/.fixdep.d. Thanks much!
