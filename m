Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753629Ab1G0Per (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 11:34:47 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:65470 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115Ab1G0Peo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 11:34:44 -0400
MIME-Version: 1.0
In-Reply-To: <20110727153015.GA16688@dumpdata.com>
References: <cover.1311736366.git.luto@mit.edu> <20110727145745.GA11872@dumpdata.com>
 <CAObL_7FT8QLg-wihasBahhAtS=pA7+KeU8E=E9x8NPZ0+QJ5iQ@mail.gmail.com> <20110727153015.GA16688@dumpdata.com>
From: Andrew Lutomirski <luto@mit.edu>
Date: Wed, 27 Jul 2011 11:34:21 -0400
X-Google-Sender-Auth: lV2BCP9UH1HQTgN_oGeVwlezwJE
Message-ID: <CAObL_7GWGx4rYJFLpucEX=ozNpk+5ipyq0=vw16xcGetEXSuGQ@mail.gmail.com>
Subject: Re: [PATCH 0/5] Collected vdso/vsyscall fixes for 3.1
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: x86@kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        jeremy@goop.org, keir.xen@gmail.com, xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 27, 2011 at 11:30 AM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
>> > Anyhow, removed the benchmark code and ran it on 64-bit:
>> >
>> > sh-4.1# /test_vsyscall  test
>> > Testing gettimeofday...
>> > [  109.552261] test_vsyscall[2462] trap invalid opcode ip:400c8d sp:7fff84fab470 error:0 in test_vsyscall[400000+2000]
>> > Illegal instruction
>> > sh-4.1# /test_vsyscall  intcc
>> > About to execute int 0xcc from RIP = 400959
>> > [  114.137150] test_vsyscall[2463] illegal int 0xcc (exploit attempt?) ip:400959 cs:e033 sp:7fff8b328310 ax:2c si:0 di:7fff8b3280f0
>> > Caught SIGSEGV: Segmentation fault (Signal sent by the kernel [(nil)])RIP = 400959
>> >
>> > [This is on git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git #testing, which
>> > has todays linus/master and your patchset]
>> >
>>
>> I'll set up Xen.  Something's clearly still buggy.
>
> You sure? This is what I get when I boot baremetal:
>
> sh-4.1#
> sh-4.1# xen-detect
> Not running on Xen.
> sh-4.1# /test_vsyscall test
> Testing gettimeo[   84.442819] test_vsyscall[3175] trap invalid opcode ip:400c8d sp:7fffa8a72dc0 error:0fday...
>  in test_vsyscall[400000+2000]

$ test_vsyscall test
Testing gettimeofday...
  vDSO offset = 0.000001s
  vsyscall offset = 0.000001s

Testing time...
  vDSO offset = 0
  vsyscall offset = 0
Testing getcpu...
  ok!  cpu=6 node=0

Can you send me your test_vsyscall binary so I can disassemble it?

--Andy
