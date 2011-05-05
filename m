Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752952Ab1EETxw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 15:53:52 -0400
Received: from zfrontend1.aha.ru ([195.2.83.147]:51808 "EHLO zfrontend1.aha.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752563Ab1EETxv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 15:53:51 -0400
X-iZenGuard: ZMAIL
From: "werner" <w.landgraf@ru.ru>
Subject: Re: [block IO crash] Re: 2.6.39-rc5-git2 boot crashs
To: Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>, werner <w.landgraf@ru.ru>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
X-Mailer: CommuniGate Pro WebUser Interface v.4.3.12
Date: Thu, 05 May 2011 15:53:47 -0400
Message-ID: <web-518794926@zbackend1.aha.ru>
In-Reply-To: <20110505095421.GD30950@htj.dyndns.org>
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
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 May 2011 11:54:21 +0200
  Tejun Heo <tj@kernel.org> wrote:
> Hey,
> 
> On Wed, May 04, 2011 at 11:40:33PM +0200, Thomas 
>Gleixner wrote:
>> Yeah, I tripped over that as well. And the new shiny 
>>extra
>> CONFIG_CMPXCHG_DOUBLE misfeature Christoph nailed 
>>together is just
>> ignoring it as well. It's just more useless #ifdef and 
>>CONFIG bloat.
>> 
>> That whole this_cpu_* stuff seems to be designed by 
>>committee. A quick
>> grep shows that max. 10% of the implemented macro hell 
>>is actually
>> used. Can we get rid of all unused ones and bring them 
>>back when they
>> are actually required?
> 
> What happened there was more of lack of design rather 
>than too much
> design. 


........


 From the sight of an user, not of an programmer, my 
opinion about more and more config options and the design 
is:

    As the 1st step, for can be compiled generic kernels 
at all, the kernel should have (and has) the ability, to 
discover at run-time , what hardware the individual user 
has, and to use only the corresponding kernel subroutines. 
 F.ex. if subroutines for ELAN or MOORESTON were compiled 
also, then the kernel ignore them simply, if on run-time 
it discovers that the user has a 486 computer.

    Then, in a 2nd step considering this, any 
configuration of the arch is becoming obsolete and should 
be reduced so much as possible.   It was useful in the 
time of papertapes and punched cards to can pick out what 
one need, but nowaday we have enough memory that the 
kernel can be compiled ALWAYS including everything, and on 
run-time the kernel discovers and use only what's present. 
  For the case if users in poorer countries have a 486 
with 8 MB storage (long time ago I used Slackware on such 
computers), one should CAN alternatively choice to compile 
and deliver also small kernels.  But as default - or 
spoken more generally if is compiled a huge kernel - then 
at run-time it simply should ignore what's absent and used 
what's present.  This means, in this general case, ANY 
user configuration of hardware is obsolete, and as default 
should be compiled everything (and into the kernel, not as 
module, in-/output devices which nowadays can happen as 
boot devices inclusive for an installation).  One should 
reduce the configuration to a very few number of basical 
items - such as, with/without PEA;  low-memory system 
(that parameter is the only what matters for make 
impossible an huge everythingyes kernel); slow system.

    There is a very good analogon to this.    Some distros 
have a very complicated configurator, difficult for 
advanced user and impossible to install Linux for 
beginners.  F.ex., SUSE has an elefantous poissen-green 
installer, with thousands of options and very 
mis-understandable, in what I (trying to help someone two 
weeks ago) was unable to create an install/root partition 
without to be sure not to loose the existing partition. 
 This is a complete misconcept, hinders people to use 
Linux, put users in risk by a mistake loose his existing 
partition/files, and should be dumped completely !!! 
 Principally, the installation can be automatical and 
 thus have to be automatical; little adaptions the user 
can make later in the KDE control center. My distro, 
intended to be maximal easy, has no interactive installer 
 at all, and produces a very good working system in 99% of 
the cases, full-automatically.    For example, for what 
any partition configuration ??   The 1:4 LZMA-packed iso, 
unfold, gives a 20 GB system.   Thus, the install program 
can search alone where to find 20 GB, without any question 
to the user.  It searches  on the primary, then on the 
secondary hard disk for 20GB unpartioned space; if not 
found, then it resizes and/or moves existing partitions to 
get 20 GB free, and then install the sistem. If really all 
disks are full with files, it goes in the rescue system 
with mc , and the user should delete some videos etc and 
restart the instellation.  Even the keyboard language, 
system language, user name, internet id/passwords are 
found and installed automatically - the install program 
reads them out from any (in 99% existing) pre-existing 
Windows, Linux or Minix installation on the computer.

    Thus, when I read many comments here in the kernel 
threads, I  feel that the most kernel configs should be 
removed and the kernel should find out itself at run time 
what hardware is existing. Also, the functions of things 
like udev and hal should be automatized.  It is a sick 
concept, that the kernel itself find all hardware, but one 
need an externel program like hal to interprete the kernel 
messages and install the hardware, what the kernel can and 
should do itself. Each kernel version simply should 
include an updated table,  of existing/known hardware and 
their most adequade Linux drivers, and then, during 
identifying hardware at boot or hotplug, set up everything 
to use it.

    The kernel is becoming more and more complicated, and 
before people loosing themselves in details, one should 
make it most easy possible, for the users and for the 
maintainers, and throw out unnecessary and too complicated 
or misconcepted things.  Because at the same time more and 
more new hardware surges, and also the kernel config 
becomes more and more big, there is no alternative and 
should be started most early possible, to automatize and 
improve the kernel's runtime autoconfig and 
auto-hardware-managing habilities. And REDUCE THE 
HUMAN-DEPENDING PRE-CONFIG TO THE MINIMUM POSSIBLE. This 
satisfies also that Linux is tecnically good, but have to 
become more easy for the use-by-anybody.   This should be 
considered for the whole politics/direction in what is 
going the kernel development.

---
Professional hosting for everyone - http://www.host.ru

