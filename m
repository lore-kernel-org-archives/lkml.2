Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152Ab1EEVMQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 17:12:16 -0400
Received: from zfrontend1.aha.ru ([195.2.83.147]:45248 "EHLO aha.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751714Ab1EEVMP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 17:12:15 -0400
From: "werner" <w.landgraf@ru.ru>
Subject: Re: [block IO crash] Re: 2.6.39-rc5-git2 boot crashs
To: Christoph Lameter <cl@linux.com>, Tejun Heo <tj@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
X-Mailer: CommuniGate Pro WebUser Interface v.4.3.12
Date: Thu, 05 May 2011 17:12:10 -0400
Message-ID: <web-518814410@zbackend1.aha.ru>
In-Reply-To: <alpine.DEB.2.00.1105051504250.8529@router.home>
References: <BANLkTimdL_tAONUWxZ4sQn1AiPDdbdYqpw@mail.gmail.com>
 <BANLkTinLn-59oisLrvwyCvyUuNyDKVHP0g@mail.gmail.com>
 <alpine.DEB.2.00.1105041341550.5495@router.home>
 <BANLkTikEgDGt+KrBsZcinKVom5E63Ma6gg@mail.gmail.com>
 <alpine.DEB.2.00.1105041421280.5495@router.home>
 <BANLkTi=efcVkGb+DReZ+i1p5j4QXJYjKjQ@mail.gmail.com>
 <alpine.DEB.2.00.1105041454190.5495@router.home>
 <BANLkTik7AHGr7+BG8nE16j-ayctD0LOH=w@mail.gmail.com>
 <BANLkTimvxOMuPJ0W0npo5i3gwFqdRw74Pw@mail.gmail.com>
 <alpine.LFD.2.02.1105042325500.3005@ionos>
 <20110505095421.GD30950@htj.dyndns.org>
 <web-518794926@zbackend1.aha.ru>
 <alpine.DEB.2.00.1105051504250.8529@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 May 2011 15:09:04 -0500 (CDT)
  Christoph Lameter <cl@linux.com> wrote:
> On Thu, 5 May 2011, werner wrote:
> 
>>    As the 1st step, for can be compiled generic kernels 
>>at all, the kernel
>> should have (and has) the ability, to discover at 
>>run-time , what hardware the
>> individual user has, and to use only the corresponding 
>>kernel subroutines.
>> F.ex. if subroutines for ELAN or MOORESTON were compiled 
>>also, then the kernel
>> ignore them simply, if on run-time it discovers that the 
>>user has a 486
>> computer.
> 
> Yes indeed the kernel can detect that. And the code has 
>fallback for
> the case that the processor flags indicate that 
>cmpxchg16b is not supported.
> 
> However, in this case the kernel configuration at build 
>time was set in
> such a way (!CMPXCHG64 support but CMPXCHG_LOCAL) that 
>generic fallback
> functions were used at compile time instead of the x86 
>assembly that can
> do the fallback with run time detection. Thus the code 
>to do the fallback
> was not compiled in. Frankly, I was not aware that such 
>a case existed
> where one could disable cmpxchg64 in this way and was 
>expecting that the
> runtime detection would always be compiled in for the 
>CMPXCHG_LOCAL case.
> 
> 
Thus, things gone wrong because it's only half-consequent. 
One should compile everything, and at runtime the kernel 
itself detect the existing hardware and decides/uses just 
what it need.





My (and many other users) mind on configuration is very 
simple: I switch everything on, so that the kernel has 
everything available, and in run-time it uses just what's 
existing on the individual computer of the user.

Just if there occured an human configuration error, so 
that something at run-time wasnt available, then one 
should improve the above explained manner of use, reducing 
human need/influence, compiling everything, and improving 
the kernel's runtime detection and use/selection of its 
adequade modules.

I saw plenty people (specially, beginners) loosing all 
their files by overformating or repartitioning the 
harddisk within a too-complicated installer.  Many 
interactive installers are not good understandable.  And 
many simple users don't know nothing about harddisks, 
partitions, etc. You know all details inside your 
washmachine, and you need to know it for use it ?? Linux 
has to work also for stupid people.  Thus, the 
partitioning / formatting process of the installation is a 
good example what CAN and HAS TO BE full-automatized, in 
order to reduce human errors.  If a typical distro is 5 GB 
or 20 GB big, then the installer can and has to manage it, 
silently and alone, to find or desocupy this space (and 
more if possible) anywhere on a harddisk, silently and by 
itself, so that it installs problemless for beginners 
(while 'specialists' before the installation can desocupy 
a certain space of the harddisk which then the installer 
will find and use).

90% of the config options, users don't know for what they 
are.  Instead of more and more new config features in, 
 EVERY CONFIG PARAMETER WHAT THE KERNEL CAN DETECT AT RUN 
TIME (at the beginning of booting) SHOULD BE THROWED OUT. 
And the kernel should be compiled 'everythingyes' as 
default.   Even then, with all exotic (but nowadays 
happening) boot-necessary input/output hardware included, 
 my vmlinuz is only 10 MB big.   Sufficient memory for run 
this (together with an initrd for an installer) nowadays 
should exist on almost all computers.  All other, not-boot 
necessary modules are perhaps 50 MB, and since the Atari 
time with 20 MB harddisks passed, there is NO REASON FOR 
COMPILE SMALL THE KERNEL. Even on Android phones, 
compiling the kernel / modules 50 MB big but using often 
only a part, dont hurt. But for emergency, instead of 
completely configless, one could let 2 options for the 
kernel config:  normal, small (below 16 M memory). 
   Provisorically, one could but one should not include 
such a raw-selection menu in the kernel config, because to 
check and maintain the dependences of their various single 
config parameters would be big extra work.   Instead of 
this, one should rigorously make more and more config 
parameters definitively obsolete and reduce them by 
improving the corresponding runtime ability of the kernel.
---
Professional hosting for everyone - http://www.host.ru
