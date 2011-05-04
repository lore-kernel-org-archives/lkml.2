Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013Ab1EDOE0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 10:04:26 -0400
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:46346 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753978Ab1EDOEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 10:04:24 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: 9xhwyxUVM1mZPw2eDTYrkLj0YPIC7ve1z5XWHH3oc65ljQi
 y5ld1FR3LCn.wbDBtSts_4ULLvCxYukXQvelfabVefOwIx9VxpUaFVTGesgb
 TG1m3Ud0JQv6ei0ixlXLIQaf_bBRB1DJaUUOlZP4egIs41IeFG99Iv3lcIe9
 E9pLqHol_cUc6ngVfdfGbQt0cmUEjdPT_.IMTMVwGpP5xenMu4sg1AXF8.Yn
 gaAJh6g.5Or4HPzxp5AUyiWJnpRZzKGc9A70nkaLvP8f40QncVrpv5p1EPyF
 6MpN91d16V2lHBhm2FunZ9EknFKcz42aEQnYr9webYMQnF._N3G0w3Z_ejNa
 GbI5E_bplon9PcgwvntQMjWIU
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 4 May 2011 09:04:19 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Pekka Enberg <penberg@kernel.org>
cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>, werner <w.landgraf@ru.ru>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [block IO crash] Re: 2.6.39-rc5-git2 boot crashs
In-Reply-To: <BANLkTinxe=gSERoOHOohb1V-CZ0c9BSy2Q@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1105040902210.5495@router.home>
References: <web-516671337@zbackend1.aha.ru> <BANLkTikFqF1vzMq3L9zDB=MDnCOFYp+XEQ@mail.gmail.com> <web-516990066@zbackend1.aha.ru> <BANLkTinCKC23WfG7jnd-ihW9kXz-6SEgFQ@mail.gmail.com> <20110503190822.GA20520@elte.hu> <BANLkTi=6_oXX1BM5O3kJ6bVevh9=ydjj3g@mail.gmail.com>
 <20110504083559.GB25724@elte.hu> <alpine.LFD.2.02.1105041124080.3005@ionos> <20110504101932.GA3392@elte.hu> <alpine.LFD.2.02.1105041233280.3005@ionos> <BANLkTinxe=gSERoOHOohb1V-CZ0c9BSy2Q@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463811839-2102679854-1304517862=:5495"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811839-2102679854-1304517862=:5495
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Wed, 4 May 2011, Pekka Enberg wrote:

> > Well, it's pretty simple:
> >
> > CONFIG_X86_CMPXCHG64=3Dy compiles this_cpu_generic_cmpxchg_double() int=
o:
> >
> > =A0 =A028f7: =A0 =A0 =A0 89 f9 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mov =
=A0 =A0%edi,%ecx
> > =A0 =A028f9: =A0 =A0 =A0 8b 3e =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mov =
=A0 =A0(%esi),%edi
> > =A0 =A028fb: =A0 =A0 =A0 89 45 e4 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mov =
=A0 =A0%eax,-0x1c(%ebp)
> > =A0 =A028fe: =A0 =A0 =A0 89 c3 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mov =
=A0 =A0%eax,%ebx
> > =A0 =A02900: =A0 =A0 =A0 8b 45 f0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mov =
=A0 =A0-0x10(%ebp),%eax
> > =A0 =A02903: =A0 =A0 =A0 64 0f c7 0f =A0 =A0 =A0 =A0 =A0 =A0 cmpxchg8b =
%fs:(%edi)
> > =A0 =A02907: =A0 =A0 =A0 0f 94 c0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sete =
=A0 %al
> > =A0 =A0290a: =A0 =A0 =A0 84 c0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 test=
 =A0 %al,%al
> > =A0 =A0290c: =A0 =A0 =A0 88 45 e4 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mov =
=A0 =A0%al,-0x1c(%ebp)
> > =A0 =A0290f: =A0 =A0 =A0 74 a4 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 je =
=A0 =A0 28b5 <kmem_cache_alloc+0x29>
> >
> > while CONFIG_X86_CMPXCHG64=3Dn results in:
> >
> > =A0 =A028b0: =A0 =A0 =A0 8b 03 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mov =
=A0 =A0(%ebx),%eax
> > =A0 =A028b2: =A0 =A0 =A0 64 8b 30 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mov =
=A0 =A0%fs:(%eax),%esi
> > =A0 =A028b5: =A0 =A0 =A0 39 d6 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cmp =
=A0 =A0%edx,%esi
> > =A0 =A028b7: =A0 =A0 =A0 75 d2 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 jne =
=A0 =A0288b <kmem_cache_alloc+0x26>
> > =A0 =A028b9: =A0 =A0 =A0 64 8b 50 04 =A0 =A0 =A0 =A0 =A0 =A0 mov =A0 =
=A0%fs:0x4(%eax),%edx
> > =A0 =A028bd: =A0 =A0 =A0 39 ca =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cmp =
=A0 =A0%ecx,%edx
> > =A0 =A028bf: =A0 =A0 =A0 75 ca =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 jne =
=A0 =A0288b <kmem_cache_alloc+0x26>
> > =A0 =A028c1: =A0 =A0 =A0 8b 4b 14 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mov =
=A0 =A00x14(%ebx),%ecx
> > =A0 =A028c4: =A0 =A0 =A0 8b 0c 0e =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mov =
=A0 =A0(%esi,%ecx,1),%ecx
> > =A0 =A028c7: =A0 =A0 =A0 64 89 08 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mov =
=A0 =A0%ecx,%fs:(%eax)
> > =A0 =A028ca: =A0 =A0 =A0 8b 03 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mov =
=A0 =A0(%ebx),%eax
> > =A0 =A028cc: =A0 =A0 =A0 42 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
inc =A0 =A0%edx
> > =A0 =A028cd: =A0 =A0 =A0 64 89 50 04 =A0 =A0 =A0 =A0 =A0 =A0 mov =A0 =
=A0%edx,%fs:0x4(%eax)
> >
> > And that code runs with preemption enabled. So when the task gets
> > preempted _BEFORE_ it has actuallty written back the data, then the
> > race window is wide open.
> >
> > I'm still trying to understand that macro hell which actually
> > generates that code. I always thought that George Anzingers macro maze
> > was horrible, but that's even worse.
>
> I'm adding Christoph and Tejun to CC.

The above should not happen. If a kernel config indicates that there is no
cmpxchg16b/cmpxchg8b available then we need to not compile the path that
uses cmpxchg8b/cmpxchg16b. Guess we need CMPXCHG_DOUBLE_LOCAL or so.



---1463811839-2102679854-1304517862=:5495--
