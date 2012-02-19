Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372Ab2BSVRp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 16:17:45 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:40784 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755259Ab2BSVRo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 16:17:44 -0500
MIME-Version: 1.0
In-Reply-To: <CALyraeMK=bEVkBtbi8xAm5aWrCbjGMTkArHygG78tJ86TzzNOw@mail.gmail.com>
References: <CALyraeMK=bEVkBtbi8xAm5aWrCbjGMTkArHygG78tJ86TzzNOw@mail.gmail.com>
Date: Sun, 19 Feb 2012 16:17:43 -0500
Message-ID: <CALyraePxucQS2YvPc=+D+W6kX0sbY-C1ZsYZ+K6Q2QhuHaZvLQ@mail.gmail.com>
Subject: Re: Buildroot compilation error
From: Sri Ram Vemulpali <sri.ram.gmu06@gmail.com>
To: linux-kernel-mail <linux-kernel@vger.kernel.org>,
        linux-newbie@vger.kernel.org
Cc: dhylands@gmail.com
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

found solution by doing this.

I added following lines of code in
libnl-3.0/lib/route/pktloc_grammer.h

#ifndef YY_BUF_SIZE
#define YY_BUF_SIZE 16384
#endif

#ifndef YY_STATE_BUF_SIZE
#define YY_STATE_BUF_SIZE ((YY_BUF_SIZE + 2) * sizeof(yy_state_type))
#endif

Thanks,
Sri

On 2/19/12, Sri Ram Vemulpali <sri.ram.gmu06@gmail.com> wrote:
> Hello All,
>
> I am using BuildRoot to compile my embedded linux and tool-chain.
> After compiling most of the packages and tool-chain I am getting
> following error. This occurs when compiling libnl-3.0
>
> make[3]: Entering directory
> `/home/sriram/buildroot/buildroot-2011.11/output/build/libnl-3.0/lib'
>   CC     route/pktloc.lo
>
> route/pktloc.c: In function ‘read_pktlocs’:
> route/pktloc.c:127:34: error: ‘YY_BUF_SIZE’ undeclared (first use in
> this function)
> route/pktloc.c:127:34: note: each undeclared identifier is reported
> only once for each function it appears in
> make[3]: *** [route/pktloc.lo] Error 1
> make[3]: Leaving directory
> `/home/sriram/buildroot/buildroot-2011.11/output/build/libnl-3.0/lib'
> make[2]: *** [all] Error 2
> make[2]: Leaving directory
> `/home/sriram/buildroot/buildroot-2011.11/output/build/libnl-3.0/lib'
> make[1]: *** [all-recursive] Error 1
> make[1]: Leaving directory
> `/home/sriram/buildroot/buildroot-2011.11/output/build/libnl-3.0'
> make: ***
> [/home/sriram/buildroot/buildroot-2011.11/output/build/libnl-3.0/.stamp_built]
> Error 2
>
> Can anyone please help me what is going on in compilation. Do I need
> to specify sysroot or path to lib.
> Thanks in advance for the help.
>
>
>
> --
> Regards,
> Sri.
>


-- 
Regards,
Sri.
