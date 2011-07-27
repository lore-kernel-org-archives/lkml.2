Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753032Ab1G0Pao (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 11:30:44 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:17015 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962Ab1G0Pal convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 11:30:41 -0400
Date: Wed, 27 Jul 2011 11:30:15 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Andrew Lutomirski <luto@mit.edu>
Cc: x86@kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        jeremy@goop.org, keir.xen@gmail.com, xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 0/5] Collected vdso/vsyscall fixes for 3.1
Message-ID: <20110727153015.GA16688@dumpdata.com>
References: <cover.1311736366.git.luto@mit.edu>
 <20110727145745.GA11872@dumpdata.com>
 <CAObL_7FT8QLg-wihasBahhAtS=pA7+KeU8E=E9x8NPZ0+QJ5iQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <CAObL_7FT8QLg-wihasBahhAtS=pA7+KeU8E=E9x8NPZ0+QJ5iQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090205.4E302F16.00FA,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Anyhow, removed the benchmark code and ran it on 64-bit:
> >
> > sh-4.1# /test_vsyscall  test
> > Testing gettimeofday...
> > [  109.552261] test_vsyscall[2462] trap invalid opcode ip:400c8d sp:7fff84fab470 error:0 in test_vsyscall[400000+2000]
> > Illegal instruction
> > sh-4.1# /test_vsyscall  intcc
> > About to execute int 0xcc from RIP = 400959
> > [  114.137150] test_vsyscall[2463] illegal int 0xcc (exploit attempt?) ip:400959 cs:e033 sp:7fff8b328310 ax:2c si:0 di:7fff8b3280f0
> > Caught SIGSEGV: Segmentation fault (Signal sent by the kernel [(nil)])RIP = 400959
> >
> > [This is on git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git #testing, which
> > has todays linus/master and your patchset]
> >
> 
> I'll set up Xen.  Something's clearly still buggy.

You sure? This is what I get when I boot baremetal:

sh-4.1# 
sh-4.1# xen-detect 
Not running on Xen.
sh-4.1# /test_vsyscall test
Testing gettimeo[   84.442819] test_vsyscall[3175] trap invalid opcode ip:400c8d sp:7fffa8a72dc0 error:0fday...
 in test_vsyscall[400000+2000]
Illegal instruction
sh-4.1# /test_vsyscall intcc
About to execute[   87.549820] test_vsyscall[3176] illegal int 0xcc (exploit attempt?) ip:400959 cs:33 sp:7fff0ccddff0 ax:2c s^G^G^G^G^G^G^Gsh-4.1# 
sh-4.1# /test_vsyscall intcc
About to execute[   90.283817] test_vsyscall[3177] illegal int 0xcc (exploit attempt?) ip:400959 cs:33 sp:7fffae8a8b40 ax:2c son fault (Signal sent by the kernel [(nil)])RIP = 400959

Unless the whole paravirt kernel is buggy. Hadn't tried to boot non-paravirt.
